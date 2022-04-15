class Task {
  final int id;
  final String task;
  final String created_at;
  final String updated_at;
  final String deleted_at;

  Task(
    this.id,
    this.task,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  );

  @override
  String toString() {
    return 'Task{id: $id, task: $task, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }
}
