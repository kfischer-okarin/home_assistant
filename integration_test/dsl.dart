import 'package:flutter_test/flutter_test.dart';
import 'package:things_at_home/stock.dart';

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
      } catch (e) {
        // ignore: avoid_print
        print(e);
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
      String itemName, Amount amount, DateTime bestBefore) async {}

  @override
  Future<List<Map<String, Object>>> listStockItems() async {
    return [];
  }
}
