// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent()';
}


}

/// @nodoc
class $ServerEventCopyWith<$Res>  {
$ServerEventCopyWith(ServerEvent _, $Res Function(ServerEvent) __);
}


/// Adds pattern-matching-related methods to [ServerEvent].
extension ServerEventPatterns on ServerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _StartServer value)?  startServer,TResult Function( _StopServer value)?  stopServer,TResult Function( _SelectFolder value)?  selectFolder,TResult Function( _PortChanged value)?  portChanged,TResult Function( _RefreshFiles value)?  refreshFiles,TResult Function( _DevicesUpdated value)?  devicesUpdated,TResult Function( _LogReceived value)?  logReceived,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _StartServer() when startServer != null:
return startServer(_that);case _StopServer() when stopServer != null:
return stopServer(_that);case _SelectFolder() when selectFolder != null:
return selectFolder(_that);case _PortChanged() when portChanged != null:
return portChanged(_that);case _RefreshFiles() when refreshFiles != null:
return refreshFiles(_that);case _DevicesUpdated() when devicesUpdated != null:
return devicesUpdated(_that);case _LogReceived() when logReceived != null:
return logReceived(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _StartServer value)  startServer,required TResult Function( _StopServer value)  stopServer,required TResult Function( _SelectFolder value)  selectFolder,required TResult Function( _PortChanged value)  portChanged,required TResult Function( _RefreshFiles value)  refreshFiles,required TResult Function( _DevicesUpdated value)  devicesUpdated,required TResult Function( _LogReceived value)  logReceived,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _StartServer():
return startServer(_that);case _StopServer():
return stopServer(_that);case _SelectFolder():
return selectFolder(_that);case _PortChanged():
return portChanged(_that);case _RefreshFiles():
return refreshFiles(_that);case _DevicesUpdated():
return devicesUpdated(_that);case _LogReceived():
return logReceived(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _StartServer value)?  startServer,TResult? Function( _StopServer value)?  stopServer,TResult? Function( _SelectFolder value)?  selectFolder,TResult? Function( _PortChanged value)?  portChanged,TResult? Function( _RefreshFiles value)?  refreshFiles,TResult? Function( _DevicesUpdated value)?  devicesUpdated,TResult? Function( _LogReceived value)?  logReceived,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _StartServer() when startServer != null:
return startServer(_that);case _StopServer() when stopServer != null:
return stopServer(_that);case _SelectFolder() when selectFolder != null:
return selectFolder(_that);case _PortChanged() when portChanged != null:
return portChanged(_that);case _RefreshFiles() when refreshFiles != null:
return refreshFiles(_that);case _DevicesUpdated() when devicesUpdated != null:
return devicesUpdated(_that);case _LogReceived() when logReceived != null:
return logReceived(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function()?  startServer,TResult Function()?  stopServer,TResult Function()?  selectFolder,TResult Function( int port)?  portChanged,TResult Function()?  refreshFiles,TResult Function( List<ConnectedDevice> devices)?  devicesUpdated,TResult Function( ActivityLogEntry entry)?  logReceived,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _StartServer() when startServer != null:
return startServer();case _StopServer() when stopServer != null:
return stopServer();case _SelectFolder() when selectFolder != null:
return selectFolder();case _PortChanged() when portChanged != null:
return portChanged(_that.port);case _RefreshFiles() when refreshFiles != null:
return refreshFiles();case _DevicesUpdated() when devicesUpdated != null:
return devicesUpdated(_that.devices);case _LogReceived() when logReceived != null:
return logReceived(_that.entry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function()  startServer,required TResult Function()  stopServer,required TResult Function()  selectFolder,required TResult Function( int port)  portChanged,required TResult Function()  refreshFiles,required TResult Function( List<ConnectedDevice> devices)  devicesUpdated,required TResult Function( ActivityLogEntry entry)  logReceived,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _StartServer():
return startServer();case _StopServer():
return stopServer();case _SelectFolder():
return selectFolder();case _PortChanged():
return portChanged(_that.port);case _RefreshFiles():
return refreshFiles();case _DevicesUpdated():
return devicesUpdated(_that.devices);case _LogReceived():
return logReceived(_that.entry);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function()?  startServer,TResult? Function()?  stopServer,TResult? Function()?  selectFolder,TResult? Function( int port)?  portChanged,TResult? Function()?  refreshFiles,TResult? Function( List<ConnectedDevice> devices)?  devicesUpdated,TResult? Function( ActivityLogEntry entry)?  logReceived,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _StartServer() when startServer != null:
return startServer();case _StopServer() when stopServer != null:
return stopServer();case _SelectFolder() when selectFolder != null:
return selectFolder();case _PortChanged() when portChanged != null:
return portChanged(_that.port);case _RefreshFiles() when refreshFiles != null:
return refreshFiles();case _DevicesUpdated() when devicesUpdated != null:
return devicesUpdated(_that.devices);case _LogReceived() when logReceived != null:
return logReceived(_that.entry);case _:
  return null;

}
}

}

