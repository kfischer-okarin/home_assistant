import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/stock.dart';

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

  Future<List<Map<String, Object>>> listStockItems() async {
    return driver.listStockItems();
  }
}

abstract class AcceptanceTestDriver {
  Future<void> addStockItem(
      String itemName, Amount amount, DateTime bestBefore);
  Future<List<Map<String, Object>>> listStockItems();
}

class _WidgetTesterDriver implements AcceptanceTestDriver {
  final WidgetTester tester;

  _WidgetTesterDriver(this.tester);

  @override
  Future<void> addStockItem(
      String itemName, Amount amount, DateTime bestBefore) async {
    await tester.pumpWidget(const App());
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
  }

  @override
  Future<List<Map<String, Object>>> listStockItems() async {
    return [];
  }
}
