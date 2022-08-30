import 'package:flutter_test/flutter_test.dart';
import 'package:things_at_home/stock.dart';

void main() {
  test('parse', () {
    const amountString = '300g';

    final amount = Amount.parse(amountString);

    expect(amount, const Amount(300, Unit.gram));
  });
}
