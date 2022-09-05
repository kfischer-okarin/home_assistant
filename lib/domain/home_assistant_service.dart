import 'event.dart';
import 'event_repository.dart';
import 'stock.dart';
import 'event_sourced_stock_item_repository.dart';

class HomeAssistantService {
  final EventRepository _eventRepository;
  late final EventSourcedStockItemRepository _stockItemRepository;

  HomeAssistantService(this._eventRepository) {
    _stockItemRepository = EventSourcedStockItemRepository(_eventRepository);
  }

  void addStockItem(
      {required String name,
      required Amount amount,
      required DateTime bestBefore}) {
    _eventRepository.add(StockItemAdded.build(
        itemId: StockItemId.generate().value,
        name: name,
        amount: amount.amount,
        amountUnit: amount.unit.symbol,
        bestBefore: bestBefore));
  }

  List<StockItem> listStockItems() {
    return _stockItemRepository.values.toList();
  }
}
