import 'event.dart';
import 'event_repository.dart';
import 'stock.dart';
import 'stock_item_repository.dart';

class HomeAssistantService {
  final EventRepository _eventRepository;
  final StockItemRepository _stockItemRepository;

  HomeAssistantService(this._eventRepository, this._stockItemRepository);

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
