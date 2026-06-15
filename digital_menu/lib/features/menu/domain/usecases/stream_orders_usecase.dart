import '../entities/order.dart';
import '../repositories/order_repository.dart';

class StreamOrdersUseCase {
  final OrderRepository _repository;

  StreamOrdersUseCase(this._repository);

  Stream<List<Order>> call() {
    return _repository.streamActiveOrders();
  }
}
