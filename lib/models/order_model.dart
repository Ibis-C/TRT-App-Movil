import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trt/models/models.dart';

class OrderModel {
  final String? customerName;
  final OrderTypeModel orderType;
  final List<PlateModel> plates;
  Timestamp register = Timestamp.now();
  String estado = 'pendiente';
  String? id;

  OrderModel(this.customerName, this.orderType, this.plates);
  OrderModel.firebase(this.customerName, this.orderType, this.plates,
      this.register, this.estado, this.id);

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return OrderModel.firebase(
        data['customerName'],
        OrderTypeModel.fromMap(data['orderType']),
        (data['plates'] as List)
            .map((plate) => PlateModel.fromMap(plate))
            .toList(),
        data['register'],
        data['estado'],
        data['id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'orderType': orderType.toMap(),
      'plates': plates.map((plate) => plate.toMap()).toList(),
      'register': register,
      'estado': estado,
      'id': id
    };
  }
}
