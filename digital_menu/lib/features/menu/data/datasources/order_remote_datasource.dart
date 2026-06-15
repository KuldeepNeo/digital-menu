import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/constants.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> submitOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSourceImpl(this._firestore);

  CollectionReference<OrderModel> get _ordersRef => _firestore
      .collection(FirestoreCollections.orders)
      .withConverter<OrderModel>(
        fromFirestore: (snapshot, _) => OrderModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  @override
  Future<void> submitOrder(OrderModel order) async {
    await _ordersRef.add(order);
  }
}
