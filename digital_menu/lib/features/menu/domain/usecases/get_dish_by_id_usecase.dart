import '../../../../core/network/cloud_result.dart';
import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class GetDishByIdUseCase {
  final MenuRepository _repository;

  GetDishByIdUseCase(this._repository);

  Future<CloudResult<Dish>> call(String dishId) {
    return _repository.getDishById(dishId);
  }
}
