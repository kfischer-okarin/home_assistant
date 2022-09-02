import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './dsl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
