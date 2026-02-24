// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simulation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SimulationResult {

 List<NetWorthPoint> get buyNetWorth; List<NetWorthPoint> get rentNetWorth; double get finalDifference; List<double> get buyCashFlow; List<double> get rentCashFlow; int? get breakevenYear;
/// Create a copy of SimulationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimulationResultCopyWith<SimulationResult> get copyWith => _$SimulationResultCopyWithImpl<SimulationResult>(this as SimulationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimulationResult&&const DeepCollectionEquality().equals(other.buyNetWorth, buyNetWorth)&&const DeepCollectionEquality().equals(other.rentNetWorth, rentNetWorth)&&(identical(other.finalDifference, finalDifference) || other.finalDifference == finalDifference)&&const DeepCollectionEquality().equals(other.buyCashFlow, buyCashFlow)&&const DeepCollectionEquality().equals(other.rentCashFlow, rentCashFlow)&&(identical(other.breakevenYear, breakevenYear) || other.breakevenYear == breakevenYear));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(buyNetWorth),const DeepCollectionEquality().hash(rentNetWorth),finalDifference,const DeepCollectionEquality().hash(buyCashFlow),const DeepCollectionEquality().hash(rentCashFlow),breakevenYear);

@override
String toString() {
  return 'SimulationResult(buyNetWorth: $buyNetWorth, rentNetWorth: $rentNetWorth, finalDifference: $finalDifference, buyCashFlow: $buyCashFlow, rentCashFlow: $rentCashFlow, breakevenYear: $breakevenYear)';
}


}

/// @nodoc
abstract mixin class $SimulationResultCopyWith<$Res>  {
  factory $SimulationResultCopyWith(SimulationResult value, $Res Function(SimulationResult) _then) = _$SimulationResultCopyWithImpl;
@useResult
$Res call({
 List<NetWorthPoint> buyNetWorth, List<NetWorthPoint> rentNetWorth, double finalDifference, List<double> buyCashFlow, List<double> rentCashFlow, int? breakevenYear
});




}
/// @nodoc
class _$SimulationResultCopyWithImpl<$Res>
    implements $SimulationResultCopyWith<$Res> {
  _$SimulationResultCopyWithImpl(this._self, this._then);

  final SimulationResult _self;
  final $Res Function(SimulationResult) _then;

/// Create a copy of SimulationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? buyNetWorth = null,Object? rentNetWorth = null,Object? finalDifference = null,Object? buyCashFlow = null,Object? rentCashFlow = null,Object? breakevenYear = freezed,}) {
  return _then(_self.copyWith(
buyNetWorth: null == buyNetWorth ? _self.buyNetWorth : buyNetWorth // ignore: cast_nullable_to_non_nullable
as List<NetWorthPoint>,rentNetWorth: null == rentNetWorth ? _self.rentNetWorth : rentNetWorth // ignore: cast_nullable_to_non_nullable
as List<NetWorthPoint>,finalDifference: null == finalDifference ? _self.finalDifference : finalDifference // ignore: cast_nullable_to_non_nullable
as double,buyCashFlow: null == buyCashFlow ? _self.buyCashFlow : buyCashFlow // ignore: cast_nullable_to_non_nullable
as List<double>,rentCashFlow: null == rentCashFlow ? _self.rentCashFlow : rentCashFlow // ignore: cast_nullable_to_non_nullable
as List<double>,breakevenYear: freezed == breakevenYear ? _self.breakevenYear : breakevenYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SimulationResult].
extension SimulationResultPatterns on SimulationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimulationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimulationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimulationResult value)  $default,){
final _that = this;
switch (_that) {
case _SimulationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimulationResult value)?  $default,){
final _that = this;
switch (_that) {
case _SimulationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NetWorthPoint> buyNetWorth,  List<NetWorthPoint> rentNetWorth,  double finalDifference,  List<double> buyCashFlow,  List<double> rentCashFlow,  int? breakevenYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimulationResult() when $default != null:
return $default(_that.buyNetWorth,_that.rentNetWorth,_that.finalDifference,_that.buyCashFlow,_that.rentCashFlow,_that.breakevenYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NetWorthPoint> buyNetWorth,  List<NetWorthPoint> rentNetWorth,  double finalDifference,  List<double> buyCashFlow,  List<double> rentCashFlow,  int? breakevenYear)  $default,) {final _that = this;
switch (_that) {
case _SimulationResult():
return $default(_that.buyNetWorth,_that.rentNetWorth,_that.finalDifference,_that.buyCashFlow,_that.rentCashFlow,_that.breakevenYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NetWorthPoint> buyNetWorth,  List<NetWorthPoint> rentNetWorth,  double finalDifference,  List<double> buyCashFlow,  List<double> rentCashFlow,  int? breakevenYear)?  $default,) {final _that = this;
switch (_that) {
case _SimulationResult() when $default != null:
return $default(_that.buyNetWorth,_that.rentNetWorth,_that.finalDifference,_that.buyCashFlow,_that.rentCashFlow,_that.breakevenYear);case _:
  return null;

}
}

}

/// @nodoc


class _SimulationResult implements SimulationResult {
  const _SimulationResult({required final  List<NetWorthPoint> buyNetWorth, required final  List<NetWorthPoint> rentNetWorth, required this.finalDifference, required final  List<double> buyCashFlow, required final  List<double> rentCashFlow, this.breakevenYear}): _buyNetWorth = buyNetWorth,_rentNetWorth = rentNetWorth,_buyCashFlow = buyCashFlow,_rentCashFlow = rentCashFlow;
  

 final  List<NetWorthPoint> _buyNetWorth;
@override List<NetWorthPoint> get buyNetWorth {
  if (_buyNetWorth is EqualUnmodifiableListView) return _buyNetWorth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buyNetWorth);
}

 final  List<NetWorthPoint> _rentNetWorth;
@override List<NetWorthPoint> get rentNetWorth {
  if (_rentNetWorth is EqualUnmodifiableListView) return _rentNetWorth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rentNetWorth);
}

