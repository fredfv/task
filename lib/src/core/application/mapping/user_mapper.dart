import '../../domain/user_entity.dart';
import 'mapper.dart';

class UserMapper extends Mapper<UserEntity> {
  @override
  UserEntity? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return UserEntity.fromJson(map);
  }

  @override
  Map<String, dynamic> toJson(UserEntity value) {
    return value.toJson();
  }
}
