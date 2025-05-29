// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traffic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrafficState {
  int get currentIndex;
  int get steps;
  int get maxSteps;
  int get heart;
  int get money;
  int get energy;
  int get maxHeart;
  int get maxMoney;
  int get maxEnergy;

  /// Create a copy of TrafficState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrafficStateCopyWith<TrafficState> get copyWith =>
      _$TrafficStateCopyWithImpl<TrafficState>(
          this as TrafficState, _$identity);

  /// Serializes this TrafficState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrafficState &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.maxSteps, maxSteps) ||
                other.maxSteps == maxSteps) &&
            (identical(other.heart, heart) || other.heart == heart) &&
            (identical(other.money, money) || other.money == money) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.maxHeart, maxHeart) ||
                other.maxHeart == maxHeart) &&
            (identical(other.maxMoney, maxMoney) ||
                other.maxMoney == maxMoney) &&
            (identical(other.maxEnergy, maxEnergy) ||
                other.maxEnergy == maxEnergy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentIndex, steps, maxSteps,
      heart, money, energy, maxHeart, maxMoney, maxEnergy);

  @override
  String toString() {
    return 'TrafficState(currentIndex: $currentIndex, steps: $steps, maxSteps: $maxSteps, heart: $heart, money: $money, energy: $energy, maxHeart: $maxHeart, maxMoney: $maxMoney, maxEnergy: $maxEnergy)';
  }
}

/// @nodoc
abstract mixin class $TrafficStateCopyWith<$Res> {
  factory $TrafficStateCopyWith(
          TrafficState value, $Res Function(TrafficState) _then) =
      _$TrafficStateCopyWithImpl;
  @useResult
  $Res call(
      {int currentIndex,
      int steps,
      int maxSteps,
      int heart,
      int money,
      int energy,
      int maxHeart,
      int maxMoney,
      int maxEnergy});
}

/// @nodoc
class _$TrafficStateCopyWithImpl<$Res> implements $TrafficStateCopyWith<$Res> {
  _$TrafficStateCopyWithImpl(this._self, this._then);

  final TrafficState _self;
  final $Res Function(TrafficState) _then;

  /// Create a copy of TrafficState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? steps = null,
    Object? maxSteps = null,
    Object? heart = null,
    Object? money = null,
    Object? energy = null,
    Object? maxHeart = null,
    Object? maxMoney = null,
    Object? maxEnergy = null,
  }) {
    return _then(_self.copyWith(
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      maxSteps: null == maxSteps
          ? _self.maxSteps
          : maxSteps // ignore: cast_nullable_to_non_nullable
              as int,
      heart: null == heart
          ? _self.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as int,
      money: null == money
          ? _self.money
          : money // ignore: cast_nullable_to_non_nullable
              as int,
      energy: null == energy
          ? _self.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int,
      maxHeart: null == maxHeart
          ? _self.maxHeart
          : maxHeart // ignore: cast_nullable_to_non_nullable
              as int,
      maxMoney: null == maxMoney
          ? _self.maxMoney
          : maxMoney // ignore: cast_nullable_to_non_nullable
              as int,
      maxEnergy: null == maxEnergy
          ? _self.maxEnergy
          : maxEnergy // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TrafficState extends TrafficState {
  const _TrafficState(
      {this.currentIndex = 0,
      this.steps = 3,
      this.maxSteps = 3,
      this.heart = 3,
      this.money = 0,
      this.energy = 3,
      this.maxHeart = 3,
      this.maxMoney = 10,
      this.maxEnergy = 3})
      : super._();
  factory _TrafficState.fromJson(Map<String, dynamic> json) =>
      _$TrafficStateFromJson(json);

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final int steps;
  @override
  @JsonKey()
  final int maxSteps;
  @override
  @JsonKey()
  final int heart;
  @override
  @JsonKey()
  final int money;
  @override
  @JsonKey()
  final int energy;
  @override
  @JsonKey()
  final int maxHeart;
  @override
  @JsonKey()
  final int maxMoney;
  @override
  @JsonKey()
  final int maxEnergy;

  /// Create a copy of TrafficState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrafficStateCopyWith<_TrafficState> get copyWith =>
      __$TrafficStateCopyWithImpl<_TrafficState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrafficStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrafficState &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.maxSteps, maxSteps) ||
                other.maxSteps == maxSteps) &&
            (identical(other.heart, heart) || other.heart == heart) &&
            (identical(other.money, money) || other.money == money) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.maxHeart, maxHeart) ||
                other.maxHeart == maxHeart) &&
            (identical(other.maxMoney, maxMoney) ||
                other.maxMoney == maxMoney) &&
            (identical(other.maxEnergy, maxEnergy) ||
                other.maxEnergy == maxEnergy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentIndex, steps, maxSteps,
      heart, money, energy, maxHeart, maxMoney, maxEnergy);

  @override
  String toString() {
    return 'TrafficState(currentIndex: $currentIndex, steps: $steps, maxSteps: $maxSteps, heart: $heart, money: $money, energy: $energy, maxHeart: $maxHeart, maxMoney: $maxMoney, maxEnergy: $maxEnergy)';
  }
}

/// @nodoc
abstract mixin class _$TrafficStateCopyWith<$Res>
    implements $TrafficStateCopyWith<$Res> {
  factory _$TrafficStateCopyWith(
          _TrafficState value, $Res Function(_TrafficState) _then) =
      __$TrafficStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int currentIndex,
      int steps,
      int maxSteps,
      int heart,
      int money,
      int energy,
      int maxHeart,
      int maxMoney,
      int maxEnergy});
}

/// @nodoc
class __$TrafficStateCopyWithImpl<$Res>
    implements _$TrafficStateCopyWith<$Res> {
  __$TrafficStateCopyWithImpl(this._self, this._then);

  final _TrafficState _self;
  final $Res Function(_TrafficState) _then;

  /// Create a copy of TrafficState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentIndex = null,
    Object? steps = null,
    Object? maxSteps = null,
    Object? heart = null,
    Object? money = null,
    Object? energy = null,
    Object? maxHeart = null,
    Object? maxMoney = null,
    Object? maxEnergy = null,
  }) {
    return _then(_TrafficState(
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      maxSteps: null == maxSteps
          ? _self.maxSteps
          : maxSteps // ignore: cast_nullable_to_non_nullable
              as int,
      heart: null == heart
          ? _self.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as int,
      money: null == money
          ? _self.money
          : money // ignore: cast_nullable_to_non_nullable
              as int,
      energy: null == energy
          ? _self.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int,
      maxHeart: null == maxHeart
          ? _self.maxHeart
          : maxHeart // ignore: cast_nullable_to_non_nullable
              as int,
      maxMoney: null == maxMoney
          ? _self.maxMoney
          : maxMoney // ignore: cast_nullable_to_non_nullable
              as int,
      maxEnergy: null == maxEnergy
          ? _self.maxEnergy
          : maxEnergy // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