/// @nodoc


class _Init implements ServerEvent {
  const _Init();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent.init()';
}


}




/// @nodoc


class _StartServer implements ServerEvent {
  const _StartServer();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartServer);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent.startServer()';
}


}




/// @nodoc


class _StopServer implements ServerEvent {
  const _StopServer();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopServer);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent.stopServer()';
}


}




/// @nodoc


class _SelectFolder implements ServerEvent {
  const _SelectFolder();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectFolder);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent.selectFolder()';
}


}




/// @nodoc


class _PortChanged implements ServerEvent {
  const _PortChanged(this.port);
  

 final  int port;

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortChangedCopyWith<_PortChanged> get copyWith => __$PortChangedCopyWithImpl<_PortChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortChanged&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,port);

@override
String toString() {
  return 'ServerEvent.portChanged(port: $port)';
}


}

/// @nodoc
abstract mixin class _$PortChangedCopyWith<$Res> implements $ServerEventCopyWith<$Res> {
  factory _$PortChangedCopyWith(_PortChanged value, $Res Function(_PortChanged) _then) = __$PortChangedCopyWithImpl;
@useResult
$Res call({
 int port
});




}
/// @nodoc
class __$PortChangedCopyWithImpl<$Res>
    implements _$PortChangedCopyWith<$Res> {
  __$PortChangedCopyWithImpl(this._self, this._then);

  final _PortChanged _self;
  final $Res Function(_PortChanged) _then;

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? port = null,}) {
  return _then(_PortChanged(
null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _RefreshFiles implements ServerEvent {
  const _RefreshFiles();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshFiles);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerEvent.refreshFiles()';
}


}




/// @nodoc


class _DevicesUpdated implements ServerEvent {
  const _DevicesUpdated(final  List<ConnectedDevice> devices): _devices = devices;
  

 final  List<ConnectedDevice> _devices;
 List<ConnectedDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevicesUpdatedCopyWith<_DevicesUpdated> get copyWith => __$DevicesUpdatedCopyWithImpl<_DevicesUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevicesUpdated&&const DeepCollectionEquality().equals(other._devices, _devices));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices));

@override
String toString() {
  return 'ServerEvent.devicesUpdated(devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$DevicesUpdatedCopyWith<$Res> implements $ServerEventCopyWith<$Res> {
  factory _$DevicesUpdatedCopyWith(_DevicesUpdated value, $Res Function(_DevicesUpdated) _then) = __$DevicesUpdatedCopyWithImpl;
@useResult
$Res call({
 List<ConnectedDevice> devices
});




}
/// @nodoc
class __$DevicesUpdatedCopyWithImpl<$Res>
    implements _$DevicesUpdatedCopyWith<$Res> {
  __$DevicesUpdatedCopyWithImpl(this._self, this._then);

  final _DevicesUpdated _self;
  final $Res Function(_DevicesUpdated) _then;

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? devices = null,}) {
  return _then(_DevicesUpdated(
null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<ConnectedDevice>,
  ));
}


}

/// @nodoc


class _LogReceived implements ServerEvent {
  const _LogReceived(this.entry);
  

 final  ActivityLogEntry entry;

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogReceivedCopyWith<_LogReceived> get copyWith => __$LogReceivedCopyWithImpl<_LogReceived>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogReceived&&(identical(other.entry, entry) || other.entry == entry));
}


@override
int get hashCode => Object.hash(runtimeType,entry);

@override
String toString() {
  return 'ServerEvent.logReceived(entry: $entry)';
}


}

