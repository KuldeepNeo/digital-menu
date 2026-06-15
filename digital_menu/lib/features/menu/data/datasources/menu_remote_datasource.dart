import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/constants.dart';
import '../models/menu_category_model.dart';
import '../models/dish_model.dart';
import '../models/special_model.dart';

abstract class MenuRemoteDataSource {
  Stream<List<MenuCategoryModel>> streamCategories();
  Stream<List<DishModel>> streamDishesByCategory(String categoryId);
  Future<void> addDish(DishModel dish);
  Future<String> uploadImage(String fileName, Uint8List fileBytes);
  Future<void> updateDish(DishModel dish);
  Future<void> deleteDish(String dishId);
  Stream<SpecialModel?> streamDailySpecial();
  Future<void> setDailySpecial(String dishId, String title, int expiresAt);
  Future<void> submitRating(String dishId, int rating);
  Future<DishModel> getDishById(String dishId);
  Future<List<DishModel>> getAllDishes();
}



class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore _firestore;

  MenuRemoteDataSourceImpl(this._firestore);

  CollectionReference<MenuCategoryModel> get _categoriesRef => _firestore
      .collection(FirestoreCollections.categories)
      .withConverter<MenuCategoryModel>(
        fromFirestore: (snapshot, _) => MenuCategoryModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  CollectionReference<DishModel> get _dishesRef => _firestore
      .collection(FirestoreCollections.dishes)
      .withConverter<DishModel>(
        fromFirestore: (snapshot, _) => DishModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  @override
  Stream<List<MenuCategoryModel>> streamCategories() {
    return _categoriesRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  @override
  Stream<List<DishModel>> streamDishesByCategory(String categoryId) {
    return _dishesRef
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) => doc.data()).toList();
      list.sort((a, b) {
        final aTime = a.createdAt ?? 0;
        final bTime = b.createdAt ?? 0;
        return aTime.compareTo(bTime);
      });
      return list;
    });
  }

  @override
  Future<void> addDish(DishModel dish) async {
    await _dishesRef.add(dish);
  }

  @override
  Future<String> uploadImage(String fileName, Uint8List fileBytes) async {
    final extension = fileName.split('.').last.toLowerCase();
    final base64Str = base64Encode(fileBytes);
    return 'data:image/$extension;base64,$base64Str';
  }

  @override
  Future<void> updateDish(DishModel dish) async {
    await _dishesRef.doc(dish.id).set(dish);
  }

  @override
  Future<void> deleteDish(String dishId) async {
    await _dishesRef.doc(dishId).delete();
  }

  CollectionReference<SpecialModel> get _specialsRef => _firestore
      .collection(FirestoreCollections.specials)
      .withConverter<SpecialModel>(
        fromFirestore: (snapshot, _) => SpecialModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  @override
  Stream<SpecialModel?> streamDailySpecial() {
    return _specialsRef.doc('daily').snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return snapshot.data();
    });
  }

  @override
  Future<void> setDailySpecial(String dishId, String title, int expiresAt) async {
    final model = SpecialModel(
      id: 'daily',
      dishId: dishId,
      title: title,
      expiresAt: expiresAt,
    );
    await _specialsRef.doc('daily').set(model);
  }

  @override
  Future<void> submitRating(String dishId, int rating) async {
    final docRef = _dishesRef.doc(dishId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Dish does not exist!");
      }
      final data = snapshot.data();
      if (data == null) {
        throw Exception("Dish data is null!");
      }
      final currentNum = data.numRatings;
      final currentAverage = data.averageRating;

      final newNum = currentNum + 1;
      final newAverage = ((currentAverage * currentNum) + rating) / newNum;

      transaction.update(docRef, {
        'numRatings': newNum,
        'averageRating': double.parse(newAverage.toStringAsFixed(2)),
      });
    });
  }

  @override
  Future<DishModel> getDishById(String dishId) async {
    final snapshot = await _dishesRef.doc(dishId).get();
    if (!snapshot.exists) {
      throw Exception("Dish does not exist!");
    }
    return snapshot.data()!;
  }

  @override
  Future<List<DishModel>> getAllDishes() async {
    final snapshot = await _dishesRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}


