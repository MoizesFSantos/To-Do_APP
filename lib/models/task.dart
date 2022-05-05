final String tableTask = 'task';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Task {
  int id;
  String title;
  String description;
  String category;
  String taskDate;
  int isFinished;

  taskMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['taskDate'] = taskDate;
    mapping['isFinished'] = isFinished;

    return mapping;
  }

  Task();
}
