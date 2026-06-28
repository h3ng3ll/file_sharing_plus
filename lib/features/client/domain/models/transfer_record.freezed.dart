// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferRecord {

 String get fileName; TransferDirection get direction; bool get success; DateTime get timestamp;/// Local path of a downloaded file (used to offer "Save to Files").
 String? get savedPath;
/// Create a copy of TransferRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferRecordCopyWith<TransferRecord> get copyWith => _$TransferRecordCopyWithImpl<TransferRecord>(this as TransferRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferRecord&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.success, success) || other.success == success)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.savedPath, savedPath) || other.savedPath == savedPath));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,direction,success,timestamp,savedPath);

@override
String toString() {
  return 'TransferRecord(fileName: $fileName, direction: $direction, success: $success, timestamp: $timestamp, savedPath: $savedPath)';
}


}

/// @nodoc
abstract mixin class $TransferRecordCopyWith<$Res>  {
  factory $TransferRecordCopyWith(TransferRecord value, $Res Function(TransferRecord) _then) = _$TransferRecordCopyWithImpl;
@useResult
$Res call({
 String fileName, TransferDirection direction, bool success, DateTime timestamp, String? savedPath
});




}
/// @nodoc
class _$TransferRecordCopyWithImpl<$Res>
    implements $TransferRecordCopyWith<$Res> {
  _$TransferRecordCopyWithImpl(this._self, this._then);

  final TransferRecord _self;
  final $Res Function(TransferRecord) _then;

/// Create a copy of TransferRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? direction = null,Object? success = null,Object? timestamp = null,Object? savedPath = freezed,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,savedPath: freezed == savedPath ? _self.savedPath : savedPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferRecord].
extension TransferRecordPatterns on TransferRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferRecord value)  $default,){
final _that = this;
switch (_that) {
case _TransferRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TransferRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  TransferDirection direction,  bool success,  DateTime timestamp,  String? savedPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferRecord() when $default != null:
return $default(_that.fileName,_that.direction,_that.success,_that.timestamp,_that.savedPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  TransferDirection direction,  bool success,  DateTime timestamp,  String? savedPath)  $default,) {final _that = this;
switch (_that) {
case _TransferRecord():
return $default(_that.fileName,_that.direction,_that.success,_that.timestamp,_that.savedPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  TransferDirection direction,  bool success,  DateTime timestamp,  String? savedPath)?  $default,) {final _that = this;
switch (_that) {
case _TransferRecord() when $default != null:
return $default(_that.fileName,_that.direction,_that.success,_that.timestamp,_that.savedPath);case _:
  return null;

}
}

}

/// @nodoc


class _TransferRecord implements TransferRecord {
  const _TransferRecord({required this.fileName, required this.direction, required this.success, required this.timestamp, this.savedPath});
  

@override final  String fileName;
@override final  TransferDirection direction;
@override final  bool success;
@override final  DateTime timestamp;
/// Local path of a downloaded file (used to offer "Save to Files").
@override final  String? savedPath;

/// Create a copy of TransferRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferRecordCopyWith<_TransferRecord> get copyWith => __$TransferRecordCopyWithImpl<_TransferRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferRecord&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.success, success) || other.success == success)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.savedPath, savedPath) || other.savedPath == savedPath));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,direction,success,timestamp,savedPath);

@override
String toString() {
  return 'TransferRecord(fileName: $fileName, direction: $direction, success: $success, timestamp: $timestamp, savedPath: $savedPath)';
}


}

/// @nodoc
abstract mixin class _$TransferRecordCopyWith<$Res> implements $TransferRecordCopyWith<$Res> {
  factory _$TransferRecordCopyWith(_TransferRecord value, $Res Function(_TransferRecord) _then) = __$TransferRecordCopyWithImpl;
@override @useResult
$Res call({
 String fileName, TransferDirection direction, bool success, DateTime timestamp, String? savedPath
});




}
/// @nodoc
class __$TransferRecordCopyWithImpl<$Res>
    implements _$TransferRecordCopyWith<$Res> {
  __$TransferRecordCopyWithImpl(this._self, this._then);

  final _TransferRecord _self;
  final $Res Function(_TransferRecord) _then;

/// Create a copy of TransferRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? direction = null,Object? success = null,Object? timestamp = null,Object? savedPath = freezed,}) {
  return _then(_TransferRecord(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,savedPath: freezed == savedPath ? _self.savedPath : savedPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
