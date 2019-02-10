import 'dart:math';

import 'package:activatory/src/backends/random_array_item_backend.dart';
import 'package:activatory/src/customization/type_customization_registry.dart';
import 'package:activatory/src/generator_delegate.dart';
import 'package:activatory/src/value_generator.dart';

class ActivationContext implements ValueGenerator {
  final ValueGenerator _valueGenerator;
  final Object _key;
  final Random _random;
  final List<Type> _stackTrace = new List<Type>();
  final TypeCustomizationRegistry _customizationsRegistry;

  ActivationContext(this._valueGenerator, this._random, this._key, this._customizationsRegistry);

  Object get key => _key;
  Random get random => _random;

  int arraySize(Type type) => _customizationsRegistry.get(type).arraySize;

  int countVisits(Type type) => _stackTrace.where((t) => t == type).length;

  @override
  Object create(Type type, ActivationContext context) => _valueGenerator.create(type, context);

  @override
  T createTyped<T>(ActivationContext context) => create(T, context);

  GeneratorDelegate getArgumentOverride<T>(Type resolveType, Type argumentType, String argumentName) {
    final typeCustomization = _customizationsRegistry.get(resolveType);
    final argumentCustomization = typeCustomization.getArgumentCustomization(argumentType, argumentName);

    if (argumentCustomization == null) {
      return null;
    }

    if (argumentCustomization.callback != null) {
      return argumentCustomization.callback;
    }

    if (argumentCustomization.pool != null) {
      final randomItemBackend = new RandomArrayItemBackend(argumentCustomization.pool);
      return (ctx) => randomItemBackend.get(ctx);
    }

    return null;
  }

  bool isVisitLimitReached(Type type) {
    final customization = _customizationsRegistry.get(type);
    return countVisits(type) > customization.maxRecursion;
  }

  void notifyVisited(Type type) => _stackTrace.removeAt(_stackTrace.lastIndexOf(type));

  void notifyVisiting(Type type) => _stackTrace.add(type);
}
