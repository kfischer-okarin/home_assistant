import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:home_assistant/domain/stock.dart';

class StockItemForm extends StatefulWidget {
  final void Function(
      {required String itemName,
      required Amount amount,
      required DateTime bestBefore})? onSubmit;

  const StockItemForm({super.key, this.onSubmit});

  @override
  State<StockItemForm> createState() => _StockItemFormState();
}

class _StockItemFormState extends State<StockItemForm> {
  String _itemName = '';
  Amount? _amount;
  DateTime? _bestBefore;

  @override
  Widget build(BuildContext context) {
    final allValuesSet =
        _itemName.isNotEmpty && _amount != null && _bestBefore != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item',
              ),
              onChanged: (value) {
                setState(() {
                  _itemName = value;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                  suffixText: 'g'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = Amount(double.parse(value), Unit.gram);
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              dateMask:
                  DateFormat.yMd(Localizations.localeOf(context).languageCode)
                      .pattern,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Best Before',
              ),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (value) {
                setState(() {
                  _bestBefore = DateTime.parse(value);
                });
              },
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
      widget.onSubmit!(
          itemName: _itemName, amount: _amount!, bestBefore: _bestBefore!);
    }
  }
}
