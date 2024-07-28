import 'package:flutter/material.dart';
import 'package:crud_app/bd/conexion.dart';

class Product {
  final int id;
  final String nombre;
  final String description;
  final double precio;

  Product({required this.id, required this.nombre, required this.description, required this.precio});
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final Conexion conexion = Conexion();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final List<Map<String, dynamic>> productList = await conexion.obtenerProductos();
    setState(() {
      products = productList.map((product) => Product(
        id: product['id'],
        nombre: product['nombre'],
        description: product['description'],
        precio: product['precio'],
      )).toList();
    });
  }

  void addProduct() async {
    final String nombre = nombreController.text;
    final String description = descriptionController.text;
    final double precio = double.parse(precioController.text);

    if (nombre.isEmpty || description.isEmpty || precio == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, llene todos los campos'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      await conexion.nuevoProducto(nombre, description, precio);
      nombreController.clear();
      descriptionController.clear();
      precioController.clear();
      fetchProducts();
      Navigator.of(context).pop();
    }
  }

  void editProduct(Product product) async {
    nombreController.text = product.nombre;
    descriptionController.text = product.description;
    precioController.text = product.precio.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final String nombre = nombreController.text;
                final String description = descriptionController.text;
                final double precio = double.parse(precioController.text);

                if (nombre.isEmpty || description.isEmpty || precio == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Por favor, llene todos los campos'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  await conexion.actualizarProducto(product.id, nombre, description, precio);
                  nombreController.clear();
                  descriptionController.clear();
                  precioController.clear();
                  fetchProducts();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(int id) async {
    await conexion.eliminarProducto(id);
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Nuevo Producto'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: nombreController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(labelText: 'Descripción'),
                        ),
                        TextField(
                          controller: precioController,
                          decoration: const InputDecoration(labelText: 'Precio'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: addProduct,
                        child: const Text('Guardar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.nombre),
            subtitle: Text(product.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editProduct(product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteProduct(product.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}