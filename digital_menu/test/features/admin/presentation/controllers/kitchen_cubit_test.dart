import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:digital_menu/core/network/cloud_result.dart';
import 'package:digital_menu/features/menu/domain/entities/order.dart';
import 'package:digital_menu/features/menu/domain/usecases/stream_orders_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/update_order_status_usecase.dart';
import 'package:digital_menu/features/admin/presentation/controllers/kitchen_cubit.dart';
import 'package:digital_menu/features/admin/presentation/controllers/kitchen_state.dart';

class MockStreamOrdersUseCase extends Mock implements StreamOrdersUseCase {}
class MockUpdateOrderStatusUseCase extends Mock implements UpdateOrderStatusUseCase {}

void main() {
  late KitchenCubit cubit;
  late MockStreamOrdersUseCase mockStreamOrdersUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;

  setUp(() {
    mockStreamOrdersUseCase = MockStreamOrdersUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();

    // Default stub for streaming orders to return empty stream
    when(() => mockStreamOrdersUseCase.call()).thenAnswer(
      (_) => Stream.value([]),
    );

    cubit = KitchenCubit(
      streamOrdersUseCase: mockStreamOrdersUseCase,
      updateOrderStatusUseCase: mockUpdateOrderStatusUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tOrder = Order(
    id: 'order123',
    tableNumber: '5',
    items: const [],
    totalPrice: 450.0,
    status: 'pending',
    createdAt: DateTime.now().millisecondsSinceEpoch,
  );

  group('init', () {
    test('initial state is correct', () {
      expect(cubit.state, KitchenState.initial());
    });

    blocTest<KitchenCubit, KitchenState>(
      'subscribes to orders stream and emits new state when orders are received',
      build: () {
        when(() => mockStreamOrdersUseCase.call()).thenAnswer(
          (_) => Stream.value([tOrder]),
        );
        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const KitchenState(isLoading: true, orders: []),
        KitchenState(isLoading: false, orders: [tOrder]),
      ],
    );

    blocTest<KitchenCubit, KitchenState>(
      'subscribes to orders stream and emits error when stream fails',
      build: () {
        when(() => mockStreamOrdersUseCase.call()).thenAnswer(
          (_) => Stream.error('Stream failure'),
        );
        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const KitchenState(isLoading: true, orders: []),
        const KitchenState(
          isLoading: false,
          orders: [],
          errorMessage: 'Error loading orders: Stream failure',
        ),
      ],
    );
  });

  group('updateStatus', () {
    blocTest<KitchenCubit, KitchenState>(
      'calls UpdateOrderStatusUseCase and emits error state if update fails',
      build: () {
        when(() => mockUpdateOrderStatusUseCase.call('order123', 'preparing')).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 500,
            message: 'Failed to update order status',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.updateStatus('order123', 'preparing'),
      expect: () => const [
        KitchenState(
          isLoading: true,
          orders: [],
          errorMessage: 'Failed to update order status',
        ),
      ],
    );

    blocTest<KitchenCubit, KitchenState>(
      'calls UpdateOrderStatusUseCase and does not emit error state if update succeeds',
      build: () {
        when(() => mockUpdateOrderStatusUseCase.call('order123', 'preparing')).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 200,
            message: 'Success',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.updateStatus('order123', 'preparing'),
      expect: () => const [],
    );
  });
}
