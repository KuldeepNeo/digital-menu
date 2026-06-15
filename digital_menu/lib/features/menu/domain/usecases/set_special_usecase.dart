import '../../../../core/network/cloud_result.dart';
import '../repositories/menu_repository.dart';

class SetSpecialUseCase {
  final MenuRepository _repository;

  SetSpecialUseCase(this._repository);

  Future<CloudResult<void>> call(String dishId, String title, int expiresAt) {
    return _repository.setDailySpecial(dishId, title, expiresAt);
  }
}
