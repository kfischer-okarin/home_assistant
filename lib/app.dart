import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:home_assistant/components/pages/stock_items.dart';
import 'package:home_assistant/domain/stock_service.dart';

class App extends StatelessWidget {
  final StockService _stockService;

  const App(this._stockService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
        value: _stockService,
        child: MaterialApp(
            title: 'Home Assistant',
            theme: ThemeData(
              tabBarTheme: const TabBarTheme(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
              primarySwatch: Colors.blue,
            ),
            home: DefaultTabController(
                length: 1,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Home Assistant'),
                  ),
                  bottomNavigationBar: const BottomAppBar(
                    child: TabBar(tabs: [
                      Tab(icon: Icon(Icons.kitchen)),
                    ]),
                  ),
                  body: const TabBarView(
                    children: [
                      StockItems(),
                    ],
                  ),
                ))));
  }
}
