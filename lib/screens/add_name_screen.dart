import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({super.key});

  @override
  State<AddNameScreen> createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacingBetweenElements = size.height * 0.03;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo Producto'),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Nombre',
                      ),
                    ),
                    SizedBox(
                      height: spacingBetweenElements,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Precio',
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: spacingBetweenElements,
            ),
            ElevatedButton(
              onPressed: () async {
                await addProduct(
                  nameController.text,
                  double.parse(priceController.text),
                ).then((_) {
                  Navigator.pop(context);
                });
              },
              child: const Text('Guardar'),
            ),
          ],
        ));
  }
}
