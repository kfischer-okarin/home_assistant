import './stock.dart';

abstract class StockItemRepository {
  Iterable<StockItem> get values;
}
