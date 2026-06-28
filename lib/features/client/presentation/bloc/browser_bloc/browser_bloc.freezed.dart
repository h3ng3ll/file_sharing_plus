// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browser_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowserEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowserEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowserEvent()';
}


}

/// @nodoc
class $BrowserEventCopyWith<$Res>  {
$BrowserEventCopyWith(BrowserEvent _, $Res Function(BrowserEvent) __);
}


/// Adds pattern-matching-related methods to [BrowserEvent].
extension BrowserEventPatterns on BrowserEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _LoadFiles value)?  loadFiles,TResult Function( _StartWatching value)?  startWatching,TResult Function( _OpenFolder value)?  openFolder,TResult Function( _GoUp value)?  goUp,TResult Function( _Download value)?  download,TResult Function( _PickAndUpload value)?  pickAndUpload,TResult Function( _TransferFinished value)?  transferFinished,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _LoadFiles() when loadFiles != null:
return loadFiles(_that);case _StartWatching() when startWatching != null:
return startWatching(_that);case _OpenFolder() when openFolder != null:
return openFolder(_that);case _GoUp() when goUp != null:
return goUp(_that);case _Download() when download != null:
return download(_that);case _PickAndUpload() when pickAndUpload != null:
return pickAndUpload(_that);case _TransferFinished() when transferFinished != null:
return transferFinished(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _LoadFiles value)  loadFiles,required TResult Function( _StartWatching value)  startWatching,required TResult Function( _OpenFolder value)  openFolder,required TResult Function( _GoUp value)  goUp,required TResult Function( _Download value)  download,required TResult Function( _PickAndUpload value)  pickAndUpload,required TResult Function( _TransferFinished value)  transferFinished,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _LoadFiles():
return loadFiles(_that);case _StartWatching():
return startWatching(_that);case _OpenFolder():
return openFolder(_that);case _GoUp():
return goUp(_that);case _Download():
return download(_that);case _PickAndUpload():
return pickAndUpload(_that);case _TransferFinished():
return transferFinished(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _LoadFiles value)?  loadFiles,TResult? Function( _StartWatching value)?  startWatching,TResult? Function( _OpenFolder value)?  openFolder,TResult? Function( _GoUp value)?  goUp,TResult? Function( _Download value)?  download,TResult? Function( _PickAndUpload value)?  pickAndUpload,TResult? Function( _TransferFinished value)?  transferFinished,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _LoadFiles() when loadFiles != null:
return loadFiles(_that);case _StartWatching() when startWatching != null:
return startWatching(_that);case _OpenFolder() when openFolder != null:
return openFolder(_that);case _GoUp() when goUp != null:
return goUp(_that);case _Download() when download != null:
return download(_that);case _PickAndUpload() when pickAndUpload != null:
return pickAndUpload(_that);case _TransferFinished() when transferFinished != null:
return transferFinished(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DiscoveredServer server)?  init,TResult Function()?  loadFiles,TResult Function()?  startWatching,TResult Function( String name)?  openFolder,TResult Function()?  goUp,TResult Function( String fileName)?  download,TResult Function()?  pickAndUpload,TResult Function( String fileName,  TransferDirection direction,  bool success,  String? savedPath)?  transferFinished,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that.server);case _LoadFiles() when loadFiles != null:
return loadFiles();case _StartWatching() when startWatching != null:
return startWatching();case _OpenFolder() when openFolder != null:
return openFolder(_that.name);case _GoUp() when goUp != null:
return goUp();case _Download() when download != null:
return download(_that.fileName);case _PickAndUpload() when pickAndUpload != null:
return pickAndUpload();case _TransferFinished() when transferFinished != null:
return transferFinished(_that.fileName,_that.direction,_that.success,_that.savedPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DiscoveredServer server)  init,required TResult Function()  loadFiles,required TResult Function()  startWatching,required TResult Function( String name)  openFolder,required TResult Function()  goUp,required TResult Function( String fileName)  download,required TResult Function()  pickAndUpload,required TResult Function( String fileName,  TransferDirection direction,  bool success,  String? savedPath)  transferFinished,}) {final _that = this;
switch (_that) {
case _Init():
return init(_that.server);case _LoadFiles():
return loadFiles();case _StartWatching():
return startWatching();case _OpenFolder():
return openFolder(_that.name);case _GoUp():
return goUp();case _Download():
return download(_that.fileName);case _PickAndUpload():
return pickAndUpload();case _TransferFinished():
return transferFinished(_that.fileName,_that.direction,_that.success,_that.savedPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DiscoveredServer server)?  init,TResult? Function()?  loadFiles,TResult? Function()?  startWatching,TResult? Function( String name)?  openFolder,TResult? Function()?  goUp,TResult? Function( String fileName)?  download,TResult? Function()?  pickAndUpload,TResult? Function( String fileName,  TransferDirection direction,  bool success,  String? savedPath)?  transferFinished,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that.server);case _LoadFiles() when loadFiles != null:
return loadFiles();case _StartWatching() when startWatching != null:
return startWatching();case _OpenFolder() when openFolder != null:
return openFolder(_that.name);case _GoUp() when goUp != null:
return goUp();case _Download() when download != null:
return download(_that.fileName);case _PickAndUpload() when pickAndUpload != null:
return pickAndUpload();case _TransferFinished() when transferFinished != null:
return transferFinished(_that.fileName,_that.direction,_that.success,_that.savedPath);case _:
  return null;

}
}

}

