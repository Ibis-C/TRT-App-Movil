import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
const String collectionName = 'productos';

// Traer toda la información de la coleccion products
Future<List> getProducts() async {
  List products = [];
  CollectionReference collectionReferencePeople = db.collection(collectionName);

  // Si son pocos registros usar este registro, si son muchos hacer un Query diferente, ya que tardaría demasiado en traer todos los datos
  QuerySnapshot queryPeople = await collectionReferencePeople.get();

  for (var document in queryPeople.docs) {
    products.add(document.data());
  }

  /*  for (var product in products) {
    print(product);
  } */

  return products;
}

const fieldNombre = 'nombre';
const fieldPrecio = 'precio';

// Guardar un name en la firebase
Future<void> addProduct(String name, double price) async {
  await db
      .collection(collectionName)
      .add({fieldNombre: name, fieldPrecio: price});
}
