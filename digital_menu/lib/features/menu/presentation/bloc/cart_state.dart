import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_item.dart';

part 'cart_state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    required Map<String, int> itemQuantities,
    required Map<String, OrderItem> itemDetails,
    String? tableNumber,
    @Default(false) bool isSubmitting,
    String? errorMessage,
    @Default(false) bool submitSuccess,
  }) = _CartState;

  factory CartState.initial() => const CartState(
        itemQuantities: {},
        itemDetails: {},
        tableNumber: null,
        isSubmitting: false,
        errorMessage: null,
        submitSuccess: false,
      );
}
