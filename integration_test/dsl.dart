import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/domain/stock.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:home_assistant/infra/local_json_file_event_repository.dart';

void acceptanceTest(
    String description, Future<void> Function(AcceptanceTestDSL) callback,
    {dynamic pending = false}) {
  testWidgets(description, (tester) async {
    final driver = _WidgetTesterDriver(tester);
    final dsl = AcceptanceTestDSL(driver);

    if (pending) {
      markTestSkipped(pending is String ? pending : 'Test is pending');

      try {
        await callback(dsl);

        fail('Test is pending but actually passed');
      } on Exception catch (exception, stackTrace) {
        // ignore: avoid_print
        print(exception);
        // ignore: avoid_print
        print(stackTrace);
      }
    } else {
      await callback(dsl);
    }
  });
}

class AcceptanceTestDSL {
  final AcceptanceTestDriver driver;

  AcceptanceTestDSL(this.driver);

  Future<void> addItemType(String name, {String? defaultUnit}) async {
    await driver.addItemType(name, Unit.parse(defaultUnit ?? 'g'));
  }

  Future<List<Map<String, dynamic>>> listItemTypes() async {
    return driver.listItemTypes();
  }

  Future<void> addStockItem(String itemName,
      {required String amount, String? bestBefore}) async {
    await driver.addStockItem(
        itemName,
        Amount.parse(amount),
        bestBefore != null
            ? DateTime.parse(bestBefore)
            : DateTime.now().add(const Duration(days: 14)));
  }

  Future<List<Map<String, dynamic>>> listStockItems() async {
    return driver.listStockItems();
  }
}

abstract class AcceptanceTestDriver {
  Future<void> addItemType(String name, Unit preferredUnit);
  Future<List<Map<String, dynamic>>> listItemTypes();
  Future<void> addStockItem(
      String itemName, Amount amount, DateTime bestBefore);
  Future<List<Map<String, dynamic>>> listStockItems();
}

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final WidgetTester tester;

  _WidgetTesterDriver(this.tester) {
    addTearDown(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/events.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  }

  @override
  Future<void> addItemType(String name, Unit defaultUnit) async {
    await _openItemTypeList();
    await tester.tap(find.bySemanticsLabel('Add Item Type'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Name'), name);
    await tester.tap(find.text('g'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(defaultUnit.humanReadableLabel).last);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Add'));
    await tester.pumpAndSettle();
  }

  @override
  Future<List<Map<String, dynamic>>> listItemTypes() async {
    await _openItemTypeList();
    final listTiles = tester.widgetList(find.byType(ListTile));
    return listTiles.map((widget) {
      final tile = widget as ListTile;
      final subtitle = (tile.subtitle as Text).data!;
      final unit = RegExp(r'Unit: (\w+)').firstMatch(subtitle)!.group(1)!;
      return {'name': (tile.title as Text).data, 'defaultUnit': unit};
    }).toList();
  }

  @override
  Future<void> addStockItem(
      String itemName, Amount amount, DateTime bestBefore) async {
    await _openStockItemList();
    await tester.tap(find.bySemanticsLabel('Add Stock Item'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Item'), itemName);
    await tester.enterText(
        find.bySemanticsLabel('Amount'), amount.amount.toString());
    await tester.tap(find.bySemanticsLabel('Best Before'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Switch to input'));
    await tester.pumpAndSettle();
    tester.testTextInput.enterText(DateFormat('M/d/yyyy').format(bestBefore));
    await tester.tap(find.bySemanticsLabel('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Add'));
    await tester.pumpAndSettle();
  }

  @override
  Future<List<Map<String, dynamic>>> listStockItems() async {
    await _openStockItemList();
    final listTiles = tester.widgetList(find.byType(ListTile));
    return listTiles.map((widget) {
      final tile = widget as ListTile;
      return {
        'type': (tile.title as Text).data,
        'amount': (tile.subtitle as Text).data,
        'bestBefore': DateFormat('yyyy-MM-dd')
            .format(DateFormat.yMd().parse((tile.trailing as Text).data!)),
      };
    }).toList();
  }

  Future<void> _openStockItemList() async {
    await _openAppIfNecessary();
    await tester.tap(find.byIcon(Icons.kitchen));
    await tester.pumpAndSettle();
  }

  Future<void> _openItemTypeList() async {
    await _openAppIfNecessary();
    await tester.tap(find.byIcon(Icons.menu_book));
    await tester.pumpAndSettle();
  }

  Future<void> _openAppIfNecessary() async {
    if (find.byType(App).precache()) {
      return;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final eventRepository = LocalJSONFileEventRepository(
        File('${documentsDirectory.path}/events.json'));
    // Add unique key to app to force rebuild
    await tester.pumpWidget(App(HomeAssistantService(eventRepository),
        key: UniqueKey(), locale: const Locale('en')));
  }
}
