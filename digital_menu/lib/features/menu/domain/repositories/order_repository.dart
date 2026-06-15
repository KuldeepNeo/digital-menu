import '../../../../core/network/cloud_result.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<CloudResult<void>> submitOrder(Order order);
}
