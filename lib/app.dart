import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:home_assistant/components/pages/home.dart';
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
            primarySwatch: Colors.blue,
          ),
          home: const Home(),
        ));
  }
}
