import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_assistant/domain/stock.dart';

import 'package:home_assistant/infra/local_json_file_stock_item_repository.dart';

void main() {
  final file = File('${Directory.systemTemp.path}/database.json');

  tearDown(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('values when file does not exist', () {
    final repository = LocalJSONFileStockItemRepository(file);

    expect(repository.values, isEmpty);
  });

  test('values', () {
    file.writeAsStringSync(jsonEncode([
      {
        'id': 'abc',
        'itemName': 'Butter',
        'amount': '200g',
        'bestBefore': '2022-09-14'
      },
      {
        'id': 'def',
        'itemName': 'Cheese',
        'amount': '150g',
        'bestBefore': '2022-10-01'
      }
    ]));

    final repository = LocalJSONFileStockItemRepository(file);

    expect(repository.values, [
      StockItem(
          id: const StockItemId('abc'),
          name: 'Butter',
          amount: const Amount(200, Unit.gram),
          bestBefore: DateTime(2022, 9, 14)),
      StockItem(
          id: const StockItemId('def'),
          name: 'Cheese',
          amount: const Amount(150, Unit.gram),
          bestBefore: DateTime(2022, 10, 1))
    ]);
  });
}
