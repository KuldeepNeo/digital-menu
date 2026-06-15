import '../../../../core/network/cloud_result.dart';
import '../entities/special.dart';
import '../repositories/menu_repository.dart';

class StreamSpecialUseCase {
  final MenuRepository _repository;

  StreamSpecialUseCase(this._repository);

  Stream<CloudResult<Special?>> call() {
    return _repository.streamDailySpecial();
  }
}
