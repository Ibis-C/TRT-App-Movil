import 'package:trt/models/models.dart';

class PlateModel {
  final int plateNumber;
  List<ProductOrderModel> productsOrdered;

  PlateModel(this.plateNumber, this.productsOrdered);

  void addProduct(ProductOrderModel product) {
    productsOrdered.add(product);
  }

  void deleteProduct(int index) {
    productsOrdered.removeAt(index);
  }

  factory PlateModel.fromMap(Map<String, dynamic> data) {
    return PlateModel(
      data['plateNumber'],
      (data['productsOrdered'] as List)
          .map((product) => ProductOrderModel.fromMap(product))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plateNumber': plateNumber,
      'productsOrdered':
          productsOrdered.map((product) => product.toMap()).toList(),
    };
  }
}
