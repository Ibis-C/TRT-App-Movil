import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trt/models/models.dart';

class TakeOrdersScreen extends StatefulWidget {
  const TakeOrdersScreen({super.key});

  @override
  State<TakeOrdersScreen> createState() => _TakeOrdersScreenState();
}

class _TakeOrdersScreenState extends State<TakeOrdersScreen> {
  List<OrderTypeModel> orderTypeOptions = [
    OrderTypeModel('esperando', 'Esperando'),
    OrderTypeModel('mesa1', 'Mesa 1'),
    OrderTypeModel('domicilio', 'A domicilio'),
    OrderTypeModel('mesa2', 'Mesa 2'),
    OrderTypeModel('recoger', 'Recoger'),
    OrderTypeModel('mesa3', 'Mesa 3'),
  ];

  List<ProductTypeModel> filters = [
    ProductTypeModel('maiz', 'M'),
    ProductTypeModel('harina', 'H'),
    ProductTypeModel('telera', 'T'),
    ProductTypeModel('nachos', 'N'),
    ProductTypeModel('bebida', 'B'),
    ProductTypeModel('kilo', 'K'),
  ];

  List<ProductModel> products = [
    ProductModel('Taco de maíz', 16, 'maiz'),
    ProductModel('Taco de maíz C/Q', 19, 'maiz'),
    ProductModel('Taco de harina', 20, 'harina'),
    ProductModel('Sincronizada', 35, 'harina'),
    ProductModel('Torta sencilla', 35, 'telera'),
    ProductModel('Mollete rey', 38, 'telera'),
    ProductModel('Nachos pequeños', 80, 'nachos'),
    ProductModel('Nachos grandes', 120, 'nachos'),
    ProductModel('Agua de jamaica', 18, 'bebida'),
    ProductModel('Coca cola', 20, 'bebida')
  ];

  List<PlateModel> order = [PlateModel(1)];

  OrderTypeModel? selectedOptionOrderType;
  ProductTypeModel? selectedOptionProductType;

  final _customerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerTextFieldWidth = size.width * 0.9;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB3E03),
        title: const Center(
          child: Text(
            'ORDENAR',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
        child: Column(
          children: [
            // SELECCION DE TIPO DE ORDEN
            SizedBox(
              height: size.height * 0.16,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 5,
                children: orderTypeOptions.map((option) {
                  return ListTile(
                    title: Text(
                      option.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Radio<OrderTypeModel>(
                      activeColor: Colors.white,
                      value: option,
                      groupValue: selectedOptionOrderType,
                      onChanged: (OrderTypeModel? value) {
                        setState(() {
                          selectedOptionOrderType = value;
                          print(
                              'TIPO DE ORDEN: ${selectedOptionOrderType?.name}');
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // INPUT NOMBRE DEL CLIENTE
            Container(
              width: containerTextFieldWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0)),
              child: TextField(
                controller: _customerNameController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: 'Nombre del cliente',
                  labelStyle: TextStyle(
                    color: Color(0xFFBEBCBC),
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0),
                ),
                onChanged: (value) {},
              ),
            ),
            // Hacer el .map.toList
            filterMenuOptions(),
            selectMenuItem(order[0].plateNumber, size)
          ],
        ),
      ),
    );
  }

  Widget filterMenuOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((productTypeModelOption) {
          return Container(
            padding: const EdgeInsets.only(right: 7.0), // Ajuste de padding
            child: Row(
              children: [
                Radio<ProductTypeModel>(
                  activeColor: Colors.white,
                  value: productTypeModelOption,
                  groupValue: selectedOptionProductType,
                  onChanged: (ProductTypeModel? value) {
                    setState(() {
                      selectedOptionProductType = value;
                      print('TIPO DE FILTRO: ${selectedOptionProductType?.id}');
                    });
                  },
                ),
                Text(
                  productTypeModelOption.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ), // Sin SizedBox
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget selectMenuItem(int plateNumber, Size size) {
    int pN = plateNumber - 1;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // TITULO PLATO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Plato ${order.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            // CANTIDAD Y SELECCION DE PRODUCTO
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // BOTON DE RESTAR
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              order[pN].productsOrdered[index].decrement();
                              print(order[pN]
                                  .productsOrdered[index]
                                  .amountController
                                  .text);
                              if (order[pN].productsOrdered[index].amount ==
                                      0 &&
                                  order[pN].productsOrdered.length > 1) {
                                print('SOY EL INDICE $index');
                                order[pN].deleteProduct(index);
                                order[pN]
                                    .productsOrdered[
                                        order[pN].productsOrdered.length - 1]
                                    .lastOne = true;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),

                        // INPUT DE CANTIDAD DE PRODUCTO
                        Container(
                          width: size.width * 0.12,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            controller: order[pN]
                                .productsOrdered[index]
                                .amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              setState(() {
                                order[pN].productsOrdered[index].setAmount(
                                    int.tryParse(order[pN]
                                            .productsOrdered[index]
                                            .amountController
                                            .text) ??
                                        1);
                              });
                            },
                          ),
                        ),

                        // BOTON DE SUMAR
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              order[pN].productsOrdered[index].increment();
                              print(order[pN]
                                  .productsOrdered[index]
                                  .amountController
                                  .text);
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),

                        // INPUT DE SELECCION DEL PRODUCTO
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButton<ProductModel>(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 5),
                                  isExpanded: true,
                                  value: order[pN]
                                      .productsOrdered[index]
                                      .selectedProduct,
                                  hint: const Text('Selecciona un producto'),
                                  items: products.map((ProductModel product) {
                                    return DropdownMenuItem<ProductModel>(
                                      value: product,
                                      child: Text(
                                        product.name,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (ProductModel? newProduct) {
                                    setState(() {
                                      order[pN]
                                          .productsOrdered[index]
                                          .selectedProduct = newProduct;
                                      print(
                                          '    <<Index>> $index\n    <<Cantidad>> ${order[pN].productsOrdered[index].amount}\n    <<Producto>> ${order[pN].productsOrdered[index].getSelectedProduct()}');

                                      if (order[pN]
                                              .productsOrdered[index]
                                              .lastOne ==
                                          true) {
                                        if (order[pN]
                                                .productsOrdered[index]
                                                .amount ==
                                            0) {
                                          order[pN]
                                              .productsOrdered[index]
                                              .increment();
                                        }
                                        order[pN].addProduct(
                                            ProductOrderModel(null));

                                        order[pN]
                                            .productsOrdered[index]
                                            .lastOne = false;
                                      }
                                      /* print(
                                          '    <<Index>> ${index + 1}\n    <<Cantidad>> ${order[pN].productsOrdered[index + 1].amount}\n    <<Producto>> ${order[pN].productsOrdered[index + 1].getSelectedProduct()}'); */
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (order[pN].productsOrdered[index].selectedProduct !=
                        null)
                      Container(
                        width: size.width * 0.98,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: TextField(
                          controller: order[pN]
                              .productsOrdered[index]
                              .commentController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Detalles producto ${index + 1}',
                            labelStyle: const TextStyle(
                              color: Color(0xFFBEBCBC),
                              fontWeight: FontWeight.w700,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12.0),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                  ],
                ),
              ),
              // Cantidad de productos seleccionados en un plato
              itemCount: order[pN].productsOrdered.length,
            )
          ],
        ),
      ),
    );
  }
}
