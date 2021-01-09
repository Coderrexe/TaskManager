class TodoItem {
  final int id;
  final int taskId;
  final String text;
  final int isDone;

  TodoItem({this.id, this.taskId, this.text, this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'text': text,
      'is_done': isDone,
    };
  }
}
