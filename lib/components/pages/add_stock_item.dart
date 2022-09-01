import 'package:flutter/material.dart';

import './add_stock_item/stock_item_form.dart';

class AddStockItem extends StatelessWidget {
  const AddStockItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Item'),
      ),
      body: const Center(child: StockItemForm()),
    );
  }
}
