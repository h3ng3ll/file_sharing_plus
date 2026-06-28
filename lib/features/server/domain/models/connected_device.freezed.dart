// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connected_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectedDevice {

 String get address; DateTime get lastSeen; int get requestCount;
/// Create a copy of ConnectedDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedDeviceCopyWith<ConnectedDevice> get copyWith => _$ConnectedDeviceCopyWithImpl<ConnectedDevice>(this as ConnectedDevice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedDevice&&(identical(other.address, address) || other.address == address)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.requestCount, requestCount) || other.requestCount == requestCount));
}


@override
int get hashCode => Object.hash(runtimeType,address,lastSeen,requestCount);

@override
String toString() {
  return 'ConnectedDevice(address: $address, lastSeen: $lastSeen, requestCount: $requestCount)';
}


}

/// @nodoc
abstract mixin class $ConnectedDeviceCopyWith<$Res>  {
  factory $ConnectedDeviceCopyWith(ConnectedDevice value, $Res Function(ConnectedDevice) _then) = _$ConnectedDeviceCopyWithImpl;
@useResult
$Res call({
 String address, DateTime lastSeen, int requestCount
});




}
/// @nodoc
class _$ConnectedDeviceCopyWithImpl<$Res>
    implements $ConnectedDeviceCopyWith<$Res> {
  _$ConnectedDeviceCopyWithImpl(this._self, this._then);

  final ConnectedDevice _self;
  final $Res Function(ConnectedDevice) _then;

/// Create a copy of ConnectedDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? lastSeen = null,Object? requestCount = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,requestCount: null == requestCount ? _self.requestCount : requestCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectedDevice].
extension ConnectedDevicePatterns on ConnectedDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectedDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectedDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectedDevice value)  $default,){
final _that = this;
switch (_that) {
case _ConnectedDevice():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectedDevice value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectedDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  DateTime lastSeen,  int requestCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectedDevice() when $default != null:
return $default(_that.address,_that.lastSeen,_that.requestCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  DateTime lastSeen,  int requestCount)  $default,) {final _that = this;
switch (_that) {
case _ConnectedDevice():
return $default(_that.address,_that.lastSeen,_that.requestCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  DateTime lastSeen,  int requestCount)?  $default,) {final _that = this;
switch (_that) {
case _ConnectedDevice() when $default != null:
return $default(_that.address,_that.lastSeen,_that.requestCount);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectedDevice implements ConnectedDevice {
  const _ConnectedDevice({required this.address, required this.lastSeen, this.requestCount = 0});
  

@override final  String address;
@override final  DateTime lastSeen;
@override@JsonKey() final  int requestCount;

/// Create a copy of ConnectedDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectedDeviceCopyWith<_ConnectedDevice> get copyWith => __$ConnectedDeviceCopyWithImpl<_ConnectedDevice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectedDevice&&(identical(other.address, address) || other.address == address)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.requestCount, requestCount) || other.requestCount == requestCount));
}


@override
int get hashCode => Object.hash(runtimeType,address,lastSeen,requestCount);

@override
String toString() {
  return 'ConnectedDevice(address: $address, lastSeen: $lastSeen, requestCount: $requestCount)';
}


}

/// @nodoc
abstract mixin class _$ConnectedDeviceCopyWith<$Res> implements $ConnectedDeviceCopyWith<$Res> {
  factory _$ConnectedDeviceCopyWith(_ConnectedDevice value, $Res Function(_ConnectedDevice) _then) = __$ConnectedDeviceCopyWithImpl;
@override @useResult
$Res call({
 String address, DateTime lastSeen, int requestCount
});




}
/// @nodoc
class __$ConnectedDeviceCopyWithImpl<$Res>
    implements _$ConnectedDeviceCopyWith<$Res> {
  __$ConnectedDeviceCopyWithImpl(this._self, this._then);

  final _ConnectedDevice _self;
  final $Res Function(_ConnectedDevice) _then;

/// Create a copy of ConnectedDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? lastSeen = null,Object? requestCount = null,}) {
  return _then(_ConnectedDevice(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,requestCount: null == requestCount ? _self.requestCount : requestCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
