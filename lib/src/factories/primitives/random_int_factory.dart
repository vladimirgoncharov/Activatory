import 'dart:math';

import 'package:activatory/src/factories/factory.dart';
import 'package:activatory/src/internal_activation_context.dart';

class RandomIntFactory implements Factory<int> {
  final Random _random;
  static final num _maxValue = pow(2, 31);

  RandomIntFactory(this._random);

  @override
  int get(InternalActivationContext context) =>
      _maxValue.toInt() - _random.nextInt(_maxValue.toInt());

  @override
  int getDefaultValue() => 0;
}
