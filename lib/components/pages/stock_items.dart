import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:home_assistant/domain/stock_service.dart';

class StockItems extends StatefulWidget {
  const StockItems({Key? key}) : super(key: key);

  @override
  State<StockItems> createState() => _StockItemsState();
}

class _StockItemsState extends State<StockItems> {
  @override
  Widget build(BuildContext context) {
    final stockService = Provider.of<StockService>(context);
    final stockItems = stockService.listStockItems();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Items'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: stockItems.length,
          itemBuilder: (context, index) {
            final item = stockItems[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.amount.toString()),
              trailing: Text(DateFormat.yMd().format(item.bestBefore)),
            );
          }),
    );
  }
}
