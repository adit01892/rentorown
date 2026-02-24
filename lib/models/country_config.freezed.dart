// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountryConfig {

 String get code; String get currencySymbol; String get currencyCode; double get defaultInterestRate; int get defaultMortgageTerm; double get defaultRentInflation; double get defaultInvestmentReturn; double get defaultPropertyGrowth; bool get hasStampDuty; Map<int, double> get stampDutyBands;
/// Create a copy of CountryConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryConfigCopyWith<CountryConfig> get copyWith => _$CountryConfigCopyWithImpl<CountryConfig>(this as CountryConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryConfig&&(identical(other.code, code) || other.code == code)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.defaultInterestRate, defaultInterestRate) || other.defaultInterestRate == defaultInterestRate)&&(identical(other.defaultMortgageTerm, defaultMortgageTerm) || other.defaultMortgageTerm == defaultMortgageTerm)&&(identical(other.defaultRentInflation, defaultRentInflation) || other.defaultRentInflation == defaultRentInflation)&&(identical(other.defaultInvestmentReturn, defaultInvestmentReturn) || other.defaultInvestmentReturn == defaultInvestmentReturn)&&(identical(other.defaultPropertyGrowth, defaultPropertyGrowth) || other.defaultPropertyGrowth == defaultPropertyGrowth)&&(identical(other.hasStampDuty, hasStampDuty) || other.hasStampDuty == hasStampDuty)&&const DeepCollectionEquality().equals(other.stampDutyBands, stampDutyBands));
}


@override
int get hashCode => Object.hash(runtimeType,code,currencySymbol,currencyCode,defaultInterestRate,defaultMortgageTerm,defaultRentInflation,defaultInvestmentReturn,defaultPropertyGrowth,hasStampDuty,const DeepCollectionEquality().hash(stampDutyBands));

@override
String toString() {
  return 'CountryConfig(code: $code, currencySymbol: $currencySymbol, currencyCode: $currencyCode, defaultInterestRate: $defaultInterestRate, defaultMortgageTerm: $defaultMortgageTerm, defaultRentInflation: $defaultRentInflation, defaultInvestmentReturn: $defaultInvestmentReturn, defaultPropertyGrowth: $defaultPropertyGrowth, hasStampDuty: $hasStampDuty, stampDutyBands: $stampDutyBands)';
}


}

