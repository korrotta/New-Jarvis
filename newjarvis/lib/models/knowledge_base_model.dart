class Knowledge {
  final String id;
  final String name; 
  final String description;
  final String createdAt;
  final String updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedAt;
  final String userId;
  final int numUnits;
  final int totalSize;

  Knowledge({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.userId,
    required this.numUnits,
    required this.totalSize,
  });

  // Factory method để chuyển JSON thành đối tượng Knowledge
  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'],
      name: json['knowledgeName'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'],
      userId: json['userId'],
      numUnits: json['numUnits'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
    );
  }

  // Phương thức chuyển đổi đối tượng Knowledge thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'knowledgeName': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'userId': userId,
      'numUnits': numUnits,
      'totalSize': totalSize,
    };
  }
}
