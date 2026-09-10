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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Start value)?  start,TResult Function( _DiscoveredUpdated value)?  discoveredUpdated,TResult Function( _AddManual value)?  addManual,TResult Function( _OpenServer value)?  openServer,TResult Function( _ConsumeSignal value)?  consumeSignal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Start() when start != null:
return start(_that);case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that);case _AddManual() when addManual != null:
return addManual(_that);case _OpenServer() when openServer != null:
return openServer(_that);case _ConsumeSignal() when consumeSignal != null:
return consumeSignal(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Start value)  start,required TResult Function( _DiscoveredUpdated value)  discoveredUpdated,required TResult Function( _AddManual value)  addManual,required TResult Function( _OpenServer value)  openServer,required TResult Function( _ConsumeSignal value)  consumeSignal,}){
final _that = this;
switch (_that) {
case _Start():
return start(_that);case _DiscoveredUpdated():
return discoveredUpdated(_that);case _AddManual():
return addManual(_that);case _OpenServer():
return openServer(_that);case _ConsumeSignal():
return consumeSignal(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Start value)?  start,TResult? Function( _DiscoveredUpdated value)?  discoveredUpdated,TResult? Function( _AddManual value)?  addManual,TResult? Function( _OpenServer value)?  openServer,TResult? Function( _ConsumeSignal value)?  consumeSignal,}){
final _that = this;
switch (_that) {
case _Start() when start != null:
return start(_that);case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that);case _AddManual() when addManual != null:
return addManual(_that);case _OpenServer() when openServer != null:
return openServer(_that);case _ConsumeSignal() when consumeSignal != null:
return consumeSignal(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  start,TResult Function( List<DiscoveredServer> servers)?  discoveredUpdated,TResult Function( String host,  int port)?  addManual,TResult Function( DiscoveredServer server)?  openServer,TResult Function()?  consumeSignal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Start() when start != null:
return start();case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that.servers);case _AddManual() when addManual != null:
return addManual(_that.host,_that.port);case _OpenServer() when openServer != null:
return openServer(_that.server);case _ConsumeSignal() when consumeSignal != null:
return consumeSignal();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  start,required TResult Function( List<DiscoveredServer> servers)  discoveredUpdated,required TResult Function( String host,  int port)  addManual,required TResult Function( DiscoveredServer server)  openServer,required TResult Function()  consumeSignal,}) {final _that = this;
switch (_that) {
case _Start():
return start();case _DiscoveredUpdated():
return discoveredUpdated(_that.servers);case _AddManual():
return addManual(_that.host,_that.port);case _OpenServer():
return openServer(_that.server);case _ConsumeSignal():
return consumeSignal();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  start,TResult? Function( List<DiscoveredServer> servers)?  discoveredUpdated,TResult? Function( String host,  int port)?  addManual,TResult? Function( DiscoveredServer server)?  openServer,TResult? Function()?  consumeSignal,}) {final _that = this;
switch (_that) {
case _Start() when start != null:
return start();case _DiscoveredUpdated() when discoveredUpdated != null:
return discoveredUpdated(_that.servers);case _AddManual() when addManual != null:
return addManual(_that.host,_that.port);case _OpenServer() when openServer != null:
return openServer(_that.server);case _ConsumeSignal() when consumeSignal != null:
return consumeSignal();case _:
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


class _OpenServer implements DiscoveryEvent {
  const _OpenServer(this.server);
  

 final  DiscoveredServer server;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenServerCopyWith<_OpenServer> get copyWith => __$OpenServerCopyWithImpl<_OpenServer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenServer&&(identical(other.server, server) || other.server == server));
}


@override
int get hashCode => Object.hash(runtimeType,server);

@override
String toString() {
  return 'DiscoveryEvent.openServer(server: $server)';
}


}

/// @nodoc
abstract mixin class _$OpenServerCopyWith<$Res> implements $DiscoveryEventCopyWith<$Res> {
  factory _$OpenServerCopyWith(_OpenServer value, $Res Function(_OpenServer) _then) = __$OpenServerCopyWithImpl;
@useResult
$Res call({
 DiscoveredServer server
});




}
/// @nodoc
class __$OpenServerCopyWithImpl<$Res>
    implements _$OpenServerCopyWith<$Res> {
  __$OpenServerCopyWithImpl(this._self, this._then);

  final _OpenServer _self;
  final $Res Function(_OpenServer) _then;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? server = null,}) {
  return _then(_OpenServer(
null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as DiscoveredServer,
  ));
}


}

/// @nodoc


class _ConsumeSignal implements DiscoveryEvent {
  const _ConsumeSignal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumeSignal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryEvent.consumeSignal()';
}


}




/// @nodoc
mixin _$DiscoveryState {

 DiscoveryStatus get status; List<DiscoveredServer> get discovered; List<DiscoveredServer> get manual; String get errorMessage;/// The server whose reachability is currently being checked, so only that
/// row shows a spinner.
 DiscoveredServer? get checkingServer;/// Set once when a tapped server is confirmed reachable; the screen
/// navigates and then clears it via [DiscoveryEvent.consumeSignal].
 DiscoveredServer? get verifiedServer;/// Set once when a tapped server turns out to be unreachable; the screen
/// shows a toast and then clears it via [DiscoveryEvent.consumeSignal].
 String? get unreachableMessage;
/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryStateCopyWith<DiscoveryState> get copyWith => _$DiscoveryStateCopyWithImpl<DiscoveryState>(this as DiscoveryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.discovered, discovered)&&const DeepCollectionEquality().equals(other.manual, manual)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.checkingServer, checkingServer) || other.checkingServer == checkingServer)&&(identical(other.verifiedServer, verifiedServer) || other.verifiedServer == verifiedServer)&&(identical(other.unreachableMessage, unreachableMessage) || other.unreachableMessage == unreachableMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(discovered),const DeepCollectionEquality().hash(manual),errorMessage,checkingServer,verifiedServer,unreachableMessage);

