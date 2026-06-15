import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:digital_menu/core/network/cloud_result.dart';
import 'package:digital_menu/features/menu/domain/entities/dish.dart';
import 'package:digital_menu/features/menu/domain/entities/order.dart';
import 'package:digital_menu/features/menu/domain/entities/order_item.dart';
import 'package:digital_menu/features/menu/domain/usecases/submit_order_usecase.dart';
import 'package:digital_menu/features/menu/presentation/bloc/cart_cubit.dart';
import 'package:digital_menu/features/menu/presentation/bloc/cart_state.dart';

class MockSubmitOrderUseCase extends Mock implements SubmitOrderUseCase {}
class FakeOrder extends Fake implements Order {}

void main() {
  late CartCubit cubit;
  late MockSubmitOrderUseCase mockSubmitOrderUseCase;

  setUpAll(() {
    registerFallbackValue(FakeOrder());
  });

  setUp(() {
    mockSubmitOrderUseCase = MockSubmitOrderUseCase();
    cubit = CartCubit(submitOrderUseCase: mockSubmitOrderUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tDish = Dish(
    id: 'dish123',
    name: 'Test Dish',
    price: 150.0,
    photoUrl: 'http://photo.com',
    categoryId: 'cat123',
    isAvailable: true,
  );

  final tUnavailableDish = Dish(
    id: 'dish456',
    name: 'Unavailable Dish',
    price: 200.0,
    photoUrl: 'http://photo.com',
    categoryId: 'cat123',
    isAvailable: false,
  );

  group('Cart Operations', () {
    test('initial state is correct', () {
      expect(cubit.state, CartState.initial());
    });

    blocTest<CartCubit, CartState>(
      'addDish adds dish to cart',
      build: () => cubit,
      act: (cubit) => cubit.addDish(tDish),
      expect: () => [
        predicate<CartState>((state) {
          return state.itemQuantities[tDish.id] == 1 &&
              state.itemDetails[tDish.id]?.name == tDish.name;
        }),
      ],
    );

    blocTest<CartCubit, CartState>(
      'addDish does not add unavailable dish',
      build: () => cubit,
      act: (cubit) => cubit.addDish(tUnavailableDish),
      expect: () => const [],
    );

    blocTest<CartCubit, CartState>(
      'removeDish decrements quantity and removes if quantity is 1',
      build: () => cubit,
      seed: () => CartState(
        itemQuantities: {tDish.id: 1},
        itemDetails: {tDish.id: const OrderItem(dishId: 'dish123', name: 'Test Dish', price: 150.0, quantity: 1)},
      ),
      act: (cubit) => cubit.removeDish(tDish),
      expect: () => [
        predicate<CartState>((state) {
          return state.itemQuantities.isEmpty && state.itemDetails.isEmpty;
        }),
      ],
    );

    blocTest<CartCubit, CartState>(
      'setTableNumber sets table number',
      build: () => cubit,
      act: (cubit) => cubit.setTableNumber('5'),
      expect: () => [
        predicate<CartState>((state) => state.tableNumber == '5'),
      ],
    );

    blocTest<CartCubit, CartState>(
      'clearCart empties cart and table',
      build: () => cubit,
      seed: () => CartState(
        itemQuantities: {tDish.id: 2},
        itemDetails: {
          tDish.id: tDish.isAvailable ? const OrderItem(dishId: 'dish123', name: 'Test Dish', price: 150.0, quantity: 2) : const OrderItem(dishId: 'dish123', name: 'Test Dish', price: 150.0, quantity: 2)
        },
        tableNumber: '5',
      ),
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        CartState.initial(),
      ],
    );
  });

  group('submitOrder', () {
    blocTest<CartCubit, CartState>(
      'emits error when table number is not set',
      build: () => cubit,
      seed: () => CartState(
        itemQuantities: {tDish.id: 1},
        itemDetails: {tDish.id: const OrderItem(dishId: 'dish123', name: 'Test Dish', price: 150.0, quantity: 1)},
        tableNumber: null,
      ),
      act: (cubit) => cubit.submitOrder(),
      expect: () => [
        predicate<CartState>((state) =>
            state.errorMessage == 'Please select a table number before checking out.' &&
            !state.submitSuccess),
      ],
    );

    blocTest<CartCubit, CartState>(
      'emits error when cart is empty',
      build: () => cubit,
      seed: () => const CartState(
        itemQuantities: {},
        itemDetails: {},
        tableNumber: '3',
      ),
      act: (cubit) => cubit.submitOrder(),
      expect: () => [
        predicate<CartState>((state) =>
            state.errorMessage == 'Your cart is empty.' &&
            !state.submitSuccess),
      ],
    );

    blocTest<CartCubit, CartState>(
      'emits [isSubmitting: true, submitSuccess: true] when submit succeeds',
      build: () {
        when(() => mockSubmitOrderUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 200,
            message: 'Success',
          ),
        );
        return cubit;
      },
      seed: () => CartState(
        itemQuantities: {tDish.id: 2},
        itemDetails: {tDish.id: const OrderItem(dishId: 'dish123', name: 'Test Dish', price: 150.0, quantity: 2)},
        tableNumber: '5',
      ),
      act: (cubit) => cubit.submitOrder(),
      expect: () => [
        predicate<CartState>((state) =>
            state.isSubmitting && !state.submitSuccess && state.errorMessage == null),
        CartState.initial(),
        CartState.initial().copyWith(submitSuccess: true),
      ],
      verify: (_) {
        verify(() => mockSubmitOrderUseCase.call(any())).called(1);
      },
    );
  });
}
