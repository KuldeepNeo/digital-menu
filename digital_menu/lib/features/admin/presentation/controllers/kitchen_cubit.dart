import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../menu/domain/usecases/stream_orders_usecase.dart';
import '../../../menu/domain/usecases/update_order_status_usecase.dart';
import 'kitchen_state.dart';

class KitchenCubit extends Cubit<KitchenState> {
  final StreamOrdersUseCase _streamOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  StreamSubscription? _subscription;

  KitchenCubit({
    required StreamOrdersUseCase streamOrdersUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
  })  : _streamOrdersUseCase = streamOrdersUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase,
        super(KitchenState.initial());

  void init() {
    _subscription?.cancel();
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _subscription = _streamOrdersUseCase().listen(
      (orders) {
        emit(state.copyWith(
          isLoading: false,
          orders: orders,
        ));
      },
      onError: (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error loading orders: $e',
        ));
      },
    );
  }

  Future<void> updateStatus(String orderId, String status) async {
    final result = await _updateOrderStatusUseCase(orderId, status);
    if (!result.isSuccess) {
      emit(state.copyWith(errorMessage: result.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
