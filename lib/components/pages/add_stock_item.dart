import 'package:flutter/material.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:provider/provider.dart';

import './add_stock_item/stock_item_form.dart';

class AddStockItem extends StatelessWidget {
  const AddStockItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<HomeAssistantService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Item'),
      ),
      body: Center(child: StockItemForm(
        onSubmit: (
            {required amount, required bestBefore, required itemName}) async {
          service.addStockItem(
              amount: amount, bestBefore: bestBefore, name: itemName);
          Navigator.pop(context);
        },
      )),
    );
  }
}
