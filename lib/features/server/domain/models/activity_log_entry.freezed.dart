// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityLogEntry {

 ActivityType get type; String get message; DateTime get timestamp;
/// Create a copy of ActivityLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityLogEntryCopyWith<ActivityLogEntry> get copyWith => _$ActivityLogEntryCopyWithImpl<ActivityLogEntry>(this as ActivityLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityLogEntry&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,type,message,timestamp);

@override
String toString() {
  return 'ActivityLogEntry(type: $type, message: $message, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ActivityLogEntryCopyWith<$Res>  {
  factory $ActivityLogEntryCopyWith(ActivityLogEntry value, $Res Function(ActivityLogEntry) _then) = _$ActivityLogEntryCopyWithImpl;
@useResult
$Res call({
 ActivityType type, String message, DateTime timestamp
});




}
/// @nodoc
class _$ActivityLogEntryCopyWithImpl<$Res>
    implements $ActivityLogEntryCopyWith<$Res> {
  _$ActivityLogEntryCopyWithImpl(this._self, this._then);

  final ActivityLogEntry _self;
  final $Res Function(ActivityLogEntry) _then;

/// Create a copy of ActivityLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? message = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityLogEntry].
extension ActivityLogEntryPatterns on ActivityLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivityType type,  String message,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityLogEntry() when $default != null:
return $default(_that.type,_that.message,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivityType type,  String message,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _ActivityLogEntry():
return $default(_that.type,_that.message,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivityType type,  String message,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ActivityLogEntry() when $default != null:
return $default(_that.type,_that.message,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityLogEntry implements ActivityLogEntry {
  const _ActivityLogEntry({required this.type, required this.message, required this.timestamp});
  

@override final  ActivityType type;
@override final  String message;
@override final  DateTime timestamp;

/// Create a copy of ActivityLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityLogEntryCopyWith<_ActivityLogEntry> get copyWith => __$ActivityLogEntryCopyWithImpl<_ActivityLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityLogEntry&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,type,message,timestamp);

@override
String toString() {
  return 'ActivityLogEntry(type: $type, message: $message, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ActivityLogEntryCopyWith<$Res> implements $ActivityLogEntryCopyWith<$Res> {
  factory _$ActivityLogEntryCopyWith(_ActivityLogEntry value, $Res Function(_ActivityLogEntry) _then) = __$ActivityLogEntryCopyWithImpl;
@override @useResult
$Res call({
 ActivityType type, String message, DateTime timestamp
});




}
/// @nodoc
class __$ActivityLogEntryCopyWithImpl<$Res>
    implements _$ActivityLogEntryCopyWith<$Res> {
  __$ActivityLogEntryCopyWithImpl(this._self, this._then);

  final _ActivityLogEntry _self;
  final $Res Function(_ActivityLogEntry) _then;

/// Create a copy of ActivityLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? message = null,Object? timestamp = null,}) {
  return _then(_ActivityLogEntry(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
