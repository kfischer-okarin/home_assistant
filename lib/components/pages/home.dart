import 'package:flutter/material.dart';

import './add_stock_item.dart';
import './stock_items.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Assistant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStockItem(),
                      ),
                    );
                  },
                  child: const Text('Add Stock Item'),
                )),
            Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StockItems(),
                      ),
                    );
                  },
                  child: const Text('List Stock Items'),
                )),
          ],
        ),
      ),
    );
  }
}
