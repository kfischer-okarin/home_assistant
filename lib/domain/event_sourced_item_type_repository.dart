import 'event.dart';
import 'event_repository.dart';
import 'item_type_repository.dart';
import 'stock.dart';

class EventSourcedItemTypeRepository extends ItemTypeRepository
    implements EventConsumer {
  final List<ItemType> _itemTypes = [];

  EventSourcedItemTypeRepository(EventRepository eventRepository) {
    eventRepository.subscribe(this);
    for (final event in eventRepository) {
      processEvent(event);
    }
  }

  @override
  get values => _itemTypes;

  @override
  void processEvent(Event event) {
    if (event is ItemTypeAdded) {
      _itemTypes.add(ItemType(
          id: ItemTypeId(event.itemTypeId),
          name: event.name,
          defaultUnit: Unit.parse(event.defaultUnit)));
    }
    _itemTypes.sort((a, b) => a.name.compareTo(b.name));
  }
}