/// @nodoc
abstract mixin class _$LogReceivedCopyWith<$Res> implements $ServerEventCopyWith<$Res> {
  factory _$LogReceivedCopyWith(_LogReceived value, $Res Function(_LogReceived) _then) = __$LogReceivedCopyWithImpl;
@useResult
$Res call({
 ActivityLogEntry entry
});


$ActivityLogEntryCopyWith<$Res> get entry;

}
/// @nodoc
class __$LogReceivedCopyWithImpl<$Res>
    implements _$LogReceivedCopyWith<$Res> {
  __$LogReceivedCopyWithImpl(this._self, this._then);

  final _LogReceived _self;
  final $Res Function(_LogReceived) _then;

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entry = null,}) {
  return _then(_LogReceived(
null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as ActivityLogEntry,
  ));
}

/// Create a copy of ServerEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityLogEntryCopyWith<$Res> get entry {
  
  return $ActivityLogEntryCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

/// @nodoc
mixin _$ServerState {

 ServerStatus get status; int get port; String? get ipAddress; String? get sharedFolder;/// True when [sharedFolder] is set but no longer exists on disk (e.g. it
/// was moved/deleted since it was saved).
 bool get sharedFolderMissing; List<FileEntry> get files; List<ConnectedDevice> get devices; List<ActivityLogEntry> get log; String get errorMessage;
/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStateCopyWith<ServerState> get copyWith => _$ServerStateCopyWithImpl<ServerState>(this as ServerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerState&&(identical(other.status, status) || other.status == status)&&(identical(other.port, port) || other.port == port)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.sharedFolder, sharedFolder) || other.sharedFolder == sharedFolder)&&(identical(other.sharedFolderMissing, sharedFolderMissing) || other.sharedFolderMissing == sharedFolderMissing)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.devices, devices)&&const DeepCollectionEquality().equals(other.log, log)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,port,ipAddress,sharedFolder,sharedFolderMissing,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(devices),const DeepCollectionEquality().hash(log),errorMessage);

