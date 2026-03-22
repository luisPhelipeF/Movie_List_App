class MovieComments {
  final String id;
  final String comment;
  final DateTime createdAt;

  MovieComments({
    required this.id,
    required this.comment,
    required this.createdAt,
  });

  factory MovieComments.fromJson(Map<String, dynamic> json) {
    return MovieComments(
      id: json['id']?.toString() ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  
  MovieComments copyWith({
    String? comment,
    DateTime? createdAt,
  }) {
    return MovieComments(
      id: id,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, comment: $comment)';
  }
}