@override final  double finalDifference;
 final  List<double> _buyCashFlow;
@override List<double> get buyCashFlow {
  if (_buyCashFlow is EqualUnmodifiableListView) return _buyCashFlow;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buyCashFlow);
}

 final  List<double> _rentCashFlow;
@override List<double> get rentCashFlow {
  if (_rentCashFlow is EqualUnmodifiableListView) return _rentCashFlow;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rentCashFlow);
}

@override final  int? breakevenYear;

/// Create a copy of SimulationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimulationResultCopyWith<_SimulationResult> get copyWith => __$SimulationResultCopyWithImpl<_SimulationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimulationResult&&const DeepCollectionEquality().equals(other._buyNetWorth, _buyNetWorth)&&const DeepCollectionEquality().equals(other._rentNetWorth, _rentNetWorth)&&(identical(other.finalDifference, finalDifference) || other.finalDifference == finalDifference)&&const DeepCollectionEquality().equals(other._buyCashFlow, _buyCashFlow)&&const DeepCollectionEquality().equals(other._rentCashFlow, _rentCashFlow)&&(identical(other.breakevenYear, breakevenYear) || other.breakevenYear == breakevenYear));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_buyNetWorth),const DeepCollectionEquality().hash(_rentNetWorth),finalDifference,const DeepCollectionEquality().hash(_buyCashFlow),const DeepCollectionEquality().hash(_rentCashFlow),breakevenYear);

@override
String toString() {
  return 'SimulationResult(buyNetWorth: $buyNetWorth, rentNetWorth: $rentNetWorth, finalDifference: $finalDifference, buyCashFlow: $buyCashFlow, rentCashFlow: $rentCashFlow, breakevenYear: $breakevenYear)';
}


}

