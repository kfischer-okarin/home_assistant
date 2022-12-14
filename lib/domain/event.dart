import 'package:home_assistant/util.dart';
import 'package:meta/meta.dart';

class ItemTypeAdded extends Event {
  final String itemTypeId;
  final String name;
  final String defaultUnit;

  const ItemTypeAdded(super.id, super.timestamp,
      {required this.itemTypeId,
      required this.name,
      required this.defaultUnit});

  ItemTypeAdded.build(
      {required this.itemTypeId, required this.name, required this.defaultUnit})
      : super.build();

  @override
  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result.addAll({
      'itemTypeId': itemTypeId,
      'name': name,
      'defaultUnit': defaultUnit,
    });
    return result;
  }

  @override
  List<Object?> get props => [id, timestamp, itemTypeId, name, defaultUnit];
}

class StockItemAdded extends Event {
  final String itemId;
  final String name;
  final double amount;
  final String amountUnit;
  final DateTime bestBefore;

  const StockItemAdded(super.id, super.timestamp,
      {required this.itemId,
      required this.name,
      required this.amount,
      required this.amountUnit,
      required this.bestBefore});

  StockItemAdded.build(
      {required this.itemId,
      required this.name,
      required this.amount,
      required this.amountUnit,
      required this.bestBefore})
      : super.build();

  @override
  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result.addAll({
      'itemId': itemId,
      'name': name,
      'amount': amount,
      'amountUnit': amountUnit,
      'bestBefore': bestBefore.toIso8601String(),
    });
    return result;
  }

  @override
  List<Object?> get props =>
      [id, timestamp, itemId, name, amount, amountUnit, bestBefore];
}

@immutable
abstract class Event extends Equatable {
  final EventId id;
  final DateTime timestamp;

  const Event(this.id, this.timestamp);

  Event.build() : this(EventId.generate(), DateTime.now());

  Map<String, dynamic> toJson() {
    return {
      'id': id.value,
      'timestamp': timestamp.toIso8601String(),
      'type': runtimeType.toString(),
    };
  }

  static Event fromJson(Map<String, dynamic> json) {
    final id = EventId(json['id']);
    final timestamp = DateTime.parse(json['timestamp']);
    final type = json['type'];
    switch (type) {
      case 'StockItemAdded':
        return StockItemAdded(id, timestamp,
            itemId: json['itemId'],
            name: json['name'],
            amount: json['amount'],
            amountUnit: json['amountUnit'],
            bestBefore: DateTime.parse(json['bestBefore']));
      default:
        throw Exception('Unknown event type: $type');
    }
  }

  @override
  List<Object?> get props => [id, timestamp];
}

class EventId extends Id {
  const EventId(super.value);

  EventId.generate() : super.generate();
}
