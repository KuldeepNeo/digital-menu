import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_item.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String dishId,
    required String name,
    required double price,
    required int quantity,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  factory OrderItemModel.fromEntity(OrderItem entity) => OrderItemModel(
        dishId: entity.dishId,
        name: entity.name,
        price: entity.price,
        quantity: entity.quantity,
      );

  const OrderItemModel._();

  OrderItem toEntity() => OrderItem(
        dishId: dishId,
        name: name,
        price: price,
        quantity: quantity,
      );
}
