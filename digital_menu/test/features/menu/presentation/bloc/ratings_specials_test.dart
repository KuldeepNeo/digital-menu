import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:digital_menu/core/network/cloud_result.dart';
import 'package:digital_menu/features/menu/domain/entities/dish.dart';
import 'package:digital_menu/features/menu/domain/entities/special.dart';
import 'package:digital_menu/features/menu/domain/usecases/get_categories.dart';
import 'package:digital_menu/features/menu/domain/usecases/get_dishes_by_category.dart';
import 'package:digital_menu/features/menu/domain/usecases/get_dish_by_id_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/stream_special_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/submit_rating_usecase.dart';
import 'package:digital_menu/features/menu/presentation/bloc/menu_cubit.dart';
import 'package:digital_menu/features/menu/presentation/bloc/menu_state.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockGetDishesByCategoryUseCase extends Mock implements GetDishesByCategoryUseCase {}
class MockStreamSpecialUseCase extends Mock implements StreamSpecialUseCase {}
class MockGetDishByIdUseCase extends Mock implements GetDishByIdUseCase {}
class MockSubmitRatingUseCase extends Mock implements SubmitRatingUseCase {}

void main() {
  late MenuCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetDishesByCategoryUseCase mockGetDishesByCategoryUseCase;
  late MockStreamSpecialUseCase mockStreamSpecialUseCase;
  late MockGetDishByIdUseCase mockGetDishByIdUseCase;
  late MockSubmitRatingUseCase mockSubmitRatingUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetDishesByCategoryUseCase = MockGetDishesByCategoryUseCase();
    mockStreamSpecialUseCase = MockStreamSpecialUseCase();
    mockGetDishByIdUseCase = MockGetDishByIdUseCase();
    mockSubmitRatingUseCase = MockSubmitRatingUseCase();

    // Default stubs to make sure cubit doesn't break on init
    when(() => mockGetCategoriesUseCase.call()).thenAnswer(
      (_) => Stream.value(const CloudResult(statusCode: 200, data: [], message: 'Success')),
    );
    when(() => mockStreamSpecialUseCase.call()).thenAnswer(
      (_) => Stream.value(const CloudResult(statusCode: 200, data: null, message: 'Success')),
    );


    cubit = MenuCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getDishesByCategoryUseCase: mockGetDishesByCategoryUseCase,
      streamSpecialUseCase: mockStreamSpecialUseCase,
      getDishByIdUseCase: mockGetDishByIdUseCase,
      submitRatingUseCase: mockSubmitRatingUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tDish = Dish(
    id: 'dish123',
    name: 'Special Mocha',
    price: 180.0,
    photoUrl: 'http://photo.com',
    categoryId: 'cat123',
    averageRating: 4.5,
    numRatings: 10,
  );

  final tSpecial = Special(
    id: 'daily',
    dishId: 'dish123',
    title: 'Limited Time Deal!',
    expiresAt: DateTime.now().millisecondsSinceEpoch + 10000, // Valid for 10 seconds
  );

  group('Ratings & Specials Logic', () {
    test('initial state has empty dailySpecial and dailySpecialDish', () {
      expect(cubit.state.dailySpecial, isNull);
      expect(cubit.state.dailySpecialDish, isNull);
    });

    blocTest<MenuCubit, MenuState>(
      'rateDish calls SubmitRatingUseCase',
      build: () {
        when(() => mockSubmitRatingUseCase.call('dish123', 5)).thenAnswer(
          (_) async => const CloudResult(statusCode: 200, message: 'Success'),
        );
        return cubit;
      },
      act: (cubit) => cubit.rateDish('dish123', 5),
      expect: () => const [],
      verify: (_) {
        verify(() => mockSubmitRatingUseCase.call('dish123', 5)).called(1);
      },
    );

    blocTest<MenuCubit, MenuState>(
      'streams special and updates state with special and corresponding dish details',
      build: () {
        when(() => mockStreamSpecialUseCase.call()).thenAnswer(
          (_) => Stream.value(CloudResult(statusCode: 200, data: tSpecial, message: 'Success')),
        );
        when(() => mockGetDishByIdUseCase.call('dish123')).thenAnswer(
          (_) async => CloudResult(statusCode: 200, data: tDish, message: 'Success'),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadMenu(),
      expect: () => [
        const MenuState(isLoadingCategories: true),
        const MenuState(isLoadingCategories: false, categories: []),
        MenuState(
          isLoadingCategories: false,
          categories: const [],
          dailySpecial: tSpecial,
          dailySpecialDish: tDish,
        ),
      ],
    );

    blocTest<MenuCubit, MenuState>(
      'does not emit special if it is expired',
      build: () {
        final expiredSpecial = Special(
          id: 'daily',
          dishId: 'dish123',
          title: 'Expired deal',
          expiresAt: DateTime.now().millisecondsSinceEpoch - 1000, // Expired 1 second ago
        );
        when(() => mockStreamSpecialUseCase.call()).thenAnswer(
          (_) => Stream.value(CloudResult(statusCode: 200, data: expiredSpecial, message: 'Success')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadMenu(),
      expect: () => [
        const MenuState(isLoadingCategories: true),
        const MenuState(isLoadingCategories: false, categories: []),
      ],
    );
  });
}


