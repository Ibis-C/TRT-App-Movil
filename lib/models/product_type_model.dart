class ProductTypeModel {
  String? idFirestore;
  final String? id;
  final String? name;

  ProductTypeModel(this.id, this.name);
  ProductTypeModel.firestore(this.idFirestore, this.id, this.name);
}