@override
String toString() {
  return 'DiscoveryState(status: $status, discovered: $discovered, manual: $manual, errorMessage: $errorMessage, checkingServer: $checkingServer, verifiedServer: $verifiedServer, unreachableMessage: $unreachableMessage)';
}


}

/// @nodoc
abstract mixin class $DiscoveryStateCopyWith<$Res>  {
  factory $DiscoveryStateCopyWith(DiscoveryState value, $Res Function(DiscoveryState) _then) = _$DiscoveryStateCopyWithImpl;
@useResult
$Res call({
 DiscoveryStatus status, List<DiscoveredServer> discovered, List<DiscoveredServer> manual, String errorMessage, DiscoveredServer? checkingServer, DiscoveredServer? verifiedServer, String? unreachableMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? discovered = null,Object? manual = null,Object? errorMessage = null,Object? checkingServer = freezed,Object? verifiedServer = freezed,Object? unreachableMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,discovered: null == discovered ? _self.discovered : discovered // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,manual: null == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,checkingServer: freezed == checkingServer ? _self.checkingServer : checkingServer // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,verifiedServer: freezed == verifiedServer ? _self.verifiedServer : verifiedServer // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,unreachableMessage: freezed == unreachableMessage ? _self.unreachableMessage : unreachableMessage // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage,  DiscoveredServer? checkingServer,  DiscoveredServer? verifiedServer,  String? unreachableMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage,_that.checkingServer,_that.verifiedServer,_that.unreachableMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage,  DiscoveredServer? checkingServer,  DiscoveredServer? verifiedServer,  String? unreachableMessage)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState():
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage,_that.checkingServer,_that.verifiedServer,_that.unreachableMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscoveryStatus status,  List<DiscoveredServer> discovered,  List<DiscoveredServer> manual,  String errorMessage,  DiscoveredServer? checkingServer,  DiscoveredServer? verifiedServer,  String? unreachableMessage)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.status,_that.discovered,_that.manual,_that.errorMessage,_that.checkingServer,_that.verifiedServer,_that.unreachableMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryState implements DiscoveryState {
  const _DiscoveryState({this.status = DiscoveryStatus.initial, final  List<DiscoveredServer> discovered = const <DiscoveredServer>[], final  List<DiscoveredServer> manual = const <DiscoveredServer>[], this.errorMessage = '', this.checkingServer, this.verifiedServer, this.unreachableMessage}): _discovered = discovered,_manual = manual;
  

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
/// The server whose reachability is currently being checked, so only that
/// row shows a spinner.
@override final  DiscoveredServer? checkingServer;
/// Set once when a tapped server is confirmed reachable; the screen
/// navigates and then clears it via [DiscoveryEvent.consumeSignal].
@override final  DiscoveredServer? verifiedServer;
/// Set once when a tapped server turns out to be unreachable; the screen
/// shows a toast and then clears it via [DiscoveryEvent.consumeSignal].
@override final  String? unreachableMessage;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryStateCopyWith<_DiscoveryState> get copyWith => __$DiscoveryStateCopyWithImpl<_DiscoveryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._discovered, _discovered)&&const DeepCollectionEquality().equals(other._manual, _manual)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.checkingServer, checkingServer) || other.checkingServer == checkingServer)&&(identical(other.verifiedServer, verifiedServer) || other.verifiedServer == verifiedServer)&&(identical(other.unreachableMessage, unreachableMessage) || other.unreachableMessage == unreachableMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_discovered),const DeepCollectionEquality().hash(_manual),errorMessage,checkingServer,verifiedServer,unreachableMessage);

@override
String toString() {
  return 'DiscoveryState(status: $status, discovered: $discovered, manual: $manual, errorMessage: $errorMessage, checkingServer: $checkingServer, verifiedServer: $verifiedServer, unreachableMessage: $unreachableMessage)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryStateCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory _$DiscoveryStateCopyWith(_DiscoveryState value, $Res Function(_DiscoveryState) _then) = __$DiscoveryStateCopyWithImpl;
@override @useResult
$Res call({
 DiscoveryStatus status, List<DiscoveredServer> discovered, List<DiscoveredServer> manual, String errorMessage, DiscoveredServer? checkingServer, DiscoveredServer? verifiedServer, String? unreachableMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? discovered = null,Object? manual = null,Object? errorMessage = null,Object? checkingServer = freezed,Object? verifiedServer = freezed,Object? unreachableMessage = freezed,}) {
  return _then(_DiscoveryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,discovered: null == discovered ? _self._discovered : discovered // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,manual: null == manual ? _self._manual : manual // ignore: cast_nullable_to_non_nullable
as List<DiscoveredServer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,checkingServer: freezed == checkingServer ? _self.checkingServer : checkingServer // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,verifiedServer: freezed == verifiedServer ? _self.verifiedServer : verifiedServer // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,unreachableMessage: freezed == unreachableMessage ? _self.unreachableMessage : unreachableMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
