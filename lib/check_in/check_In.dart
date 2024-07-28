import 'package:flutter/material.dart';
import 'package:crud_app/bd/conexion.dart';

class Check_In extends StatefulWidget {
  const Check_In({super.key});
  @override
  _Check_InState createState() => _Check_InState();
}

class _Check_InState extends State<Check_In> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController last_nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Conexion conexion = Conexion();

  void nuevoRegistro() async {
    final String name = nameController.text;
    final String last_name = last_nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    if (name.isEmpty || last_name.isEmpty || email.isEmpty || password.isEmpty) {
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
      await conexion.nuevoRegistro(name, last_name, email, password);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registro'),
            content: const Text('Usuario registrado con éxito'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  nameController.clear();
                  last_nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: last_nameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: nuevoRegistro,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}