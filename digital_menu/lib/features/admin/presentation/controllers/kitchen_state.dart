import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../menu/domain/entities/order.dart';

part 'kitchen_state.freezed.dart';

@freezed
abstract class KitchenState with _$KitchenState {
  const factory KitchenState({
    required bool isLoading,
    required List<Order> orders,
    String? errorMessage,
  }) = _KitchenState;


  factory KitchenState.initial() => const KitchenState(
        isLoading: true,
        orders: [],
      );
}
