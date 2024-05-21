import 'package:flutter/material.dart';
import 'package:trt/models/models.dart';

class ProductOrderModel {
  final TextEditingController amountController =
      TextEditingController(text: '1');
  final TextEditingController commentController = TextEditingController();
  int amount = 1;
  ProductModel? selectedProduct;
  String? comment;
  bool lastOne = true;

  ProductOrderModel(this.selectedProduct);

  void increment() {
    amount++;
    amountController.text = amount.toString();
  }

  void decrement() {
    if (amount > 0) {
      amount--;
      amountController.text = amount.toString();
    }
  }

  void setProduct(ProductModel productName) {
    selectedProduct = productName;
  }

  void setAmount(int amount) {
    this.amount = amount;
  }

  String? getSelectedProduct() {
    if (selectedProduct == null) {
      return 'No ha seleccionado un producto';
    }
    return selectedProduct?.name;
  }
}
