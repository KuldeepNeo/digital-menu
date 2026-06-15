import '../../../../core/network/cloud_result.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class SubmitOrderUseCase {
  final OrderRepository _repository;

  SubmitOrderUseCase(this._repository);

  Future<CloudResult<void>> call(Order order) {
    return _repository.submitOrder(order);
  }
}
