class Project {
  String? projectId;
  String? title;
  String? description;
  List<String>? users;
  DateTime? startAt;
  DateTime? endAt;
  String? status;
  double? progress;

  Project({
    this.projectId,
    this.title,
    this.description,
    this.users,
    this.startAt,
    this.endAt,
    this.status,
    this.progress,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      users: (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
      startAt: json['startAt'] != null ? DateTime.tryParse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.tryParse(json['endAt']) : null,
      status: json['status'] as String?,
      progress: (json['progress'] != null)
          ? (json['progress'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'users': users,
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
      'status': status,
      'progress': progress,
    };
  }
}