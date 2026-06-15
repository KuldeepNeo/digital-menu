import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../domain/entities/dish.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/submit_order_usecase.dart';
import '../../data/models/order_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final SubmitOrderUseCase _submitOrderUseCase;

  CartCubit({
    required SubmitOrderUseCase submitOrderUseCase,
  })  : _submitOrderUseCase = submitOrderUseCase,
        super(CartState.initial());

  static const String _tableKey = 'cart_table_number';
  static const String _quantitiesKey = 'cart_item_quantities';
  static const String _detailsKey = 'cart_item_details';

  void loadCart() {
    try {
      final tableNumber = StorageHelper.load(_tableKey);
      final quantitiesStr = StorageHelper.load(_quantitiesKey);
      final detailsStr = StorageHelper.load(_detailsKey);

      Map<String, int> itemQuantities = {};
      Map<String, OrderItem> itemDetails = {};

      if (quantitiesStr != null && quantitiesStr.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(quantitiesStr);
        itemQuantities = decoded.map((k, v) => MapEntry(k, v as int));
      }

      if (detailsStr != null && detailsStr.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(detailsStr);
        itemDetails = decoded.map((k, v) {
          final model = OrderItemModel.fromJson(v as Map<String, dynamic>);
          return MapEntry(k, model.toEntity());
        });
      }

      emit(state.copyWith(
        tableNumber: tableNumber,
        itemQuantities: itemQuantities,
        itemDetails: itemDetails,
        submitSuccess: false,
        errorMessage: null,
      ));
    } catch (_) {
      // If error occurs, fall back to initial state
      emit(CartState.initial());
    }
  }

  void _persistCart(CartState newState) {
    if (newState.tableNumber != null) {
      StorageHelper.save(_tableKey, newState.tableNumber!);
    } else {
      StorageHelper.remove(_tableKey);
    }

    StorageHelper.save(_quantitiesKey, jsonEncode(newState.itemQuantities));

    final detailsMap = newState.itemDetails.map(
      (k, v) => MapEntry(k, OrderItemModel.fromEntity(v).toJson()),
    );
    StorageHelper.save(_detailsKey, jsonEncode(detailsMap));
  }

  void setTableNumber(String? tableNumber) {
    final cleanTable = tableNumber?.trim();
    final table = (cleanTable == null || cleanTable.isEmpty) ? null : cleanTable;
    final newState = state.copyWith(tableNumber: table, submitSuccess: false, errorMessage: null);
    emit(newState);
    _persistCart(newState);
  }

  void addDish(Dish dish) {
    if (!dish.isAvailable) return;

    final quantities = Map<String, int>.from(state.itemQuantities);
    final details = Map<String, OrderItem>.from(state.itemDetails);

    final currentQty = quantities[dish.id] ?? 0;
    quantities[dish.id] = currentQty + 1;

    details[dish.id] = OrderItem(
      dishId: dish.id,
      name: dish.name,
      price: dish.price,
      quantity: currentQty + 1,
    );

    final newState = state.copyWith(
      itemQuantities: quantities,
      itemDetails: details,
      submitSuccess: false,
      errorMessage: null,
    );
    emit(newState);
    _persistCart(newState);
  }

  void removeDish(Dish dish) {
    final quantities = Map<String, int>.from(state.itemQuantities);
    final details = Map<String, OrderItem>.from(state.itemDetails);

    final currentQty = quantities[dish.id] ?? 0;
    if (currentQty <= 1) {
      quantities.remove(dish.id);
      details.remove(dish.id);
    } else {
      quantities[dish.id] = currentQty - 1;
      details[dish.id] = OrderItem(
        dishId: dish.id,
        name: dish.name,
        price: dish.price,
        quantity: currentQty - 1,
      );
    }

    final newState = state.copyWith(
      itemQuantities: quantities,
      itemDetails: details,
      submitSuccess: false,
      errorMessage: null,
    );
    emit(newState);
    _persistCart(newState);
  }

  void clearCart() {
    StorageHelper.remove(_tableKey);
    StorageHelper.remove(_quantitiesKey);
    StorageHelper.remove(_detailsKey);
    emit(CartState.initial());
  }

  Future<void> submitOrder() async {
    if (state.tableNumber == null || state.tableNumber!.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Please select a table number before checking out.',
        submitSuccess: false,
      ));
      return;
    }

    if (state.itemQuantities.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Your cart is empty.',
        submitSuccess: false,
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null, submitSuccess: false));

    final List<OrderItem> orderItems = [];
    double totalPrice = 0.0;

    for (final entry in state.itemQuantities.entries) {
      final dishId = entry.key;
      final quantity = entry.value;
      final details = state.itemDetails[dishId];

      if (details != null) {
        final orderItem = OrderItem(
          dishId: dishId,
          name: details.name,
          price: details.price,
          quantity: quantity,
        );
        orderItems.add(orderItem);
        totalPrice += details.price * quantity;
      }
    }

    final order = Order(
      id: '',
      tableNumber: state.tableNumber!,
      items: orderItems,
      totalPrice: totalPrice,
      status: 'pending',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    final result = await _submitOrderUseCase(order);

    if (result.isSuccess) {
      clearCart();
      emit(state.copyWith(
        isSubmitting: false,
        submitSuccess: true,
      ));
    } else {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: result.message,
      ));
    }
  }

  void resetStatus() {
    emit(state.copyWith(
      submitSuccess: false,
      errorMessage: null,
    ));
  }
}
