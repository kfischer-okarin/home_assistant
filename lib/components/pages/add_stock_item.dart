import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import './add_stock_item/stock_item_form.dart';

class AddStockItem extends StatelessWidget {
  const AddStockItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Item'),
      ),
      body: Center(child: StockItemForm(
        onSubmit: (
            {required amount, required bestBefore, required itemName}) async {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/stock_items.json');
          file.writeAsStringSync(jsonEncode([
            {
              'itemName': itemName,
              'amount': amount.toString(),
              'bestBefore': DateFormat('yyyy-MM-dd').format(bestBefore),
            }
          ]));
        },
      )),
    );
  }
}
