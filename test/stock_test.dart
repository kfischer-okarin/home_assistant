import 'package:flutter_test/flutter_test.dart';
import 'package:home_assistant/domain/stock.dart';

void main() {
  test('parse', () {
    const amountString = '300g';

    final amount = Amount.parse(amountString);

    expect(amount, const Amount(300, Unit.gram));
  });
}