/// @nodoc
abstract mixin class $CountryConfigCopyWith<$Res>  {
  factory $CountryConfigCopyWith(CountryConfig value, $Res Function(CountryConfig) _then) = _$CountryConfigCopyWithImpl;
@useResult
$Res call({
 String code, String currencySymbol, String currencyCode, double defaultInterestRate, int defaultMortgageTerm, double defaultRentInflation, double defaultInvestmentReturn, double defaultPropertyGrowth, bool hasStampDuty, Map<int, double> stampDutyBands
});




}
/// @nodoc
class _$CountryConfigCopyWithImpl<$Res>
    implements $CountryConfigCopyWith<$Res> {
  _$CountryConfigCopyWithImpl(this._self, this._then);

  final CountryConfig _self;
  final $Res Function(CountryConfig) _then;

/// Create a copy of CountryConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? currencySymbol = null,Object? currencyCode = null,Object? defaultInterestRate = null,Object? defaultMortgageTerm = null,Object? defaultRentInflation = null,Object? defaultInvestmentReturn = null,Object? defaultPropertyGrowth = null,Object? hasStampDuty = null,Object? stampDutyBands = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultInterestRate: null == defaultInterestRate ? _self.defaultInterestRate : defaultInterestRate // ignore: cast_nullable_to_non_nullable
as double,defaultMortgageTerm: null == defaultMortgageTerm ? _self.defaultMortgageTerm : defaultMortgageTerm // ignore: cast_nullable_to_non_nullable
as int,defaultRentInflation: null == defaultRentInflation ? _self.defaultRentInflation : defaultRentInflation // ignore: cast_nullable_to_non_nullable
as double,defaultInvestmentReturn: null == defaultInvestmentReturn ? _self.defaultInvestmentReturn : defaultInvestmentReturn // ignore: cast_nullable_to_non_nullable
as double,defaultPropertyGrowth: null == defaultPropertyGrowth ? _self.defaultPropertyGrowth : defaultPropertyGrowth // ignore: cast_nullable_to_non_nullable
as double,hasStampDuty: null == hasStampDuty ? _self.hasStampDuty : hasStampDuty // ignore: cast_nullable_to_non_nullable
as bool,stampDutyBands: null == stampDutyBands ? _self.stampDutyBands : stampDutyBands // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryConfig].
extension CountryConfigPatterns on CountryConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryConfig value)  $default,){
final _that = this;
switch (_that) {
case _CountryConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CountryConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String currencySymbol,  String currencyCode,  double defaultInterestRate,  int defaultMortgageTerm,  double defaultRentInflation,  double defaultInvestmentReturn,  double defaultPropertyGrowth,  bool hasStampDuty,  Map<int, double> stampDutyBands)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryConfig() when $default != null:
return $default(_that.code,_that.currencySymbol,_that.currencyCode,_that.defaultInterestRate,_that.defaultMortgageTerm,_that.defaultRentInflation,_that.defaultInvestmentReturn,_that.defaultPropertyGrowth,_that.hasStampDuty,_that.stampDutyBands);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String currencySymbol,  String currencyCode,  double defaultInterestRate,  int defaultMortgageTerm,  double defaultRentInflation,  double defaultInvestmentReturn,  double defaultPropertyGrowth,  bool hasStampDuty,  Map<int, double> stampDutyBands)  $default,) {final _that = this;
switch (_that) {
case _CountryConfig():
return $default(_that.code,_that.currencySymbol,_that.currencyCode,_that.defaultInterestRate,_that.defaultMortgageTerm,_that.defaultRentInflation,_that.defaultInvestmentReturn,_that.defaultPropertyGrowth,_that.hasStampDuty,_that.stampDutyBands);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String currencySymbol,  String currencyCode,  double defaultInterestRate,  int defaultMortgageTerm,  double defaultRentInflation,  double defaultInvestmentReturn,  double defaultPropertyGrowth,  bool hasStampDuty,  Map<int, double> stampDutyBands)?  $default,) {final _that = this;
switch (_that) {
case _CountryConfig() when $default != null:
return $default(_that.code,_that.currencySymbol,_that.currencyCode,_that.defaultInterestRate,_that.defaultMortgageTerm,_that.defaultRentInflation,_that.defaultInvestmentReturn,_that.defaultPropertyGrowth,_that.hasStampDuty,_that.stampDutyBands);case _:
  return null;

}
}

}

/// @nodoc


class _CountryConfig implements CountryConfig {
  const _CountryConfig({required this.code, required this.currencySymbol, required this.currencyCode, this.defaultInterestRate = 4.5, this.defaultMortgageTerm = 25, this.defaultRentInflation = 2.0, this.defaultInvestmentReturn = 6.0, this.defaultPropertyGrowth = 3.0, this.hasStampDuty = false, final  Map<int, double> stampDutyBands = const {}}): _stampDutyBands = stampDutyBands;
  

@override final  String code;
@override final  String currencySymbol;
@override final  String currencyCode;
@override@JsonKey() final  double defaultInterestRate;
@override@JsonKey() final  int defaultMortgageTerm;
@override@JsonKey() final  double defaultRentInflation;
@override@JsonKey() final  double defaultInvestmentReturn;
@override@JsonKey() final  double defaultPropertyGrowth;
@override@JsonKey() final  bool hasStampDuty;
 final  Map<int, double> _stampDutyBands;
@override@JsonKey() Map<int, double> get stampDutyBands {
  if (_stampDutyBands is EqualUnmodifiableMapView) return _stampDutyBands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stampDutyBands);
}


