// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartState {

 Map<String, int> get itemQuantities; Map<String, OrderItem> get itemDetails; String? get tableNumber; bool get isSubmitting; String? get errorMessage; bool get submitSuccess;
/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartStateCopyWith<CartState> get copyWith => _$CartStateCopyWithImpl<CartState>(this as CartState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState&&const DeepCollectionEquality().equals(other.itemQuantities, itemQuantities)&&const DeepCollectionEquality().equals(other.itemDetails, itemDetails)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.submitSuccess, submitSuccess) || other.submitSuccess == submitSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(itemQuantities),const DeepCollectionEquality().hash(itemDetails),tableNumber,isSubmitting,errorMessage,submitSuccess);

@override
String toString() {
  return 'CartState(itemQuantities: $itemQuantities, itemDetails: $itemDetails, tableNumber: $tableNumber, isSubmitting: $isSubmitting, errorMessage: $errorMessage, submitSuccess: $submitSuccess)';
}


}

/// @nodoc
abstract mixin class $CartStateCopyWith<$Res>  {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) _then) = _$CartStateCopyWithImpl;
@useResult
$Res call({
 Map<String, int> itemQuantities, Map<String, OrderItem> itemDetails, String? tableNumber, bool isSubmitting, String? errorMessage, bool submitSuccess
});




}
/// @nodoc
class _$CartStateCopyWithImpl<$Res>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._self, this._then);

  final CartState _self;
  final $Res Function(CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemQuantities = null,Object? itemDetails = null,Object? tableNumber = freezed,Object? isSubmitting = null,Object? errorMessage = freezed,Object? submitSuccess = null,}) {
  return _then(_self.copyWith(
itemQuantities: null == itemQuantities ? _self.itemQuantities : itemQuantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,itemDetails: null == itemDetails ? _self.itemDetails : itemDetails // ignore: cast_nullable_to_non_nullable
as Map<String, OrderItem>,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,submitSuccess: null == submitSuccess ? _self.submitSuccess : submitSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartState value)  $default,){
final _that = this;
switch (_that) {
case _CartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartState value)?  $default,){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> itemQuantities,  Map<String, OrderItem> itemDetails,  String? tableNumber,  bool isSubmitting,  String? errorMessage,  bool submitSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.itemQuantities,_that.itemDetails,_that.tableNumber,_that.isSubmitting,_that.errorMessage,_that.submitSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> itemQuantities,  Map<String, OrderItem> itemDetails,  String? tableNumber,  bool isSubmitting,  String? errorMessage,  bool submitSuccess)  $default,) {final _that = this;
switch (_that) {
case _CartState():
return $default(_that.itemQuantities,_that.itemDetails,_that.tableNumber,_that.isSubmitting,_that.errorMessage,_that.submitSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> itemQuantities,  Map<String, OrderItem> itemDetails,  String? tableNumber,  bool isSubmitting,  String? errorMessage,  bool submitSuccess)?  $default,) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.itemQuantities,_that.itemDetails,_that.tableNumber,_that.isSubmitting,_that.errorMessage,_that.submitSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _CartState implements CartState {
  const _CartState({required final  Map<String, int> itemQuantities, required final  Map<String, OrderItem> itemDetails, this.tableNumber, this.isSubmitting = false, this.errorMessage, this.submitSuccess = false}): _itemQuantities = itemQuantities,_itemDetails = itemDetails;
  

 final  Map<String, int> _itemQuantities;
@override Map<String, int> get itemQuantities {
  if (_itemQuantities is EqualUnmodifiableMapView) return _itemQuantities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_itemQuantities);
}

 final  Map<String, OrderItem> _itemDetails;
@override Map<String, OrderItem> get itemDetails {
  if (_itemDetails is EqualUnmodifiableMapView) return _itemDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_itemDetails);
}

@override final  String? tableNumber;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;
@override@JsonKey() final  bool submitSuccess;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartStateCopyWith<_CartState> get copyWith => __$CartStateCopyWithImpl<_CartState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartState&&const DeepCollectionEquality().equals(other._itemQuantities, _itemQuantities)&&const DeepCollectionEquality().equals(other._itemDetails, _itemDetails)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.submitSuccess, submitSuccess) || other.submitSuccess == submitSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_itemQuantities),const DeepCollectionEquality().hash(_itemDetails),tableNumber,isSubmitting,errorMessage,submitSuccess);

@override
String toString() {
  return 'CartState(itemQuantities: $itemQuantities, itemDetails: $itemDetails, tableNumber: $tableNumber, isSubmitting: $isSubmitting, errorMessage: $errorMessage, submitSuccess: $submitSuccess)';
}


}

/// @nodoc
abstract mixin class _$CartStateCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$CartStateCopyWith(_CartState value, $Res Function(_CartState) _then) = __$CartStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> itemQuantities, Map<String, OrderItem> itemDetails, String? tableNumber, bool isSubmitting, String? errorMessage, bool submitSuccess
});




}
/// @nodoc
class __$CartStateCopyWithImpl<$Res>
    implements _$CartStateCopyWith<$Res> {
  __$CartStateCopyWithImpl(this._self, this._then);

  final _CartState _self;
  final $Res Function(_CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemQuantities = null,Object? itemDetails = null,Object? tableNumber = freezed,Object? isSubmitting = null,Object? errorMessage = freezed,Object? submitSuccess = null,}) {
  return _then(_CartState(
itemQuantities: null == itemQuantities ? _self._itemQuantities : itemQuantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,itemDetails: null == itemDetails ? _self._itemDetails : itemDetails // ignore: cast_nullable_to_non_nullable
as Map<String, OrderItem>,tableNumber: freezed == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as String?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,submitSuccess: null == submitSuccess ? _self.submitSuccess : submitSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
