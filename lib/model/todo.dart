class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Проверка', isDone: false),
      ToDo(id: '02', todoText: 'Проверка11', isDone: true),
      ToDo(
        id: '03',
        todoText: 'todoText2',
      ),
    ];
  }

  // Convert ToDo object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }

  // Create a ToDo object from a map
  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'],
    );
  }
}
