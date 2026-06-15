import '../../../../core/network/cloud_result.dart';
import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class GetAllDishesUseCase {
  final MenuRepository _repository;

  GetAllDishesUseCase(this._repository);

  Future<CloudResult<List<Dish>>> call() {
    return _repository.getAllDishes();
  }
}
