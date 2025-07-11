
class EventData {
  final String id;
  final String name;
  final List<PreconditionData> preconditions;
  final List<FlowStepData> flow;

  EventData({
    required this.id,
    required this.name,
    required this.preconditions,
    required this.flow,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      name: json['name'],
      preconditions: (json['preconditions'] as List)
          .map((e) => PreconditionData.fromJson(e))
          .toList(),
      flow: (json['flow'] as List)
          .map((e) => FlowStepData.fromJson(e))
          .toList(),
    );
  }
}

class FlowStepData {
  final String id;
  final String text;
  final List<ChoiceData> choices;

  FlowStepData({
    required this.id,
    required this.text,
    required this.choices,
  });

  factory FlowStepData.fromJson(Map<String, dynamic> json) {
    return FlowStepData(
      id: json['id'],
      text: json['text'],
      choices: (json['choices'] as List)
          .map((e) => ChoiceData.fromJson(e))
          .toList(),
    );
  }
}

class ChoiceData {
  final String id;
  final String text;
  final VisibilityData visibility;
  final AvailabilityData availability;
  final double delay;
  final List<OutcomeData> outcomes;

  ChoiceData({
    required this.id,
    required this.text,
    required this.visibility,
    required this.availability,
    required this.delay,
    required this.outcomes,
  });

  factory ChoiceData.fromJson(Map<String, dynamic> json) {
    return ChoiceData(
      id: json['id'],
      text: json['text'],
      visibility: VisibilityData.fromJson(json['visibility'] ?? {}),
      availability: AvailabilityData.fromJson(json['availability'] ?? {}),
      delay: (json['delay'] ?? 0).toDouble(),
      outcomes: (json['outcomes'] as List)
          .map((e) => OutcomeData.fromJson(e))
          .toList(),
    );
  }
}

class VisibilityData {
  final List<ConditionData> conditions;

  VisibilityData({required this.conditions});

  factory VisibilityData.fromJson(Map<String, dynamic> json) {
    return VisibilityData(
      conditions: (json['conditions'] as List? ?? [])
          .map((e) => ConditionData.fromJson(e))
          .toList(),
    );
  }
}

class AvailabilityData {
  final List<ConditionData> conditions;
  final String? disabledText;

  AvailabilityData({required this.conditions, this.disabledText});

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    return AvailabilityData(
      conditions: (json['conditions'] as List? ?? [])
          .map((e) => ConditionData.fromJson(e))
          .toList(),
      disabledText: json['disabled_text'],
    );
  }
}

class OutcomeData {
  final List<ConditionData> conditions;
  final List<EffectData> effects;
  final String? goto;
  final ResultData? result;

  OutcomeData({
    required this.conditions,
    required this.effects,
    this.goto,
    this.result,
  });

  factory OutcomeData.fromJson(Map<String, dynamic> json) {
    return OutcomeData(
      conditions: (json['conditions'] as List? ?? [])
          .map((e) => ConditionData.fromJson(e))
          .toList(),
      effects: (json['effects'] as List? ?? [])
          .map((e) => EffectData.fromJson(e))
          .toList(),
      goto: json['goto'],
      result: json['result'] != null ? ResultData.fromJson(json['result']) : null,
    );
  }
}

class ConditionData {
  final String type;
  final String? status;
  final int? value;
  final String? item;
  final int? percentage;

  ConditionData({
    required this.type,
    this.status,
    this.value,
    this.item,
    this.percentage,
  });

  factory ConditionData.fromJson(Map<String, dynamic> json) {
    return ConditionData(
      type: json['type'],
      status: json['status'],
      value: json['value'],
      item: json['item'],
      percentage: json['percentage'],
    );
  }
}

class EffectData {
  final String type;
  final String? status;
  final int? delta;
  final String? item;

  EffectData({
    required this.type,
    this.status,
    this.delta,
    this.item,
  });

  factory EffectData.fromJson(Map<String, dynamic> json) {
    return EffectData(
      type: json['type'],
      status: json['status'],
      delta: json['delta'],
      item: json['item'],
    );
  }
}

class ResultData {
  final String title;
  final String description;

  ResultData({required this.title, required this.description});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      title: json['title'],
      description: json['description'],
    );
  }
}

class PreconditionData {
  final String type;
  final String? status;
  final int? value;
  final String? item;

  PreconditionData({
    required this.type,
    this.status,
    this.value,
    this.item,
  });

  factory PreconditionData.fromJson(Map<String, dynamic> json) {
    return PreconditionData(
      type: json['type'],
      status: json['status'],
      value: json['value'],
      item: json['item'],
    );
  }
}