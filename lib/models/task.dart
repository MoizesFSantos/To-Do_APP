final String tableTask = 'task';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Task {
  int id;
  String title;
  bool done;

  taskMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['done'] = done;

    return mapping;
  }

  Map<String, Object> toMap() {
    var map = <String, Object>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Task();

  Task.fromMap(Map<String, Object> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}
