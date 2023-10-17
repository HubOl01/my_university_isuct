final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id,
    title,
    content,
    number,
    date_created,
    note_color
    // date_updated,
  ];

  static final String id = '_id';
  static final String number = 'number';
  static final String title = 'title';
  static final String content = 'content';
  static final String date_created = 'date_created';
  static final String note_color = 'note_color';
  // static final String date_updated = 'date_updated';
}

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime date_created;
  // final DateTime? date_updated;
  final int? number;
  final int note_color;

  const Note({
    this.id,
    this.number,
    required this.title,
    required this.content,
    required this.date_created,
    required this.note_color,
    // this.date_updated,
  });
  Note copy({
    int? id,
    String? title,
    int? number,
    String? content,
    DateTime? date_created,
    int? note_color,
    // DateTime? date_updated,
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          number: number ?? this.number,
          content: content ?? this.content,
          date_created: date_created ?? this.date_created,
          note_color: note_color ?? this.note_color
          // date_updated: date_updated ?? this.date_updated,
          );
  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as int?,
      number: json[NoteFields.number] as int? ?? 0,
      title: json[NoteFields.title] as String,
      content: json[NoteFields.content] as String,
      date_created: DateTime.parse(json[NoteFields.date_created] as String),
      note_color: json[NoteFields.note_color] as int
      // date_updated: DateTime.parse([NoteFields.date_updated] as String),
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.number: number ?? 0,
        NoteFields.content: content,
        NoteFields.date_created: date_created.toIso8601String(),
        NoteFields.note_color: note_color
        // NoteFields.date_updated: date_updated!.toIso8601String(),
      };
}
