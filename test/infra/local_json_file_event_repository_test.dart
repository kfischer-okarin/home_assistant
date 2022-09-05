import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_assistant/domain/event.dart';
import 'package:home_assistant/domain/event_repository.dart';

import 'package:home_assistant/infra/local_json_file_event_repository.dart';

import '../test_helper.dart';

void main() {
  test('add an event', () {
    final file = createTempFile();
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
    final repository = LocalJSONFileEventRepository(createTempFile());

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
    final file = createTempFile();
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

  test('notifies consumers', () {
    final repository = LocalJSONFileEventRepository(createTempFile());
    final consumer = TestConsumer();
    repository.subscribe(consumer);
    final event = StockItemAdded(const EventId('abc'), DateTime(2022, 9, 4, 12),
        itemId: 'def',
        name: 'Butter',
        amount: 200,
        amountUnit: 'g',
        bestBefore: DateTime(2022, 9, 18));

    repository.add(event);

    expect(consumer.processedEvents, [event]);
  });
}

class TestConsumer extends EventConsumer {
  final List<Event> processedEvents = [];

  @override
  void processEvent(Event event) {
    processedEvents.add(event);
  }
}
