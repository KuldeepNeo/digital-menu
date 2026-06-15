// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kitchen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KitchenState {

 bool get isLoading; List<Order> get orders; String? get errorMessage;
/// Create a copy of KitchenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KitchenStateCopyWith<KitchenState> get copyWith => _$KitchenStateCopyWithImpl<KitchenState>(this as KitchenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KitchenState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(orders),errorMessage);

@override
String toString() {
  return 'KitchenState(isLoading: $isLoading, orders: $orders, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $KitchenStateCopyWith<$Res>  {
  factory $KitchenStateCopyWith(KitchenState value, $Res Function(KitchenState) _then) = _$KitchenStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Order> orders, String? errorMessage
});




}
/// @nodoc
class _$KitchenStateCopyWithImpl<$Res>
    implements $KitchenStateCopyWith<$Res> {
  _$KitchenStateCopyWithImpl(this._self, this._then);

  final KitchenState _self;
  final $Res Function(KitchenState) _then;

/// Create a copy of KitchenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? orders = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KitchenState].
extension KitchenStatePatterns on KitchenState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KitchenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KitchenState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KitchenState value)  $default,){
final _that = this;
switch (_that) {
case _KitchenState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KitchenState value)?  $default,){
final _that = this;
switch (_that) {
case _KitchenState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Order> orders,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KitchenState() when $default != null:
return $default(_that.isLoading,_that.orders,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Order> orders,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _KitchenState():
return $default(_that.isLoading,_that.orders,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Order> orders,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _KitchenState() when $default != null:
return $default(_that.isLoading,_that.orders,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _KitchenState implements KitchenState {
  const _KitchenState({required this.isLoading, required final  List<Order> orders, this.errorMessage}): _orders = orders;
  

@override final  bool isLoading;
 final  List<Order> _orders;
@override List<Order> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override final  String? errorMessage;

/// Create a copy of KitchenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KitchenStateCopyWith<_KitchenState> get copyWith => __$KitchenStateCopyWithImpl<_KitchenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KitchenState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_orders),errorMessage);

@override
String toString() {
  return 'KitchenState(isLoading: $isLoading, orders: $orders, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$KitchenStateCopyWith<$Res> implements $KitchenStateCopyWith<$Res> {
  factory _$KitchenStateCopyWith(_KitchenState value, $Res Function(_KitchenState) _then) = __$KitchenStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Order> orders, String? errorMessage
});




}
/// @nodoc
class __$KitchenStateCopyWithImpl<$Res>
    implements _$KitchenStateCopyWith<$Res> {
  __$KitchenStateCopyWithImpl(this._self, this._then);

  final _KitchenState _self;
  final $Res Function(_KitchenState) _then;

/// Create a copy of KitchenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? orders = null,Object? errorMessage = freezed,}) {
  return _then(_KitchenState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
