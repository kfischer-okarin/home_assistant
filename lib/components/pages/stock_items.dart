import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/domain/stock.dart';

class StockItems extends StatefulWidget {
  const StockItems({Key? key}) : super(key: key);

  @override
  State<StockItems> createState() => _StockItemsState();
}

class _StockItemsState extends State<StockItems> {
  late Future<List<StockItem>> _stockItems;

  Future<List<StockItem>> _getStockItems() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/stock_items.json');
    final contents = jsonDecode(file.readAsStringSync());
    return contents
        .map<StockItem>((item) => StockItem(
              name: item['itemName'],
              amount: Amount.parse(item['amount']),
              bestBefore: DateTime.parse(item['bestBefore']),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _stockItems = _getStockItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Items'),
      ),
      body: FutureBuilder<List<StockItem>>(
          future: _stockItems,
          builder: (context, snapshot) {
            return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    final item = snapshot.data![index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.amount.toString()),
                      trailing: Text(DateFormat.yMd().format(item.bestBefore)),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          }),
    );
  }
}
