import 'stock.dart';
import 'stock_item_repository.dart';

class StockService {
  final StockItemRepository _stockItemRepository;

  StockService(this._stockItemRepository);

  List<StockItem> listStockItems() {
    return _stockItemRepository.values.toList();
  }
}
