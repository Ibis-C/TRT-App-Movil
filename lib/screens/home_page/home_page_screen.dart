import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // Cambio en tiempo real cuando hay alguna modificación en la base de datos en la colección 'productos'
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('productos').snapshots();

  @override
  Widget build(BuildContext context) {
    const fieldNombre = 'nombre';
    const fieldPrecio = 'precio';

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Esperar hasta obtener los datos. Sin esto da error.
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // snapshot contiene los datos
          final documents = snapshot.data!.docs;

          return ListView.separated(
            itemBuilder: (context, index) {
              final product = documents[index];
              return ListTile(
                title: Text(
                    "${product[fieldNombre]} \$${product[fieldPrecio].toString()}"),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: documents.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, 'addName');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
