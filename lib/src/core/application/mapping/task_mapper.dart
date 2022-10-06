import '../../domain/task_entity.dart';
import 'mapper.dart';

class TaskMapper extends Mapper<TaskEntity> {
  @override
  TaskEntity? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return TaskEntity.fromJson(map);
  }

  @override
  Map<String, dynamic> toJson(TaskEntity value) {
    return value.toJson();
  }
}
