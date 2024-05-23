class ProductModel {
  String? idFirestore;
  final String name;
  final int price;
  final String type;

  ProductModel(this.name, this.price, this.type);
  ProductModel.firestore(this.idFirestore, this.name, this.price, this.type);

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      data['name'],
      data['price'],
      data['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'type': type,
    };
  }
}
