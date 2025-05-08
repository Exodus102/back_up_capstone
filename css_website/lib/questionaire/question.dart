class Question {
  final int id;
  final String questionText;
  final String type;
  final List<String>? choices;

  Question({
    required this.id,
    required this.questionText,
    required this.type,
    this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: int.parse(json['id']),
      questionText: json['question_text'],
      type: json['type'],
      choices:
          json['choices'] != null ? List<String>.from(json['choices']) : null,
    );
  }
}
