import '../../../../core/network/cloud_result.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<CloudResult<void>> call(String orderId, String status) {
    return _repository.updateOrderStatus(orderId, status);
  }
}
