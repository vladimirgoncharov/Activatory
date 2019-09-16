import 'package:activatory/src/customization/argument_customization.dart';
import 'package:activatory/src/customization/backend_resolution_strategy.dart';

class TypeCustomization {
  final Map<_ArgumentKey, ArgumentCustomization> _argumentCustomizations = new Map<_ArgumentKey, ArgumentCustomization>();

  BackendResolutionStrategy resolutionStrategy = BackendResolutionStrategy.TakeFirstDefined;
  int arraySize = 3;
  int maxRecursion = 3;

  ArgumentCustomization<T> whenArgument<T>([String argumentName=null]){
    final key = new _ArgumentKey(T, argumentName);
    var result = _argumentCustomizations[key];
    if(result == null){
      result = new ArgumentCustomization<T>();
      _argumentCustomizations[key] = result;
    }
    return result;
  }

  TypeCustomization clone() {
    return new TypeCustomization()
        ..arraySize = arraySize
        ..maxRecursion = maxRecursion
        ..resolutionStrategy = resolutionStrategy;
  }

  ArgumentCustomization getArgumentCustomization(Type type, String name){
    var key = new _ArgumentKey(type, name);
    if(_argumentCustomizations.containsKey(key)){
      return _argumentCustomizations[key];
    }

    key = new _ArgumentKey(type, null);
    if(_argumentCustomizations.containsKey(key)){
      return _argumentCustomizations[key];
    }

    return null;
  }
}

class _ArgumentKey{
  final Type _type;
  final String _name;

  _ArgumentKey(this._type, this._name);

  Type get type => _type;
  String get name => _name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ArgumentKey &&
              runtimeType == other.runtimeType &&
              _type == other._type &&
              _name == other._name;

  @override
  int get hashCode =>
      _type.hashCode ^
      _name.hashCode;
}
