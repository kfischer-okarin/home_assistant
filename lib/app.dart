import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:home_assistant/components/pages/item_types.dart';
import 'package:home_assistant/components/pages/stock_items.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';

class App extends StatelessWidget {
  final HomeAssistantService _service;
  final Locale? locale;

  const App(this._service, {Key? key, this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
        value: _service,
        child: MaterialApp(
            title: 'Home Assistant',
            locale: locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('de', ''),
              Locale('ja', ''),
            ],
            theme: ThemeData(
              tabBarTheme: const TabBarTheme(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
              primarySwatch: Colors.blue,
            ),
            home: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Home Assistant'),
                  ),
                  bottomNavigationBar: const BottomAppBar(
                    child: TabBar(tabs: [
                      Tab(icon: Icon(Icons.kitchen)),
                      Tab(icon: Icon(Icons.menu_book)),
                    ]),
                  ),
                  body: const TabBarView(
                    children: [
                      StockItems(),
                      ItemTypes(),
                    ],
                  ),
                ))));
  }
}
