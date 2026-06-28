// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryEvent()';
}


}

/// @nodoc
class $DiscoveryEventCopyWith<$Res>  {
$DiscoveryEventCopyWith(DiscoveryEvent _, $Res Function(DiscoveryEvent) __);
}


/// Adds pattern-matching-related methods to [DiscoveryEvent].
extension DiscoveryEventPatterns on DiscoveryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Start value)?  start,TResult Function( _DiscoveredUpdated value)?  discoveredUpdated,TResult Function( _AddManual value)?  addManual,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Start() when start != null:
return start(_that);case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that);case _AddManual() when addManual != null:
return addManual(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Start value)  start,required TResult Function( _DiscoveredUpdated value)  discoveredUpdated,required TResult Function( _AddManual value)  addManual,}){
final _that = this;
switch (_that) {
case _Start():
return start(_that);case _DiscoveredUpdated():
return discoveredUpdated(_that);case _AddManual():
return addManual(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Start value)?  start,TResult? Function( _DiscoveredUpdated value)?  discoveredUpdated,TResult? Function( _AddManual value)?  addManual,}){
final _that = this;
switch (_that) {
case _Start() when start != null:
return start(_that);case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that);case _AddManual() when addManual != null:
return addManual(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  start,TResult Function( List<DiscoveredServer> servers)?  discoveredUpdated,TResult Function( String host,  int port)?  addManual,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Start() when start != null:
return start();case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that.servers);case _AddManual() when addManual != null:
return addManual(_that.host,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  start,required TResult Function( List<DiscoveredServer> servers)  discoveredUpdated,required TResult Function( String host,  int port)  addManual,}) {final _that = this;
switch (_that) {
case _Start():
return start();case _DiscoveredUpdated():
return discoveredUpdated(_that.servers);case _AddManual():
return addManual(_that.host,_that.port);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  start,TResult? Function( List<DiscoveredServer> servers)?  discoveredUpdated,TResult? Function( String host,  int port)?  addManual,}) {final _that = this;
switch (_that) {
case _Start() when start != null:
return start();case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that.servers);case _AddManual() when addManual != null:
return addManual(_that.host,_that.port);case _:
  return null;

}
}

}

/// @nodoc


class _Start implements DiscoveryEvent {
  const _Start();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Start);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryEvent.start()';
}


}




/// @nodoc


class _DiscoveredUpdated implements DiscoveryEvent {
  const _DiscoveredUpdated(final  List<DiscoveredServer> servers): _servers = servers;
  

 final  List<DiscoveredServer> _servers;
 List<DiscoveredServer> get servers {
  if (_servers is EqualUnmodifiableListView) return _servers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servers);
}


/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveredUpdatedCopyWith<_DiscoveredUpdated> get copyWith => __$DiscoveredUpdatedCopyWithImpl<_DiscoveredUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveredUpdated&&const DeepCollectionEquality().equals(other._servers, _servers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_servers));

@override
String toString() {
  return 'DiscoveryEvent.discoveredUpdated(servers: $servers)';
}


}

/// @nodoc
abstract mixin class _$DiscoveredUpdatedCopyWith<$Res> implements $DiscoveryEventCopyWith<$Res> {
  factory _$DiscoveredUpdatedCopyWith(_DiscoveredUpdated value, $Res Function(_DiscoveredUpdated) _then) = __$DiscoveredUpdatedCopyWithImpl;
@useResult
$Res call({
 List<DiscoveredServer> servers
});




}
/// @nodoc
class __$DiscoveredUpdatedCopyWithImpl<$Res>
    implements _$DiscoveredUpdatedCopyWith<$Res> {
  __$DiscoveredUpdatedCopyWithImpl(this._self, this._then);

  final _DiscoveredUpdated _self;
  final $Res Function(_DiscoveredUpdated) _then;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? servers = null,}) {
  return _then(_DiscoveredUpdated(
null == servers ? _self._servers : servers // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,
  ));
}


}

/// @nodoc


class _AddManual implements DiscoveryEvent {
  const _AddManual({required this.host, required this.port});
  

 final  String host;
 final  int port;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddManualCopyWith<_AddManual> get copyWith => __$AddManualCopyWithImpl<_AddManual>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddManual&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,host,port);

