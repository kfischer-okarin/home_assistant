import 'package:flutter/material.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:home_assistant/domain/stock.dart';
import 'package:provider/provider.dart';

import './add_item_type.dart';

class ItemTypes extends StatefulWidget {
  const ItemTypes({Key? key}) : super(key: key);

  @override
  State<ItemTypes> createState() => _ItemTypesState();
}

class _ItemTypesState extends State<ItemTypes> {
  List<ItemType> _itemTypes = [];

  @override
  void initState() {
    super.initState();
    _loadItemTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _itemTypes.length,
            itemBuilder: (context, index) {
              final itemType = _itemTypes[index];
              return ListTile(
                title: Text(itemType.name),
                subtitle:
                    Text("Unit: ${itemType.defaultUnit.humanReadableLabel}"),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddItemType(),
              ),
            );
            _loadItemTypes();
          },
          tooltip: 'Add Item Type',
          child: const Icon(Icons.add),
        ));
  }

  void _loadItemTypes() async {
    final service = Provider.of<HomeAssistantService>(context, listen: false);
    final itemTypes = service.listItemTypes();
    setState(() {
      _itemTypes = itemTypes;
    });
  }
}
