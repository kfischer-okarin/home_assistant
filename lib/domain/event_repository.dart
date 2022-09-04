import 'event.dart';

abstract class EventRepository extends Iterable<Event> {
  void add(Event event);

  @override
  Iterator<Event> get iterator;
}

// Central event store with producers and consumers
// - Consumers can subscribe to events
// - Producers can send events, they are delivered to each consumer's inbox
// - Consumers can read events from their inbox and must acknowledge them
