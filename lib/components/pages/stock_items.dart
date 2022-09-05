import 'package:flutter/material.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:home_assistant/domain/stock.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './add_stock_item.dart';

class StockItems extends StatefulWidget {
  const StockItems({Key? key}) : super(key: key);

  @override
  State<StockItems> createState() => _StockItemsState();
}

class _StockItemsState extends State<StockItems> {
  List<StockItem> _stockItems = [];

  @override
  void initState() {
    super.initState();
    _loadStockItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _stockItems.length,
            itemBuilder: (context, index) {
              final item = _stockItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.amount.toString()),
                trailing: Text(
                    DateFormat.yMd(Localizations.localeOf(context).languageCode)
                        .format(item.bestBefore)),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddStockItem(),
              ),
            );
            _loadStockItems();
          },
          tooltip: 'Add Stock Item',
          child: const Icon(Icons.add),
        ));
  }

  void _loadStockItems() async {
    final service = Provider.of<HomeAssistantService>(context, listen: false);
    final stockItems = service.listStockItems();
    setState(() {
      _stockItems = stockItems;
    });
  }
}
