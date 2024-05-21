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

  // Seleccion de filtro en cada uno de los productos del plato
  List<ProductModel?> listProductModelSelected = [
    null,
  ];

  List<ProductTypeModel> listOfFiltersPerElementOnAPlate = [
    ProductTypeModel(null, null),
  ];

  List<List<ProductModel>> listOfFilteredlists = [
    [],
  ];

  List<PlateModel> order = [
    // Una orden tiene un plato, cada plato tiene un número y cada plato tiene una lista de productos y a cada producto se le pasa los datos del producto
    PlateModel(0, [ProductOrderModel(null, 0)])
  ];

  // TIPO DE ORDEN
  OrderTypeModel? selectedOptionOrderType;

  final _customerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerTextFieldWidth = size.width * 0.9;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            order.add(PlateModel(order.length, [
              ProductOrderModel(null, listProductModelSelected.length - 1)
            ]));
            print('TAMAÑO DE LA LISTA ORDER = ${order.length}');
            for (var i = 0; i < order.length; i++) {
              print('PLATO[$i] = ${order[i].plateNumber}');
            }
          });
        },
        backgroundColor: Colors.black.withOpacity(0.2),
        foregroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB3E03),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_rounded)),
        title: const Center(
          child: Text(
            'ORDENAR',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save_rounded),
            color: Colors.black,
          )
        ],
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
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return selectMenuItem(index, size);
                },
                itemCount: order.length,
              ),
            )
            /* selectMenuItem(order[0].plateNumber, size, order) */
          ],
        ),
      ),
    );
  }

  Widget selectMenuItem(int plateNumber, Size size) {
    return Column(
      children: [
        // TITULO PLATO
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
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
                'Plato ${plateNumber + 1}',
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
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
        ),

        // CANTIDAD Y SELECCION DE PRODUCTO
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            children: [
              // FILTRO DE PRODUCTOS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((productTypeModelOption) {
                    return Container(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Row(
                        children: [
                          // SELECCION DEL FILTRO
                          Radio<ProductTypeModel>(
                            activeColor: Colors.white,
                            value: productTypeModelOption,
                            groupValue:
                                // hago referencia al siguiente elemento de la lista
                                listOfFiltersPerElementOnAPlate[
                                    order[plateNumber]
                                        .productsOrdered[index]
                                        .ubication],
                            onChanged: (ProductTypeModel? value) {
                              setState(() {
                                // Asignar el filtro a la lista en la posición que le corresponde
                                listOfFiltersPerElementOnAPlate[
                                    order[plateNumber]
                                        .productsOrdered[index]
                                        .ubication] = value!;

                                /* 
                                ######### IMPORTANTISIMO ############ 
                                SIEMPRE PONER A NULL ANTES DE CREAR LA NUEVA LISTA FILTRADA, PORQUE SI NO LO PONEMOS A NULL Y ESTE VALOR SE QUEDA IGUAL, ENTONCES LA LISTA FILTRADA YA NO TENDRA ESE ELEMENTO GUARDADO Y DARÁ ERRORES. EN POCAS PALABRAS, EL VALOR GUARDADO NO ESTA EN LA NUEVA LISTA, DANDO ERROR.
                                */
                                listProductModelSelected[order[plateNumber]
                                    .productsOrdered[index]
                                    .ubication] = null;

                                print(
                                    'TIPO DE FILTRO: ${listOfFiltersPerElementOnAPlate[order[plateNumber].productsOrdered[index].ubication].id}');

                                // Genera la lista filtrada
                                listOfFilteredlists[order[plateNumber]
                                        .productsOrdered[index]
                                        .ubication] =
                                    products
                                        .where((product) =>
                                            product.type ==
                                            listOfFiltersPerElementOnAPlate[
                                                    order[plateNumber]
                                                        .productsOrdered[index]
                                                        .ubication]
                                                .id)
                                        .toList();
                              });
                            },
                          ),
                          Text(
                            productTypeModelOption.name!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ), // Sin SizedBox
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // BOTON DE RESTAR
                  IconButton(
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        // El primer elemento nunca puede ser cero, siempre debe ser 1
                        if (order[plateNumber].productsOrdered[0].amount > 1 ||
                            order[plateNumber].productsOrdered.length > 1) {
                          order[plateNumber].productsOrdered[index].decrement();
                        }
                        print(order[plateNumber]
                            .productsOrdered[index]
                            .amountController
                            .text);

                        //
                        if (order[plateNumber].productsOrdered[index].amount ==
                                0 &&
                            order[plateNumber].productsOrdered.length > 1) {
                          listProductModelSelected.removeAt(order[plateNumber]
                              .productsOrdered[index]
                              .ubication);
                          listOfFiltersPerElementOnAPlate.removeAt(
                              order[plateNumber]
                                  .productsOrdered[index]
                                  .ubication);
                          listOfFilteredlists.removeAt(order[plateNumber]
                              .productsOrdered[index]
                              .ubication);

                          /*
                          ############### IMPORTANTISIMO ###############
                          DEJAR ESTO AQUÍ, PORQUE PRIMERO DEBEMOS ELIMINAR LOS VALORES DE LAS LISTAS DE AQUÍ, ANTES DE ELIMINAR LOS PRODUCTOS DEL PLATO. YA QUE, AL ELIMINAR EL PRODUCTO TAMBIEN REDUCE EL VALOR DEL INDEX 
                          */
                          order[plateNumber].deleteProduct(index);

                          order[plateNumber]
                              .productsOrdered[
                                  order[plateNumber].productsOrdered.length - 1]
                              .lastOne = true;

                          // REASIGNAR LAS UBICACIONES DE TODOS LOS VALORES
                          int counter = 0;
                          for (var i = 0; i < order.length; i++) {
                            for (var j = 0;
                                j < order[i].productsOrdered.length;
                                j++) {
                              order[i].productsOrdered[j].ubication = counter;
                              counter++;
                            }
                          }
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
                      controller: order[plateNumber]
                          .productsOrdered[index]
                          .amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          order[plateNumber].productsOrdered[index].setAmount(
                              int.tryParse(order[plateNumber]
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
                        order[plateNumber].productsOrdered[index].increment();
                        print(order[plateNumber]
                            .productsOrdered[index]
                            .amountController
                            .text);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),

                        // INPUT DE SELECCION DEL PRODUCTO
                        child: DropdownButton<ProductModel>(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 5),
                            isExpanded: true,
                            value: listProductModelSelected[order[plateNumber]
                                .productsOrdered[index]
                                .ubication],
                            hint: const Text('Selecciona un producto'),
                            items: listOfFilteredlists[order[plateNumber]
                                    .productsOrdered[index]
                                    .ubication]
                                .map((ProductModel product) {
                              return DropdownMenuItem<ProductModel>(
                                value: product,
                                child: Text(
                                  product.name,
                                ),
                              );
                            }).toList(),
                            onChanged: (ProductModel? newProduct) {
                              setState(() {
                                // Actualiza la selección en la lista
                                listProductModelSelected[order[plateNumber]
                                    .productsOrdered[index]
                                    .ubication] = newProduct;

                                // Le pasamos la clase del producto que agregara al plato
                                order[plateNumber]
                                    .productsOrdered[index]
                                    .selectedProduct = newProduct;

                                print(
                                    '    <<Plato>> $plateNumber\n    <<Index>> $index\n    <<Cantidad>> ${order[plateNumber].productsOrdered[index].amount}\n    <<Producto>> ${order[plateNumber].productsOrdered[index].getSelectedProduct()}');

                                if (order[plateNumber]
                                        .productsOrdered[index]
                                        .lastOne ==
                                    true) {
                                  if (order[plateNumber]
                                          .productsOrdered[index]
                                          .amount ==
                                      0) {
                                    order[plateNumber]
                                        .productsOrdered[index]
                                        .increment();
                                  }

                                  // AGREAR NUEVO SELECCION DE PRODUCTO
                                  listProductModelSelected.add(null);

                                  // AGREGAR NUEVO FILTRO A LA LISTA DE FILTRO
                                  listOfFiltersPerElementOnAPlate
                                      .add(ProductTypeModel(null, null));

                                  // AGREGAR NUEVA LISTA A LA LISTA DE LISTAS FILTRADAS
                                  listOfFilteredlists.add([]);

                                  // AGREGAR NUEVO PRODUCTO AL PLATO
                                  order[plateNumber].addProduct(
                                      ProductOrderModel(null,
                                          listProductModelSelected.length - 1));

                                  order[plateNumber]
                                      .productsOrdered[index]
                                      .lastOne = false;
                                }
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
              if (order[plateNumber].productsOrdered[index].selectedProduct !=
                  null)
                Container(
                  width: size.width * 0.98,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: TextField(
                    controller: order[plateNumber]
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
          // Cantidad de productos seleccionados en un plato
          itemCount: order[plateNumber].productsOrdered.length,
        )
      ],
    );
  }
}