/// @nodoc
abstract mixin class _$SimulationResultCopyWith<$Res> implements $SimulationResultCopyWith<$Res> {
  factory _$SimulationResultCopyWith(_SimulationResult value, $Res Function(_SimulationResult) _then) = __$SimulationResultCopyWithImpl;
@override @useResult
$Res call({
 List<NetWorthPoint> buyNetWorth, List<NetWorthPoint> rentNetWorth, double finalDifference, List<double> buyCashFlow, List<double> rentCashFlow, int? breakevenYear
});




}
/// @nodoc
class __$SimulationResultCopyWithImpl<$Res>
    implements _$SimulationResultCopyWith<$Res> {
  __$SimulationResultCopyWithImpl(this._self, this._then);

  final _SimulationResult _self;
  final $Res Function(_SimulationResult) _then;

/// Create a copy of SimulationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? buyNetWorth = null,Object? rentNetWorth = null,Object? finalDifference = null,Object? buyCashFlow = null,Object? rentCashFlow = null,Object? breakevenYear = freezed,}) {
  return _then(_SimulationResult(
buyNetWorth: null == buyNetWorth ? _self._buyNetWorth : buyNetWorth // ignore: cast_nullable_to_non_nullable
as List<NetWorthPoint>,rentNetWorth: null == rentNetWorth ? _self._rentNetWorth : rentNetWorth // ignore: cast_nullable_to_non_nullable
as List<NetWorthPoint>,finalDifference: null == finalDifference ? _self.finalDifference : finalDifference // ignore: cast_nullable_to_non_nullable
as double,buyCashFlow: null == buyCashFlow ? _self._buyCashFlow : buyCashFlow // ignore: cast_nullable_to_non_nullable
as List<double>,rentCashFlow: null == rentCashFlow ? _self._rentCashFlow : rentCashFlow // ignore: cast_nullable_to_non_nullable
as List<double>,breakevenYear: freezed == breakevenYear ? _self.breakevenYear : breakevenYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$NetWorthPoint {

 int get year; double get amount;
/// Create a copy of NetWorthPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetWorthPointCopyWith<NetWorthPoint> get copyWith => _$NetWorthPointCopyWithImpl<NetWorthPoint>(this as NetWorthPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetWorthPoint&&(identical(other.year, year) || other.year == year)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,year,amount);

@override
String toString() {
  return 'NetWorthPoint(year: $year, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $NetWorthPointCopyWith<$Res>  {
  factory $NetWorthPointCopyWith(NetWorthPoint value, $Res Function(NetWorthPoint) _then) = _$NetWorthPointCopyWithImpl;
@useResult
$Res call({
 int year, double amount
});




}
/// @nodoc
class _$NetWorthPointCopyWithImpl<$Res>
    implements $NetWorthPointCopyWith<$Res> {
  _$NetWorthPointCopyWithImpl(this._self, this._then);

  final NetWorthPoint _self;
  final $Res Function(NetWorthPoint) _then;

/// Create a copy of NetWorthPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? amount = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NetWorthPoint].
extension NetWorthPointPatterns on NetWorthPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetWorthPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetWorthPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetWorthPoint value)  $default,){
final _that = this;
switch (_that) {
case _NetWorthPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetWorthPoint value)?  $default,){
final _that = this;
switch (_that) {
case _NetWorthPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetWorthPoint() when $default != null:
return $default(_that.year,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  double amount)  $default,) {final _that = this;
switch (_that) {
case _NetWorthPoint():
return $default(_that.year,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _NetWorthPoint() when $default != null:
return $default(_that.year,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _NetWorthPoint implements NetWorthPoint {
  const _NetWorthPoint({required this.year, required this.amount});
  

@override final  int year;
@override final  double amount;

/// Create a copy of NetWorthPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetWorthPointCopyWith<_NetWorthPoint> get copyWith => __$NetWorthPointCopyWithImpl<_NetWorthPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetWorthPoint&&(identical(other.year, year) || other.year == year)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,year,amount);

@override
String toString() {
  return 'NetWorthPoint(year: $year, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$NetWorthPointCopyWith<$Res> implements $NetWorthPointCopyWith<$Res> {
  factory _$NetWorthPointCopyWith(_NetWorthPoint value, $Res Function(_NetWorthPoint) _then) = __$NetWorthPointCopyWithImpl;
@override @useResult
$Res call({
 int year, double amount
});




}
/// @nodoc
class __$NetWorthPointCopyWithImpl<$Res>
    implements _$NetWorthPointCopyWith<$Res> {
  __$NetWorthPointCopyWithImpl(this._self, this._then);

  final _NetWorthPoint _self;
  final $Res Function(_NetWorthPoint) _then;

/// Create a copy of NetWorthPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? amount = null,}) {
  return _then(_NetWorthPoint(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
