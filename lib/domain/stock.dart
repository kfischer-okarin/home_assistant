import 'package:home_assistant/util.dart';
import 'package:meta/meta.dart';

class StockItem extends Equatable {
  final StockItemId id;
  final String name;
  final Amount amount;
  final DateTime bestBefore;

  const StockItem(
      {required this.id,
      required this.name,
      required this.amount,
      required this.bestBefore});

  StockItem.build({required name, required amount, required bestBefore})
      : this(
            id: StockItemId.generate(),
            name: name,
            amount: amount,
            bestBefore: bestBefore);

  @override
  List<Object?> get props => [name, amount, bestBefore];
}

class StockItemId extends Id {
  const StockItemId(super.value);

  StockItemId.generate() : super.generate();
}

class ItemType extends Equatable {
  final ItemTypeId id;
  final String name;
  final Unit defaultUnit;

  const ItemType(
      {required this.id, required this.name, required this.defaultUnit});

  ItemType.build({required name, required defaultUnit})
      : this(id: ItemTypeId.generate(), name: name, defaultUnit: defaultUnit);

  @override
  List<Object?> get props => [id, name, defaultUnit];
}

class ItemTypeId extends Id {
  const ItemTypeId(super.value);

  ItemTypeId.generate() : super.generate();
}

@immutable
class Amount extends Equatable {
  final double amount;
  final Unit unit;

  const Amount(this.amount, this.unit);

  static Amount parse(String string) {
    final amountRegExp = RegExp(r'^([\d\.]+)(\w+)$');
    final match = amountRegExp.firstMatch(string);
    if (match == null) {
      throw 'Invalid amount: $string';
    }

    final numberPart = match.group(1)!;
    final unitPart = match.group(2)!;

    return Amount(double.parse(numberPart), Unit.parse(unitPart));
  }

  @override
  String toString() {
    return '$amount${unit.symbol}';
  }

  @override
  List<Object?> get props => [amount, unit];
}

// Unit<T extends UnitType>
// Unit<BaseUnit>
// Unit<DerivedUnit>

enum Unit {
  gram('g'),
  mililiter('ml'),
  piece('');

  final String symbol;

  const Unit(this.symbol);

  static Unit parse(String string) {
    for (final unit in Unit.values) {
      if (string == unit.symbol) {
        return unit;
      }
    }

    throw 'Invalid unit: $string';
  }

  String get humanReadableLabel {
    switch (this) {
      case Unit.piece:
        return 'pieces';
      default:
        return symbol;
    }
  }
}
