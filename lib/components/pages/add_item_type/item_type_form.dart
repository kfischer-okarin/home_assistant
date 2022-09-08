import 'package:flutter/material.dart';

import 'package:home_assistant/domain/stock.dart';

class ItemTypeForm extends StatefulWidget {
  final void Function({required String name, required Unit defaultUnit})?
      onSubmit;

  const ItemTypeForm({super.key, this.onSubmit});

  @override
  State<ItemTypeForm> createState() => _ItemTypeFormState();
}

class _ItemTypeFormState extends State<ItemTypeForm> {
  String _name = '';
  Unit _defaultUnit = Unit.gram;

  @override
  Widget build(BuildContext context) {
    final allValuesSet = _name.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<Unit>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Default Unit',
              ),
              value: _defaultUnit,
              onChanged: (Unit? value) {
                setState(() {
                  _defaultUnit = value!;
                });
              },
              items: Unit.values.map<DropdownMenuItem<Unit>>((Unit value) {
                return DropdownMenuItem<Unit>(
                  value: value,
                  child: Text(value.humanReadableLabel),
                );
              }).toList(),
            )),
        Expanded(child: Container()),
        ElevatedButton(
            onPressed: allValuesSet ? _submitValues : null,
            child: const Text('Add'))
      ],
    );
  }

  void _submitValues() {
    if (widget.onSubmit != null) {
      widget.onSubmit!(name: _name, defaultUnit: _defaultUnit);
    }
  }
}
