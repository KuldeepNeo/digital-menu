import '../../../../core/network/cloud_result.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<CloudResult<void>> submitOrder(Order order) async {
    try {
      final model = OrderModel.fromEntity(order);
      await _remoteDataSource.submitOrder(model);
      return const CloudResult(
        statusCode: 200,
        message: 'Order submitted successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error submitting order: $e',
      );
    }
  }

  @override
  Stream<List<Order>> streamActiveOrders() {
    return _remoteDataSource
        .streamActiveOrders()
        .map((list) => list.map((model) => model.toEntity()).toList());
  }

  @override
  Future<CloudResult<void>> updateOrderStatus(String orderId, String status) async {
    try {
      await _remoteDataSource.updateOrderStatus(orderId, status);
      return const CloudResult(
        statusCode: 200,
        message: 'Order status updated successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error updating order status: $e',
      );
    }
  }
}

