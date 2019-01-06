import 'dart:math';

import 'package:activatory/src/activation_exception.dart';
import 'package:activatory/src/backends/array_backend.dart';
import 'package:activatory/src/backends/complex_object_backend.dart';
import 'package:activatory/src/backends/generator_backend.dart';

class ActivationContext {
  Map<_BackendStoreKey, GeneratorBackend> _exactBackends = new Map<_BackendStoreKey, GeneratorBackend>();
  Random _random;

  ActivationContext(this._random);

  ActivationContext._fromMap(this._exactBackends, this._random);

  ActivationContext clone() {
    var backends = Map<_BackendStoreKey, GeneratorBackend>.from(_exactBackends);
    return new ActivationContext._fromMap(backends, _random);
  }

  GeneratorBackend find(Type type, {Object key}) {
    final keyObject = new _BackendStoreKey(type, key);
    var result = _exactBackends[keyObject];
    if (result != null) {
      return result;
    }
    if (key != null) {
      return null;
    }

    var complexObjectBackend = new ComplexObjectBackend(type, _random);
    register(complexObjectBackend, type);
    return complexObjectBackend;
  }

  GeneratorBackend get(Type type, {Object key}) {
    var backend = find(type, key: key);
    if (backend == null) {
      throw new ActivationException("Backend of type ${type} with key ${key} not found");
    }
    return backend;
  }

  void register(GeneratorBackend backend, Type type, {Object key}) {
    final keyObject = new _BackendStoreKey(type, key);
    _exactBackends[keyObject] = backend;
  }

  void registerArray<T>() {
    registerTyped(new ArrayBackend<T>());
  }

  void registerTyped<T>(GeneratorBackend<T> backend, {Object key}) => register(backend, T, key: key);
}

class _BackendStoreKey {
  final Type _type;
  final Object _key;

  _BackendStoreKey(this._type, this._key);

  /// NOTE: This method is generated by WebStorm
  @override
  int get hashCode => _type.hashCode ^ _key.hashCode;

  Object get key => _key;

  Type get type => _type;

  /// NOTE: This method is generated by WebStorm
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _BackendStoreKey && runtimeType == other.runtimeType && _type == other._type && _key == other._key;
  }
}
