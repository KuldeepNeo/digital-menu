// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpecialModel {

 String get id; String get dishId; String get title; int get expiresAt;
/// Create a copy of SpecialModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialModelCopyWith<SpecialModel> get copyWith => _$SpecialModelCopyWithImpl<SpecialModel>(this as SpecialModel, _$identity);

  /// Serializes this SpecialModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dishId, dishId) || other.dishId == dishId)&&(identical(other.title, title) || other.title == title)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dishId,title,expiresAt);

@override
String toString() {
  return 'SpecialModel(id: $id, dishId: $dishId, title: $title, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $SpecialModelCopyWith<$Res>  {
  factory $SpecialModelCopyWith(SpecialModel value, $Res Function(SpecialModel) _then) = _$SpecialModelCopyWithImpl;
@useResult
$Res call({
 String id, String dishId, String title, int expiresAt
});




}
/// @nodoc
class _$SpecialModelCopyWithImpl<$Res>
    implements $SpecialModelCopyWith<$Res> {
  _$SpecialModelCopyWithImpl(this._self, this._then);

  final SpecialModel _self;
  final $Res Function(SpecialModel) _then;

/// Create a copy of SpecialModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dishId = null,Object? title = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dishId: null == dishId ? _self.dishId : dishId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecialModel].
extension SpecialModelPatterns on SpecialModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpecialModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpecialModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpecialModel value)  $default,){
final _that = this;
switch (_that) {
case _SpecialModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpecialModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpecialModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dishId,  String title,  int expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpecialModel() when $default != null:
return $default(_that.id,_that.dishId,_that.title,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dishId,  String title,  int expiresAt)  $default,) {final _that = this;
switch (_that) {
case _SpecialModel():
return $default(_that.id,_that.dishId,_that.title,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dishId,  String title,  int expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _SpecialModel() when $default != null:
return $default(_that.id,_that.dishId,_that.title,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpecialModel extends SpecialModel {
  const _SpecialModel({required this.id, required this.dishId, required this.title, required this.expiresAt}): super._();
  factory _SpecialModel.fromJson(Map<String, dynamic> json) => _$SpecialModelFromJson(json);

@override final  String id;
@override final  String dishId;
@override final  String title;
@override final  int expiresAt;

/// Create a copy of SpecialModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecialModelCopyWith<_SpecialModel> get copyWith => __$SpecialModelCopyWithImpl<_SpecialModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecialModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpecialModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dishId, dishId) || other.dishId == dishId)&&(identical(other.title, title) || other.title == title)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dishId,title,expiresAt);

@override
String toString() {
  return 'SpecialModel(id: $id, dishId: $dishId, title: $title, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$SpecialModelCopyWith<$Res> implements $SpecialModelCopyWith<$Res> {
  factory _$SpecialModelCopyWith(_SpecialModel value, $Res Function(_SpecialModel) _then) = __$SpecialModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String dishId, String title, int expiresAt
});




}
/// @nodoc
class __$SpecialModelCopyWithImpl<$Res>
    implements _$SpecialModelCopyWith<$Res> {
  __$SpecialModelCopyWithImpl(this._self, this._then);

  final _SpecialModel _self;
  final $Res Function(_SpecialModel) _then;

/// Create a copy of SpecialModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dishId = null,Object? title = null,Object? expiresAt = null,}) {
  return _then(_SpecialModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dishId: null == dishId ? _self.dishId : dishId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
