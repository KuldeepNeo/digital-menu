import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String tableNumber,
    required List<OrderItemModel> items,
    required double totalPrice,
    required String status,
    required int createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  factory OrderModel.fromEntity(Order entity) => OrderModel(
        id: entity.id,
        tableNumber: entity.tableNumber,
        items: entity.items.map((e) => OrderItemModel.fromEntity(e)).toList(),
        totalPrice: entity.totalPrice,
        status: entity.status,
        createdAt: entity.createdAt,
      );

  const OrderModel._();

  Order toEntity() => Order(
        id: id,
        tableNumber: tableNumber,
        items: items.map((e) => e.toEntity()).toList(),
        totalPrice: totalPrice,
        status: status,
        createdAt: createdAt,
      );
}
