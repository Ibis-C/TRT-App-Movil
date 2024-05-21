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
}
