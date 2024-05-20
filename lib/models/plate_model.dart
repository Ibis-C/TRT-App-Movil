import 'package:trt/models/models.dart';

class PlateModel {
  final int plateNumber;
  List<ProductOrderModel> productsOrdered = [
    ProductOrderModel(null),
  ];

  PlateModel(this.plateNumber);

  void addProduct(ProductOrderModel product) {
    productsOrdered.add(product);
  }

  void deleteProduct(int index) {
    productsOrdered.removeAt(index);
  }
}
