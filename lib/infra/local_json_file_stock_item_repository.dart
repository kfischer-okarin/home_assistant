import 'dart:convert';
import 'dart:io';

import 'package:home_assistant/domain/stock_item_repository.dart';
import 'package:home_assistant/domain/stock.dart';

class LocalJSONFileStockItemRepository extends StockItemRepository {
  final File file;
  final List<StockItem> _stockItems = [];

  LocalJSONFileStockItemRepository(this.file) {
    if (file.existsSync()) {
      final json = jsonDecode(file.readAsStringSync());
      _stockItems.addAll(json.map<StockItem>((item) => StockItem(
            id: StockItemId(item['id']),
            name: item['itemName'],
            amount: Amount.parse(item['amount']),
            bestBefore: DateTime.parse(item['bestBefore']),
          )));
    }
  }

  @override
  get values => _stockItems;
}
