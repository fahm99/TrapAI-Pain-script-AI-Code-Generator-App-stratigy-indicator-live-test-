class PineScriptEntity {
  final String id;
  final String filename;
  final String version;
  final String content;
  final String mode;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PineScriptEntity({
    required this.id,
    required this.filename,
    required this.version,
    required this.content,
    required this.mode,
    required this.createdAt,
    this.updatedAt,
  });

  PineScriptEntity copyWith({
    String? filename,
    String? version,
    String? content,
    String? mode,
  }) {
    return PineScriptEntity(
      id: id,
      filename: filename ?? this.filename,
      version: version ?? this.version,
      content: content ?? this.content,
      mode: mode ?? this.mode,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
