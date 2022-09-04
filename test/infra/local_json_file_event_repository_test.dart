import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_assistant/domain/event.dart';

import 'package:home_assistant/infra/local_json_file_event_repository.dart';

void main() {
  final file = File('${Directory.systemTemp.path}/events.json');

  tearDown(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('add an event', () {
    final repository = LocalJSONFileEventRepository(file);

    repository.add(StockItemAdded(
        const EventId('abc'), DateTime(2022, 9, 4, 12),
        itemId: 'def',
        name: 'Butter',
        amount: 200,
        amountUnit: 'g',
        bestBefore: DateTime(2022, 9, 18)));

    expect(
        file.readAsStringSync(),
        jsonEncode([
          {
            'id': 'abc',
            'timestamp': '2022-09-04T12:00:00.000',
            'type': 'StockItemAdded',
            'itemId': 'def',
            'name': 'Butter',
            'amount': 200.0,
            'amountUnit': 'g',
            'bestBefore': '2022-09-18T00:00:00.000'
          }
        ]));
  });

  test('iterate over all events', () {
    final repository = LocalJSONFileEventRepository(file);

    final event1 = StockItemAdded(
        const EventId('abc'), DateTime(2022, 9, 4, 12),
        itemId: 'def',
        name: 'Butter',
        amount: 200,
        amountUnit: 'g',
        bestBefore: DateTime(2022, 9, 18));
    final event2 = StockItemAdded(
        const EventId('ghi'), DateTime(2022, 9, 4, 12),
        itemId: 'jkl',
        name: 'Milk',
        amount: 1000,
        amountUnit: 'ml',
        bestBefore: DateTime(2022, 9, 18));
    repository.add(event1);
    repository.add(event2);

    expect(repository.toList(), [event1, event2]);
  });

  test('reads existing events', () {
    file.writeAsStringSync(jsonEncode([
      {
        'id': 'abc',
        'timestamp': '2022-09-04T12:00:00.000',
        'type': 'StockItemAdded',
        'itemId': 'def',
        'name': 'Butter',
        'amount': 200.0,
        'amountUnit': 'g',
        'bestBefore': '2022-09-18T00:00:00.000'
      }
    ]));

    final repository = LocalJSONFileEventRepository(file);

    expect(repository.toList(), [
      StockItemAdded(const EventId('abc'), DateTime(2022, 9, 4, 12),
          itemId: 'def',
          name: 'Butter',
          amount: 200,
          amountUnit: 'g',
          bestBefore: DateTime(2022, 9, 18))
    ]);
  });
}
