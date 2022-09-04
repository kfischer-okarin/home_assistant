import 'package:equatable/equatable.dart' as equatable;
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class Equatable extends equatable.Equatable {
  const Equatable();

  @override
  bool get stringify => true;
}

@immutable
abstract class Id extends Equatable {
  final String value;

  const Id(this.value);

  Id.generate() : this(_uuid.v4());

  @override
  List<Object?> get props => [value];
}

const _uuid = Uuid();
