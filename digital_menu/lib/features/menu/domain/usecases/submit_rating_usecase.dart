import '../../../../core/network/cloud_result.dart';
import '../repositories/menu_repository.dart';

class SubmitRatingUseCase {
  final MenuRepository _repository;

  SubmitRatingUseCase(this._repository);

  Future<CloudResult<void>> call(String dishId, int rating) {
    return _repository.submitRating(dishId, rating);
  }
}
