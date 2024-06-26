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

  ProductOrderModel.all(this.amount, this.selectedProduct, this.comment);

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

  factory ProductOrderModel.fromMap(Map<String, dynamic> data) {
    if (data['selectedProduct'] != null) {
      return ProductOrderModel.all(
        data['amount'],
        ProductModel.fromMap(data['selectedProduct']),
        data['comment'],
      );
    } else {
      return ProductOrderModel.all(0, null, '');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'selectedProduct': selectedProduct?.toMap(),
      'comment': comment,
    };
  }
}
