import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/domain/stock_service.dart';
import 'package:home_assistant/infra/local_json_file_stock_item_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final repository = LocalJSONFileStockItemRepository(
      File('${documentsDirectory.path}/stock_items.json'));
  final service = StockService(repository);
  runApp(App(service));
}
