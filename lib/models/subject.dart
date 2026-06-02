class Subject {
  final String id;
  final String name;
  final String code;
  final String schedule;

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.schedule,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
        schedule: json['schedule'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'schedule': schedule,
      };
}