/// @nodoc


class _Init implements BrowserEvent {
  const _Init(this.server);
  

 final  DiscoveredServer server;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitCopyWith<_Init> get copyWith => __$InitCopyWithImpl<_Init>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init&&(identical(other.server, server) || other.server == server));
}


@override
int get hashCode => Object.hash(runtimeType,server);

@override
String toString() {
  return 'BrowserEvent.init(server: $server)';
}


}

/// @nodoc
abstract mixin class _$InitCopyWith<$Res> implements $BrowserEventCopyWith<$Res> {
  factory _$InitCopyWith(_Init value, $Res Function(_Init) _then) = __$InitCopyWithImpl;
@useResult
$Res call({
 DiscoveredServer server
});




}
/// @nodoc
class __$InitCopyWithImpl<$Res>
    implements _$InitCopyWith<$Res> {
  __$InitCopyWithImpl(this._self, this._then);

  final _Init _self;
  final $Res Function(_Init) _then;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? server = null,}) {
  return _then(_Init(
null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as DiscoveredServer,
  ));
}


}

/// @nodoc


class _LoadFiles implements BrowserEvent {
  const _LoadFiles();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadFiles);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowserEvent.loadFiles()';
}


}




/// @nodoc


class _StartWatching implements BrowserEvent {
  const _StartWatching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartWatching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowserEvent.startWatching()';
}


}




/// @nodoc


class _OpenFolder implements BrowserEvent {
  const _OpenFolder(this.name);
  

 final  String name;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenFolderCopyWith<_OpenFolder> get copyWith => __$OpenFolderCopyWithImpl<_OpenFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenFolder&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'BrowserEvent.openFolder(name: $name)';
}


}

/// @nodoc
abstract mixin class _$OpenFolderCopyWith<$Res> implements $BrowserEventCopyWith<$Res> {
  factory _$OpenFolderCopyWith(_OpenFolder value, $Res Function(_OpenFolder) _then) = __$OpenFolderCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$OpenFolderCopyWithImpl<$Res>
    implements _$OpenFolderCopyWith<$Res> {
  __$OpenFolderCopyWithImpl(this._self, this._then);

  final _OpenFolder _self;
  final $Res Function(_OpenFolder) _then;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_OpenFolder(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GoUp implements BrowserEvent {
  const _GoUp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoUp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowserEvent.goUp()';
}


}




/// @nodoc


class _Download implements BrowserEvent {
  const _Download(this.fileName);
  

 final  String fileName;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadCopyWith<_Download> get copyWith => __$DownloadCopyWithImpl<_Download>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Download&&(identical(other.fileName, fileName) || other.fileName == fileName));
}


@override
int get hashCode => Object.hash(runtimeType,fileName);

@override
String toString() {
  return 'BrowserEvent.download(fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$DownloadCopyWith<$Res> implements $BrowserEventCopyWith<$Res> {
  factory _$DownloadCopyWith(_Download value, $Res Function(_Download) _then) = __$DownloadCopyWithImpl;
@useResult
$Res call({
 String fileName
});




}
/// @nodoc
class __$DownloadCopyWithImpl<$Res>
    implements _$DownloadCopyWith<$Res> {
  __$DownloadCopyWithImpl(this._self, this._then);

  final _Download _self;
  final $Res Function(_Download) _then;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileName = null,}) {
  return _then(_Download(
null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PickAndUpload implements BrowserEvent {
  const _PickAndUpload();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickAndUpload);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowserEvent.pickAndUpload()';
}


}




/// @nodoc


class _TransferFinished implements BrowserEvent {
  const _TransferFinished({required this.fileName, required this.direction, required this.success, this.savedPath});
  

 final  String fileName;
 final  TransferDirection direction;
 final  bool success;
 final  String? savedPath;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferFinishedCopyWith<_TransferFinished> get copyWith => __$TransferFinishedCopyWithImpl<_TransferFinished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferFinished&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.success, success) || other.success == success)&&(identical(other.savedPath, savedPath) || other.savedPath == savedPath));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,direction,success,savedPath);

@override
String toString() {
  return 'BrowserEvent.transferFinished(fileName: $fileName, direction: $direction, success: $success, savedPath: $savedPath)';
}


}

