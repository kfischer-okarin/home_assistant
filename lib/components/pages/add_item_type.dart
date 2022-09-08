import 'package:flutter/material.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:provider/provider.dart';

import './add_item_type/item_type_form.dart';

class AddItemType extends StatelessWidget {
  const AddItemType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<HomeAssistantService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item Type'),
      ),
      body: Center(child: ItemTypeForm(
        onSubmit: ({required name, required defaultUnit}) async {
          service.addItemType(name: name, defaultUnit: defaultUnit);
          Navigator.pop(context);
        },
      )),
    );
  }
}
