import 'package:equatable/equatable.dart' as equatable;

abstract class Equatable extends equatable.Equatable {
  const Equatable();

  @override
  bool get stringify => true;
}
