// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferProgress {

 String get fileName; TransferDirection get direction; int get transferred; int get total;/// Local path the file was saved to (set on the final download progress).
 String? get savedPath;
/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<TransferProgress> get copyWith => _$TransferProgressCopyWithImpl<TransferProgress>(this as TransferProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferProgress&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.transferred, transferred) || other.transferred == transferred)&&(identical(other.total, total) || other.total == total)&&(identical(other.savedPath, savedPath) || other.savedPath == savedPath));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,direction,transferred,total,savedPath);

@override
String toString() {
  return 'TransferProgress(fileName: $fileName, direction: $direction, transferred: $transferred, total: $total, savedPath: $savedPath)';
}


}

/// @nodoc
abstract mixin class $TransferProgressCopyWith<$Res>  {
  factory $TransferProgressCopyWith(TransferProgress value, $Res Function(TransferProgress) _then) = _$TransferProgressCopyWithImpl;
@useResult
$Res call({
 String fileName, TransferDirection direction, int transferred, int total, String? savedPath
});




}
/// @nodoc
class _$TransferProgressCopyWithImpl<$Res>
    implements $TransferProgressCopyWith<$Res> {
  _$TransferProgressCopyWithImpl(this._self, this._then);

  final TransferProgress _self;
  final $Res Function(TransferProgress) _then;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? direction = null,Object? transferred = null,Object? total = null,Object? savedPath = freezed,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,transferred: null == transferred ? _self.transferred : transferred // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,savedPath: freezed == savedPath ? _self.savedPath : savedPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferProgress].
extension TransferProgressPatterns on TransferProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferProgress value)  $default,){
final _that = this;
switch (_that) {
case _TransferProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferProgress value)?  $default,){
final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  TransferDirection direction,  int transferred,  int total,  String? savedPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
return $default(_that.fileName,_that.direction,_that.transferred,_that.total,_that.savedPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  TransferDirection direction,  int transferred,  int total,  String? savedPath)  $default,) {final _that = this;
switch (_that) {
case _TransferProgress():
return $default(_that.fileName,_that.direction,_that.transferred,_that.total,_that.savedPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  TransferDirection direction,  int transferred,  int total,  String? savedPath)?  $default,) {final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
return $default(_that.fileName,_that.direction,_that.transferred,_that.total,_that.savedPath);case _:
  return null;

}
}

}

/// @nodoc


class _TransferProgress extends TransferProgress {
  const _TransferProgress({required this.fileName, required this.direction, required this.transferred, required this.total, this.savedPath}): super._();
  

@override final  String fileName;
@override final  TransferDirection direction;
@override final  int transferred;
@override final  int total;
/// Local path the file was saved to (set on the final download progress).
@override final  String? savedPath;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferProgressCopyWith<_TransferProgress> get copyWith => __$TransferProgressCopyWithImpl<_TransferProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferProgress&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.transferred, transferred) || other.transferred == transferred)&&(identical(other.total, total) || other.total == total)&&(identical(other.savedPath, savedPath) || other.savedPath == savedPath));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,direction,transferred,total,savedPath);

@override
String toString() {
  return 'TransferProgress(fileName: $fileName, direction: $direction, transferred: $transferred, total: $total, savedPath: $savedPath)';
}


}

/// @nodoc
abstract mixin class _$TransferProgressCopyWith<$Res> implements $TransferProgressCopyWith<$Res> {
  factory _$TransferProgressCopyWith(_TransferProgress value, $Res Function(_TransferProgress) _then) = __$TransferProgressCopyWithImpl;
@override @useResult
$Res call({
 String fileName, TransferDirection direction, int transferred, int total, String? savedPath
});




}
/// @nodoc
class __$TransferProgressCopyWithImpl<$Res>
    implements _$TransferProgressCopyWith<$Res> {
  __$TransferProgressCopyWithImpl(this._self, this._then);

  final _TransferProgress _self;
  final $Res Function(_TransferProgress) _then;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? direction = null,Object? transferred = null,Object? total = null,Object? savedPath = freezed,}) {
  return _then(_TransferProgress(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,transferred: null == transferred ? _self.transferred : transferred // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,savedPath: freezed == savedPath ? _self.savedPath : savedPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
