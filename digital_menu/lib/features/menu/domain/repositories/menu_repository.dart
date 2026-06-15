import 'dart:typed_data';
import '../../../../core/network/cloud_result.dart';
import '../entities/menu_category.dart';
import '../entities/dish.dart';
import '../entities/special.dart';

abstract class MenuRepository {
  Stream<CloudResult<List<MenuCategory>>> streamCategories();
  Stream<CloudResult<List<Dish>>> streamDishesByCategory(String categoryId);
  Future<CloudResult<void>> addDish(Dish dish);
  Future<CloudResult<String>> uploadImage(String fileName, Uint8List fileBytes);
  Future<CloudResult<void>> updateDish(Dish dish);
  Future<CloudResult<void>> deleteDish(String dishId);
  Stream<CloudResult<Special?>> streamDailySpecial();
  Future<CloudResult<void>> setDailySpecial(String dishId, String title, int expiresAt);
  Future<CloudResult<void>> submitRating(String dishId, int rating);
  Future<CloudResult<Dish>> getDishById(String dishId);
  Future<CloudResult<List<Dish>>> getAllDishes();
}


