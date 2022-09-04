import 'dart:convert';
import 'dart:io';

import 'package:home_assistant/domain/event.dart';
import 'package:home_assistant/domain/event_repository.dart';

class LocalJSONFileEventRepository extends EventRepository {
  final File file;
  final List<Event> _events = [];
  final List<EventConsumer> _consumers = [];

  LocalJSONFileEventRepository(this.file) {
    if (file.existsSync()) {
      final json = jsonDecode(file.readAsStringSync());
      for (final eventJson in json) {
        _events.add(Event.fromJson(eventJson));
      }
    }
  }

  @override
  void add(Event event) {
    _events.add(event);
    for (final consumer in _consumers) {
      consumer.processEvent(event);
    }
    file.writeAsStringSync(jsonEncode(_events));
  }

  @override
  Iterator<Event> get iterator {
    return _events.iterator;
  }

  @override
  void subscribe(EventConsumer consumer) {
    _consumers.add(consumer);
  }
}
