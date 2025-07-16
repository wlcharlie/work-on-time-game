import 'package:work_on_time_game/screen/event_scene/base_event_scene.dart';

/// 红绿灯倒数事件场景
class TrafficLightScene extends BaseEventScene {
  @override
  String get eventDataPath => 'assets/data/traffic_light_event.json';
  
  @override
  String get sceneName => 'traffic light';
}