@override
String toString() {
  return 'ServerState(status: $status, port: $port, ipAddress: $ipAddress, sharedFolder: $sharedFolder, sharedFolderMissing: $sharedFolderMissing, files: $files, devices: $devices, log: $log, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ServerStateCopyWith<$Res>  {
  factory $ServerStateCopyWith(ServerState value, $Res Function(ServerState) _then) = _$ServerStateCopyWithImpl;
@useResult
$Res call({
 ServerStatus status, int port, String? ipAddress, String? sharedFolder, bool sharedFolderMissing, List<FileEntry> files, List<ConnectedDevice> devices, List<ActivityLogEntry> log, String errorMessage
});




}
/// @nodoc
class _$ServerStateCopyWithImpl<$Res>
    implements $ServerStateCopyWith<$Res> {
  _$ServerStateCopyWithImpl(this._self, this._then);

  final ServerState _self;
  final $Res Function(ServerState) _then;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? port = null,Object? ipAddress = freezed,Object? sharedFolder = freezed,Object? sharedFolderMissing = null,Object? files = null,Object? devices = null,Object? log = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ServerStatus,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,sharedFolder: freezed == sharedFolder ? _self.sharedFolder : sharedFolder // ignore: cast_nullable_to_non_nullable
as String?,sharedFolderMissing: null == sharedFolderMissing ? _self.sharedFolderMissing : sharedFolderMissing // ignore: cast_nullable_to_non_nullable
as bool,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<ConnectedDevice>,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as List<ActivityLogEntry>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerState].
extension ServerStatePatterns on ServerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerState value)  $default,){
final _that = this;
switch (_that) {
case _ServerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerState value)?  $default,){
final _that = this;
switch (_that) {
case _ServerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ServerStatus status,  int port,  String? ipAddress,  String? sharedFolder,  bool sharedFolderMissing,  List<FileEntry> files,  List<ConnectedDevice> devices,  List<ActivityLogEntry> log,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerState() when $default != null:
return $default(_that.status,_that.port,_that.ipAddress,_that.sharedFolder,_that.sharedFolderMissing,_that.files,_that.devices,_that.log,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ServerStatus status,  int port,  String? ipAddress,  String? sharedFolder,  bool sharedFolderMissing,  List<FileEntry> files,  List<ConnectedDevice> devices,  List<ActivityLogEntry> log,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ServerState():
return $default(_that.status,_that.port,_that.ipAddress,_that.sharedFolder,_that.sharedFolderMissing,_that.files,_that.devices,_that.log,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ServerStatus status,  int port,  String? ipAddress,  String? sharedFolder,  bool sharedFolderMissing,  List<FileEntry> files,  List<ConnectedDevice> devices,  List<ActivityLogEntry> log,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ServerState() when $default != null:
return $default(_that.status,_that.port,_that.ipAddress,_that.sharedFolder,_that.sharedFolderMissing,_that.files,_that.devices,_that.log,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ServerState implements ServerState {
  const _ServerState({this.status = ServerStatus.stopped, this.port = 8080, this.ipAddress, this.sharedFolder, this.sharedFolderMissing = false, final  List<FileEntry> files = const <FileEntry>[], final  List<ConnectedDevice> devices = const <ConnectedDevice>[], final  List<ActivityLogEntry> log = const <ActivityLogEntry>[], this.errorMessage = ''}): _files = files,_devices = devices,_log = log;
  

@override@JsonKey() final  ServerStatus status;
@override@JsonKey() final  int port;
@override final  String? ipAddress;
@override final  String? sharedFolder;
/// True when [sharedFolder] is set but no longer exists on disk (e.g. it
/// was moved/deleted since it was saved).
@override@JsonKey() final  bool sharedFolderMissing;
 final  List<FileEntry> _files;
@override@JsonKey() List<FileEntry> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  List<ConnectedDevice> _devices;
@override@JsonKey() List<ConnectedDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

 final  List<ActivityLogEntry> _log;
@override@JsonKey() List<ActivityLogEntry> get log {
  if (_log is EqualUnmodifiableListView) return _log;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_log);
}

@override@JsonKey() final  String errorMessage;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStateCopyWith<_ServerState> get copyWith => __$ServerStateCopyWithImpl<_ServerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerState&&(identical(other.status, status) || other.status == status)&&(identical(other.port, port) || other.port == port)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.sharedFolder, sharedFolder) || other.sharedFolder == sharedFolder)&&(identical(other.sharedFolderMissing, sharedFolderMissing) || other.sharedFolderMissing == sharedFolderMissing)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._devices, _devices)&&const DeepCollectionEquality().equals(other._log, _log)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,port,ipAddress,sharedFolder,sharedFolderMissing,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_devices),const DeepCollectionEquality().hash(_log),errorMessage);

@override
String toString() {
  return 'ServerState(status: $status, port: $port, ipAddress: $ipAddress, sharedFolder: $sharedFolder, sharedFolderMissing: $sharedFolderMissing, files: $files, devices: $devices, log: $log, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ServerStateCopyWith<$Res> implements $ServerStateCopyWith<$Res> {
  factory _$ServerStateCopyWith(_ServerState value, $Res Function(_ServerState) _then) = __$ServerStateCopyWithImpl;
@override @useResult
$Res call({
 ServerStatus status, int port, String? ipAddress, String? sharedFolder, bool sharedFolderMissing, List<FileEntry> files, List<ConnectedDevice> devices, List<ActivityLogEntry> log, String errorMessage
});




}
/// @nodoc
class __$ServerStateCopyWithImpl<$Res>
    implements _$ServerStateCopyWith<$Res> {
  __$ServerStateCopyWithImpl(this._self, this._then);

  final _ServerState _self;
  final $Res Function(_ServerState) _then;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? port = null,Object? ipAddress = freezed,Object? sharedFolder = freezed,Object? sharedFolderMissing = null,Object? files = null,Object? devices = null,Object? log = null,Object? errorMessage = null,}) {
  return _then(_ServerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ServerStatus,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,sharedFolder: freezed == sharedFolder ? _self.sharedFolder : sharedFolder // ignore: cast_nullable_to_non_nullable
as String?,sharedFolderMissing: null == sharedFolderMissing ? _self.sharedFolderMissing : sharedFolderMissing // ignore: cast_nullable_to_non_nullable
as bool,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<ConnectedDevice>,log: null == log ? _self._log : log // ignore: cast_nullable_to_non_nullable
as List<ActivityLogEntry>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