/// Create a copy of CountryConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryConfigCopyWith<_CountryConfig> get copyWith => __$CountryConfigCopyWithImpl<_CountryConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryConfig&&(identical(other.code, code) || other.code == code)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.defaultInterestRate, defaultInterestRate) || other.defaultInterestRate == defaultInterestRate)&&(identical(other.defaultMortgageTerm, defaultMortgageTerm) || other.defaultMortgageTerm == defaultMortgageTerm)&&(identical(other.defaultRentInflation, defaultRentInflation) || other.defaultRentInflation == defaultRentInflation)&&(identical(other.defaultInvestmentReturn, defaultInvestmentReturn) || other.defaultInvestmentReturn == defaultInvestmentReturn)&&(identical(other.defaultPropertyGrowth, defaultPropertyGrowth) || other.defaultPropertyGrowth == defaultPropertyGrowth)&&(identical(other.hasStampDuty, hasStampDuty) || other.hasStampDuty == hasStampDuty)&&const DeepCollectionEquality().equals(other._stampDutyBands, _stampDutyBands));
}


@override
int get hashCode => Object.hash(runtimeType,code,currencySymbol,currencyCode,defaultInterestRate,defaultMortgageTerm,defaultRentInflation,defaultInvestmentReturn,defaultPropertyGrowth,hasStampDuty,const DeepCollectionEquality().hash(_stampDutyBands));

@override
String toString() {
  return 'CountryConfig(code: $code, currencySymbol: $currencySymbol, currencyCode: $currencyCode, defaultInterestRate: $defaultInterestRate, defaultMortgageTerm: $defaultMortgageTerm, defaultRentInflation: $defaultRentInflation, defaultInvestmentReturn: $defaultInvestmentReturn, defaultPropertyGrowth: $defaultPropertyGrowth, hasStampDuty: $hasStampDuty, stampDutyBands: $stampDutyBands)';
}


}

/// @nodoc
abstract mixin class _$CountryConfigCopyWith<$Res> implements $CountryConfigCopyWith<$Res> {
  factory _$CountryConfigCopyWith(_CountryConfig value, $Res Function(_CountryConfig) _then) = __$CountryConfigCopyWithImpl;
@override @useResult
$Res call({
 String code, String currencySymbol, String currencyCode, double defaultInterestRate, int defaultMortgageTerm, double defaultRentInflation, double defaultInvestmentReturn, double defaultPropertyGrowth, bool hasStampDuty, Map<int, double> stampDutyBands
});




}
/// @nodoc
class __$CountryConfigCopyWithImpl<$Res>
    implements _$CountryConfigCopyWith<$Res> {
  __$CountryConfigCopyWithImpl(this._self, this._then);

  final _CountryConfig _self;
  final $Res Function(_CountryConfig) _then;

/// Create a copy of CountryConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? currencySymbol = null,Object? currencyCode = null,Object? defaultInterestRate = null,Object? defaultMortgageTerm = null,Object? defaultRentInflation = null,Object? defaultInvestmentReturn = null,Object? defaultPropertyGrowth = null,Object? hasStampDuty = null,Object? stampDutyBands = null,}) {
  return _then(_CountryConfig(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultInterestRate: null == defaultInterestRate ? _self.defaultInterestRate : defaultInterestRate // ignore: cast_nullable_to_non_nullable
as double,defaultMortgageTerm: null == defaultMortgageTerm ? _self.defaultMortgageTerm : defaultMortgageTerm // ignore: cast_nullable_to_non_nullable
as int,defaultRentInflation: null == defaultRentInflation ? _self.defaultRentInflation : defaultRentInflation // ignore: cast_nullable_to_non_nullable
as double,defaultInvestmentReturn: null == defaultInvestmentReturn ? _self.defaultInvestmentReturn : defaultInvestmentReturn // ignore: cast_nullable_to_non_nullable
as double,defaultPropertyGrowth: null == defaultPropertyGrowth ? _self.defaultPropertyGrowth : defaultPropertyGrowth // ignore: cast_nullable_to_non_nullable
as double,hasStampDuty: null == hasStampDuty ? _self.hasStampDuty : hasStampDuty // ignore: cast_nullable_to_non_nullable
as bool,stampDutyBands: null == stampDutyBands ? _self._stampDutyBands : stampDutyBands // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}


}

// dart format on
