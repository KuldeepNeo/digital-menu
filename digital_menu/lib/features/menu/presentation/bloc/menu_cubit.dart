import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_dishes_by_category.dart';
import '../../domain/usecases/stream_special_usecase.dart';
import '../../domain/usecases/get_dish_by_id_usecase.dart';
import '../../domain/usecases/submit_rating_usecase.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetDishesByCategoryUseCase _getDishesByCategoryUseCase;
  final StreamSpecialUseCase _streamSpecialUseCase;
  final GetDishByIdUseCase _getDishByIdUseCase;
  final SubmitRatingUseCase _submitRatingUseCase;

  StreamSubscription? _categoriesSubscription;
  StreamSubscription? _dishesSubscription;
  StreamSubscription? _specialSubscription;
  Timer? _specialTimer;

  MenuCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetDishesByCategoryUseCase getDishesByCategoryUseCase,
    required StreamSpecialUseCase streamSpecialUseCase,
    required GetDishByIdUseCase getDishByIdUseCase,
    required SubmitRatingUseCase submitRatingUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _getDishesByCategoryUseCase = getDishesByCategoryUseCase,
        _streamSpecialUseCase = streamSpecialUseCase,
        _getDishByIdUseCase = getDishByIdUseCase,
        _submitRatingUseCase = submitRatingUseCase,
        super(const MenuState());

  void loadMenu() {
    emit(state.copyWith(isLoadingCategories: true, errorMessage: null));

    _categoriesSubscription?.cancel();
    _categoriesSubscription = _getCategoriesUseCase().listen(
      (result) {
        if (result.isSuccess && result.data != null) {
          final categories = result.data!;
          emit(state.copyWith(
            categories: categories,
            isLoadingCategories: false,
          ));

          // Auto-select first category if available and no category is currently selected
          if (categories.isNotEmpty && state.selectedCategoryId == null) {
            selectCategory(categories.first.id);
          }
        } else {
          emit(state.copyWith(
            isLoadingCategories: false,
            errorMessage: result.message,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          isLoadingCategories: false,
          errorMessage: error.toString(),
        ));
      },
    );

    _subscribeToSpecial();
  }

  void _subscribeToSpecial() {
    _specialSubscription?.cancel();
    _specialTimer?.cancel();
    _specialSubscription = _streamSpecialUseCase().listen(
      (result) async {
        if (result.isSuccess) {
          final special = result.data;
          if (special == null) {
            emit(state.copyWith(dailySpecial: null, dailySpecialDish: null));
            return;
          }

          // Check client-side expiration
          final now = DateTime.now().millisecondsSinceEpoch;
          final delay = special.expiresAt - now;
          if (delay <= 0) {
            emit(state.copyWith(dailySpecial: null, dailySpecialDish: null));
            return;
          }

          // Start one-shot timer to remove banner at midnight
          _specialTimer?.cancel();
          _specialTimer = Timer(Duration(milliseconds: delay), () {
            emit(state.copyWith(dailySpecial: null, dailySpecialDish: null));
          });

          // Load the linked dish details
          final dishResult = await _getDishByIdUseCase(special.dishId);
          if (dishResult.isSuccess && dishResult.data != null) {
            emit(state.copyWith(
              dailySpecial: special,
              dailySpecialDish: dishResult.data,
            ));
          } else {
            emit(state.copyWith(dailySpecial: null, dailySpecialDish: null));
          }
        }
      },
      onError: (_) {
        emit(state.copyWith(dailySpecial: null, dailySpecialDish: null));
      },
    );
  }

  void selectCategory(String categoryId) {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      isLoadingDishes: true,
      errorMessage: null,
    ));

    _dishesSubscription?.cancel();
    _dishesSubscription = _getDishesByCategoryUseCase(categoryId).listen(
      (result) {
        if (result.isSuccess && result.data != null) {
          emit(state.copyWith(
            dishes: result.data!,
            isLoadingDishes: false,
          ));
        } else {
          emit(state.copyWith(
            isLoadingDishes: false,
            errorMessage: result.message,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          isLoadingDishes: false,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> rateDish(String dishId, int rating) async {
    final result = await _submitRatingUseCase(dishId, rating);
    if (!result.isSuccess) {
      emit(state.copyWith(errorMessage: result.message));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    _dishesSubscription?.cancel();
    _specialSubscription?.cancel();
    _specialTimer?.cancel();
    return super.close();
  }
}

