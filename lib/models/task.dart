class Task {
  final int id;
  final String task;

  Task(
    this.id,
    this.task,
  );

  @override
  String toString() {
    return 'Task{id: $id, task: $task}';
  }
}
