import 'package:equatable/equatable.dart';

class StockItem extends Equatable {
  final String name;
  final Amount amount;
  final DateTime bestBefore;

  const StockItem(
      {required this.name, required this.amount, required this.bestBefore});

  @override
  List<Object?> get props => [name, amount, bestBefore];

  @override
  bool get stringify => true;
}

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
