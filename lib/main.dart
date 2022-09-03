import 'package:flutter/material.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/domain/stock_service.dart';
import 'package:home_assistant/infra/local_json_file_stock_item_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = LocalJSONFileStockItemRepository('stock_items.json');
  await repository.load();
  final service = StockService(repository);
  runApp(App(service));
}
