import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_assistant/domain/stock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:home_assistant/infra/local_json_file_stock_item_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProviderPlatform();
  });

  tearDown(() async {
    final file = await _getFile('database.json');
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('values when file does not exist', () async {
    final repository = LocalJSONFileStockItemRepository('database.json');
    await repository.load();

    expect(repository.values, isEmpty);
  });

  test('values', () async {
    final file = await _getFile('database.json');
    file.writeAsStringSync(jsonEncode([
      {'itemName': 'Butter', 'amount': '200g', 'bestBefore': '2022-09-14'},
      {'itemName': 'Cheese', 'amount': '150g', 'bestBefore': '2022-10-01'}
    ]));

    final repository = LocalJSONFileStockItemRepository('database.json');
    await repository.load();

    expect(repository.values, [
      StockItem(
          name: 'Butter',
          amount: const Amount(200, Unit.gram),
          bestBefore: DateTime(2022, 9, 14)),
      StockItem(
          name: 'Cheese',
          amount: const Amount(150, Unit.gram),
          bestBefore: DateTime(2022, 10, 1))
    ]);
  });
}

Future<File> _getFile(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$fileName');
}

class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/tmp';
  }
}
