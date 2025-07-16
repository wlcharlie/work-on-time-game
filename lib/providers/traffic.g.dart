// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traffic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrafficState _$TrafficStateFromJson(Map<String, dynamic> json) =>
    _TrafficState(
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      steps: (json['steps'] as num?)?.toInt() ?? 3,
      maxSteps: (json['maxSteps'] as num?)?.toInt() ?? 3,
      heart: (json['heart'] as num?)?.toInt() ?? 3,
      money: (json['money'] as num?)?.toInt() ?? 0,
      energy: (json['energy'] as num?)?.toInt() ?? 3,
      maxHeart: (json['maxHeart'] as num?)?.toInt() ?? 3,
      maxMoney: (json['maxMoney'] as num?)?.toInt() ?? 10,
      maxEnergy: (json['maxEnergy'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$TrafficStateToJson(_TrafficState instance) =>
    <String, dynamic>{
      'currentIndex': instance.currentIndex,
      'steps': instance.steps,
      'maxSteps': instance.maxSteps,
      'heart': instance.heart,
      'money': instance.money,
      'energy': instance.energy,
      'maxHeart': instance.maxHeart,
      'maxMoney': instance.maxMoney,
      'maxEnergy': instance.maxEnergy,
    };
