import 'event.dart';
import 'event_repository.dart';
import 'stock_item_repository.dart';
import 'stock.dart';

class EventSourcedStockItemRepository extends StockItemRepository
    implements EventConsumer {
  final List<StockItem> _stockItems = [];

  EventSourcedStockItemRepository(EventRepository eventRepository) {
    eventRepository.subscribe(this);
    for (final event in eventRepository) {
      processEvent(event);
    }
  }

  @override
  get values => _stockItems;

  @override
  void processEvent(Event event) {
    if (event is StockItemAdded) {
      _stockItems.add(StockItem(
          id: StockItemId(event.itemId),
          name: event.name,
          amount: Amount(event.amount, Unit.parse(event.amountUnit)),
          bestBefore: event.bestBefore));
    }
  }
}