/// @nodoc
abstract mixin class _$TransferFinishedCopyWith<$Res> implements $BrowserEventCopyWith<$Res> {
  factory _$TransferFinishedCopyWith(_TransferFinished value, $Res Function(_TransferFinished) _then) = __$TransferFinishedCopyWithImpl;
@useResult
$Res call({
 String fileName, TransferDirection direction, bool success, String? savedPath
});




}
/// @nodoc
class __$TransferFinishedCopyWithImpl<$Res>
    implements _$TransferFinishedCopyWith<$Res> {
  __$TransferFinishedCopyWithImpl(this._self, this._then);

  final _TransferFinished _self;
  final $Res Function(_TransferFinished) _then;

/// Create a copy of BrowserEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? direction = null,Object? success = null,Object? savedPath = freezed,}) {
  return _then(_TransferFinished(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,savedPath: freezed == savedPath ? _self.savedPath : savedPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BrowserState {

 BrowserStatus get status; DiscoveredServer? get server; String get path; List<FileEntry> get files; TransferProgress? get progress; List<TransferRecord> get history; String get errorMessage;
/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowserStateCopyWith<BrowserState> get copyWith => _$BrowserStateCopyWithImpl<BrowserState>(this as BrowserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowserState&&(identical(other.status, status) || other.status == status)&&(identical(other.server, server) || other.server == server)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,server,path,const DeepCollectionEquality().hash(files),progress,const DeepCollectionEquality().hash(history),errorMessage);

@override
String toString() {
  return 'BrowserState(status: $status, server: $server, path: $path, files: $files, progress: $progress, history: $history, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $BrowserStateCopyWith<$Res>  {
  factory $BrowserStateCopyWith(BrowserState value, $Res Function(BrowserState) _then) = _$BrowserStateCopyWithImpl;
@useResult
$Res call({
 BrowserStatus status, DiscoveredServer? server, String path, List<FileEntry> files, TransferProgress? progress, List<TransferRecord> history, String errorMessage
});


$TransferProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$BrowserStateCopyWithImpl<$Res>
    implements $BrowserStateCopyWith<$Res> {
  _$BrowserStateCopyWithImpl(this._self, this._then);

  final BrowserState _self;
  final $Res Function(BrowserState) _then;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? server = freezed,Object? path = null,Object? files = null,Object? progress = freezed,Object? history = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrowserStatus,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TransferProgress?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<TransferRecord>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $TransferProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [BrowserState].
extension BrowserStatePatterns on BrowserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowserState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowserState value)  $default,){
final _that = this;
switch (_that) {
case _BrowserState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowserState value)?  $default,){
final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BrowserStatus status,  DiscoveredServer? server,  String path,  List<FileEntry> files,  TransferProgress? progress,  List<TransferRecord> history,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
return $default(_that.status,_that.server,_that.path,_that.files,_that.progress,_that.history,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BrowserStatus status,  DiscoveredServer? server,  String path,  List<FileEntry> files,  TransferProgress? progress,  List<TransferRecord> history,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _BrowserState():
return $default(_that.status,_that.server,_that.path,_that.files,_that.progress,_that.history,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BrowserStatus status,  DiscoveredServer? server,  String path,  List<FileEntry> files,  TransferProgress? progress,  List<TransferRecord> history,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
return $default(_that.status,_that.server,_that.path,_that.files,_that.progress,_that.history,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _BrowserState implements BrowserState {
  const _BrowserState({this.status = BrowserStatus.initial, this.server, this.path = '', final  List<FileEntry> files = const <FileEntry>[], this.progress, final  List<TransferRecord> history = const <TransferRecord>[], this.errorMessage = ''}): _files = files,_history = history;
  

@override@JsonKey() final  BrowserStatus status;
@override final  DiscoveredServer? server;
@override@JsonKey() final  String path;
 final  List<FileEntry> _files;
@override@JsonKey() List<FileEntry> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  TransferProgress? progress;
 final  List<TransferRecord> _history;
@override@JsonKey() List<TransferRecord> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@JsonKey() final  String errorMessage;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowserStateCopyWith<_BrowserState> get copyWith => __$BrowserStateCopyWithImpl<_BrowserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowserState&&(identical(other.status, status) || other.status == status)&&(identical(other.server, server) || other.server == server)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,server,path,const DeepCollectionEquality().hash(_files),progress,const DeepCollectionEquality().hash(_history),errorMessage);

@override
String toString() {
  return 'BrowserState(status: $status, server: $server, path: $path, files: $files, progress: $progress, history: $history, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$BrowserStateCopyWith<$Res> implements $BrowserStateCopyWith<$Res> {
  factory _$BrowserStateCopyWith(_BrowserState value, $Res Function(_BrowserState) _then) = __$BrowserStateCopyWithImpl;
@override @useResult
$Res call({
 BrowserStatus status, DiscoveredServer? server, String path, List<FileEntry> files, TransferProgress? progress, List<TransferRecord> history, String errorMessage
});


@override $TransferProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class __$BrowserStateCopyWithImpl<$Res>
    implements _$BrowserStateCopyWith<$Res> {
  __$BrowserStateCopyWithImpl(this._self, this._then);

  final _BrowserState _self;
  final $Res Function(_BrowserState) _then;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? server = freezed,Object? path = null,Object? files = null,Object? progress = freezed,Object? history = null,Object? errorMessage = null,}) {
  return _then(_BrowserState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrowserStatus,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as DiscoveredServer?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TransferProgress?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<TransferRecord>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $TransferProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
