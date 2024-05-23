import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trt/models/models.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<OrderModel> pedidos = [
    OrderModel(
      'Edwin',
      OrderTypeModel('domicilio', 'A domicilio'),
      <PlateModel>[
        PlateModel(
          1,
          <ProductOrderModel>[
            ProductOrderModel.all(
              2,
              ProductModel('Torta sencilla', 35, 'telera'),
              '1 sin salsa roja',
            ),
            ProductOrderModel.all(
              3,
              ProductModel('Taco de maíz', 16, 'maiz'),
              '',
            )
          ],
        ),
      ],
    ),
    OrderModel(
      'Ibis',
      OrderTypeModel('mesa1', 'Mesa 1'),
      <PlateModel>[
        PlateModel(
          1,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Sincronizada', 35, 'harina'),
              'S/C',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Agua de jamaica', 18, 'bebida'),
              '',
            ),
          ],
        ),
        PlateModel(
          2,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Nachos grandes', 120, 'nachos'),
              'A/E',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Coca cola', 20, 'bebida'),
              '',
            ),
          ],
        )
      ],
    ),
    OrderModel(
      'Jose',
      OrderTypeModel('mesa1', 'Mesa 1'),
      <PlateModel>[
        PlateModel(
          1,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Sincronizada', 35, 'harina'),
              'S/C',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Agua de jamaica', 18, 'bebida'),
              '',
            ),
          ],
        ),
        PlateModel(
          2,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Nachos grandes', 120, 'nachos'),
              'A/E',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Coca cola', 20, 'bebida'),
              '',
            ),
          ],
        )
      ],
    ),
    OrderModel(
      'Mike',
      OrderTypeModel('mesa1', 'Mesa 1'),
      <PlateModel>[
        PlateModel(
          1,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Sincronizada', 35, 'harina'),
              'S/C',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Agua de jamaica', 18, 'bebida'),
              '',
            ),
          ],
        ),
        PlateModel(
          2,
          <ProductOrderModel>[
            ProductOrderModel.all(
              1,
              ProductModel('Nachos grandes', 120, 'nachos'),
              'A/E',
            ),
            ProductOrderModel.all(
              1,
              ProductModel('Coca cola', 20, 'bebida'),
              '',
            ),
          ],
        )
      ],
    )
  ];

  Widget orderCard(OrderModel order) {
    double textSize = 20;
    int totalPrice;
    (order.orderType.id == 'domicilio') ? totalPrice = 15 : totalPrice = 0;
    return SizedBox(
      width: double.infinity,
      child: Dismissible(
        key: Key('${order.customerName}'),
        direction: (order.estado == 'pendiente')
            ? DismissDirection.startToEnd
            : DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            order.changeEstado();
          });
        },
        background: Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          color: Colors.red.shade900,
          alignment: (order.estado == 'pendiente')
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
          ),
        ),
        child: Card(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          color: const Color(0xFFFE7C01),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.customerName} [ ${order.orderType.name} ]',
                  style: TextStyle(fontSize: textSize),
                ),
                Column(
                  children: order.plates
                      .map((plate) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plato ${plate.plateNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: textSize,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: plate.productsOrdered.map((product) {
                                  // Ir sumando los precios de los productos
                                  totalPrice = totalPrice +
                                      (product.amount *
                                          (product.selectedProduct?.price ??
                                              0));
                                  return Column(
                                    children: [
                                      if (product.comment == '' ||
                                          product.comment == null)
                                        Text(
                                          '    + ${product.amount} ${product.selectedProduct?.name}',
                                          style: TextStyle(
                                            fontSize: textSize,
                                          ),
                                        )
                                      else
                                        Text(
                                          '    + ${product.amount} ${product.selectedProduct?.name} [ ${product.comment} ]',
                                          style: TextStyle(
                                            fontSize: textSize,
                                          ),
                                        )
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '\$$totalPrice',
                    style: TextStyle(
                      fontSize: textSize,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String estado) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('estado', isEqualTo: estado)
          .orderBy('register', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se carga la información.
        }
        if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Muestra un mensaje de error si ocurre algún problema.
        }
        final orders = snapshot.data?.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return OrderModel.firebase(
                data['customerName'],
                OrderTypeModel.fromMap(data['orderType']),
                (data['plates'] as List)
                    .map((plate) => PlateModel.fromMap(plate))
                    .toList(),
                data['register'],
                data['estado'],
              );
            }).toList() ??
            [];
        return SingleChildScrollView(
          child: Column(
            children: orders.map((order) => orderCard(order)).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'takeOrders');
            },
            backgroundColor: Colors.white.withOpacity(0.3),
            foregroundColor: Colors.transparent.withOpacity(0.1),
            elevation: 0,
            child: const Icon(
              Icons.add_rounded,
              size: 50,
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFFB3E03),
            bottom: const TabBar(indicatorColor: Colors.black, tabs: [
              Tab(
                child: Text(
                  'PENDIENTES',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'LISTOS',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ]),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFB3E03),
              image: DecorationImage(
                image: AssetImage('assets/fondo-tacos.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(children: [
              _buildOrderList(context, 'pendiente'),
              _buildOrderList(context, 'listo')
            ]),
          )),
    );
  }
}
