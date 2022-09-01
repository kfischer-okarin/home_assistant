import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class AddStockItem extends StatelessWidget {
  const AddStockItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Item'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Item',
                  ),
                )),
            const Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                  ),
                  keyboardType: TextInputType.number,
                )),
            Padding(
                padding: const EdgeInsets.all(8),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Best Before',
                  ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                )),
            Expanded(child: Container()),
            ElevatedButton(onPressed: () {}, child: const Text('Add'))
          ],
        ),
      ),
    );
  }
}
