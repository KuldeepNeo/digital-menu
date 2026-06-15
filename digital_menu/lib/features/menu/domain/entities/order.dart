import 'order_item.dart';

class Order {
  final String id;
  final String tableNumber;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final int createdAt;

  const Order({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });
}
