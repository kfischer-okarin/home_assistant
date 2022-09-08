import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './dsl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Item Types', () {
    acceptanceTest('Added item types should be visible in the item type list',
        (dsl) async {
      await dsl.addItemType('Milk', defaultUnit: 'ml');
      await dsl.addItemType('Butter', defaultUnit: 'g');

      final itemTypes = await dsl.listItemTypes();
      expect(itemTypes, [
        {'name': 'Butter', 'defaultUnit': 'g'},
        {'name': 'Milk', 'defaultUnit': 'ml'}
      ]);
    });
  });

  acceptanceTest('Added stock items should be visible in the stock overview',
      (dsl) async {
    await dsl.addStockItem('Butter', amount: '200g', bestBefore: '2022-09-14');
    await dsl.addStockItem('Cheese', amount: '150g', bestBefore: '2022-10-01');

    final stockItems = await dsl.listStockItems();
    expect(stockItems, [
      {'type': 'Butter', 'amount': '200.0g', 'bestBefore': '2022-09-14'},
      {'type': 'Cheese', 'amount': '150.0g', 'bestBefore': '2022-10-01'}
    ]);
  });
}
