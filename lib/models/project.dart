class Project {
  final String id;
  final String name;
  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': name,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name']
    );
  }
}
