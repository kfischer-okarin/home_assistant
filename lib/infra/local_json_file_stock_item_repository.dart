import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/domain/stock_item_repository.dart';
import 'package:home_assistant/domain/stock.dart';

class LocalJSONFileStockItemRepository extends StockItemRepository {
  final String filename;
  late final File _file;

  LocalJSONFileStockItemRepository(this.filename);

  @override
  get values {
    List<dynamic> contents = [];
    if (_file.existsSync()) {
      contents = jsonDecode(_file.readAsStringSync());
    }
    return contents.map<StockItem>((item) => StockItem(
          name: item['itemName'],
          amount: Amount.parse(item['amount']),
          bestBefore: DateTime.parse(item['bestBefore']),
        ));
  }

  Future<void> load() async {
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$filename');
  }
}