@override
String toString() {
  return 'DiscoveryEvent.addManual(host: $host, port: $port)';
}


}

/// @nodoc
abstract mixin class _$AddManualCopyWith<$Res> implements $DiscoveryEventCopyWith<$Res> {
  factory _$AddManualCopyWith(_AddManual value, $Res Function(_AddManual) _then) = __$AddManualCopyWithImpl;
@useResult
$Res call({
 String host, int port
});




}
/// @nodoc
class __$AddManualCopyWithImpl<$Res>
    implements _$AddManualCopyWith<$Res> {
  __$AddManualCopyWithImpl(this._self, this._then);

  final _AddManual _self;
  final $Res Function(_AddManual) _then;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? host = null,Object? port = null,}) {
  return _then(_AddManual(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DiscoveryState {

 DiscoveryStatus get status; List<DiscoveredServer> get discovered; List<DiscoveredServer> get manual; String get errorMessage;
/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryStateCopyWith<DiscoveryState> get copyWith => _$DiscoveryStateCopyWithImpl<DiscoveryState>(this as DiscoveryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.discovered, discovered)&&const DeepCollectionEquality().equals(other.manual, manual)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(discovered),const DeepCollectionEquality().hash(manual),errorMessage);

@override
String toString() {
  return 'DiscoveryState(status: $status, discovered: $discovered, manual: $manual, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DiscoveryStateCopyWith<$Res>  {
  factory $DiscoveryStateCopyWith(DiscoveryState value, $Res Function(DiscoveryState) _then) = _$DiscoveryStateCopyWithImpl;
@useResult
$Res call({
 DiscoveryStatus status, List<DiscoveredServer> discovered, List<DiscoveredServer> manual, String errorMessage
});




}
/// @nodoc
class _$DiscoveryStateCopyWithImpl<$Res>
    implements $DiscoveryStateCopyWith<$Res> {
  _$DiscoveryStateCopyWithImpl(this._self, this._then);

  final DiscoveryState _self;
  final $Res Function(DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? discovered = null,Object? manual = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,discovered: null == discovered ? _self.discovered : discovered // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,manual: null == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoveryState].
extension DiscoveryStatePatterns on DiscoveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState():
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryState implements DiscoveryState {
  const _DiscoveryState({this.status = DiscoveryStatus.initial, final  List<DiscoveredServer> discovered = const <DiscoveredServer>[], final  List<DiscoveredServer> manual = const <DiscoveredServer>[], this.errorMessage = ''}): _discovered = discovered,_manual = manual;
  

@override@JsonKey() final  DiscoveryStatus status;
 final  List<DiscoveredServer> _discovered;
@override@JsonKey() List<DiscoveredServer> get discovered {
  if (_discovered is EqualUnmodifiableListView) return _discovered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discovered);
}

 final  List<DiscoveredServer> _manual;
@override@JsonKey() List<DiscoveredServer> get manual {
  if (_manual is EqualUnmodifiableListView) return _manual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manual);
}

@override@JsonKey() final  String errorMessage;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryStateCopyWith<_DiscoveryState> get copyWith => __$DiscoveryStateCopyWithImpl<_DiscoveryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._discovered, _discovered)&&const DeepCollectionEquality().equals(other._manual, _manual)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_discovered),const DeepCollectionEquality().hash(_manual),errorMessage);

@override
String toString() {
  return 'DiscoveryState(status: $status, discovered: $discovered, manual: $manual, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryStateCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory _$DiscoveryStateCopyWith(_DiscoveryState value, $Res Function(_DiscoveryState) _then) = __$DiscoveryStateCopyWithImpl;
@override @useResult
$Res call({
 DiscoveryStatus status, List<DiscoveredServer> discovered, List<DiscoveredServer> manual, String errorMessage
});




}
/// @nodoc
class __$DiscoveryStateCopyWithImpl<$Res>
    implements _$DiscoveryStateCopyWith<$Res> {
  __$DiscoveryStateCopyWithImpl(this._self, this._then);

  final _DiscoveryState _self;
  final $Res Function(_DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? discovered = null,Object? manual = null,Object? errorMessage = null,}) {
  return _then(_DiscoveryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,discovered: null == discovered ? _self._discovered : discovered // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,manual: null == manual ? _self._manual : manual // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
