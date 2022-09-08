import './stock.dart';

abstract class ItemTypeRepository {
  Iterable<ItemType> get values;
}
