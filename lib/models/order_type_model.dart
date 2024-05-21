class OrderTypeModel {
  String? idFirestore;
  final String id;
  final String name;

  OrderTypeModel(this.id, this.name);

  OrderTypeModel.firestore(this.idFirestore, this.id, this.name);

  factory OrderTypeModel.fromMap(Map<String, dynamic> data) {
    return OrderTypeModel(
      data['id'],
      data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
