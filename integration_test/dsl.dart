import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/domain/stock.dart';
import 'package:home_assistant/domain/stock_service.dart';
import 'package:home_assistant/infra/local_json_file_event_repository.dart';
import 'package:home_assistant/infra/event_sourced_stock_item_repository.dart';

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
  Future<void> addStockItem(
      String itemName, Amount amount, DateTime bestBefore) async {
    await _openApp();
    await tester.tap(find.bySemanticsLabel('Add Stock Item'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Item'), itemName);
    await tester.enterText(
        find.bySemanticsLabel('Amount'), amount.amount.toString());
    await tester.tap(find.bySemanticsLabel('Best Before'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Switch to input'));
    await tester.pumpAndSettle();
    tester.testTextInput.enterText(DateFormat('MM/dd/yyyy').format(bestBefore));
    await tester.tap(find.bySemanticsLabel('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Add'));
    await tester.pumpAndSettle();
  }

  @override
  Future<List<Map<String, dynamic>>> listStockItems() async {
    await _openApp();
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

  Future<void> _openApp() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final eventRepository = LocalJSONFileEventRepository(
        File('${documentsDirectory.path}/events.json'));
    final stockItemRepository =
        EventSourcedStockItemRepository(eventRepository);
    // Add unique key to app to force rebuild
    await tester.pumpWidget(App(
        StockService(eventRepository, stockItemRepository),
        key: UniqueKey(),
        locale: const Locale('en')));
  }
}
