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

enum Unit {
  gram('g');

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
}
