import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/domain/stock_item_repository.dart';
import 'package:home_assistant/domain/stock.dart';

class LocalJSONFileStockItemRepository extends StockItemRepository {
  final String filename;
  Iterable<StockItem> _values = [];

  LocalJSONFileStockItemRepository(this.filename);

  @override
  get values => _values;

  Future<void> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    List<dynamic> contents = [];
    if (file.existsSync()) {
      contents = jsonDecode(file.readAsStringSync());
    }
    _values = contents.map<StockItem>((item) => StockItem(
          name: item['itemName'],
          amount: Amount.parse(item['amount']),
          bestBefore: DateTime.parse(item['bestBefore']),
        ));
  }
}
