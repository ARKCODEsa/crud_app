//importar paquetes sqlite
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//creamos la clase Conexion
class Conexion {
  //creamos el metodo que nos permitira abrir la base de datos
  Future<Database> abrir() async {
    //obtenemos la ruta de la base de datos
    String ruta = join(await getDatabasesPath(), 'bd_tareas.db');
    //abrimos la base de datos
    return openDatabase(ruta, version: 1, onCreate: _crearTabla);
  }

  //creamos el metodo que nos permitira crear la tabla login y products
  Future<void> _crearTabla(Database db, int version) async {
    //creamos la tabla login
    await db.execute(
        'CREATE TABLE login (id INTEGER PRIMARY KEY, name TEXT, last_name TEXT, email TEXT, password TEXT)');
    //creamos la tabla products
    await db.execute(
        'CREATE TABLE products (id INTEGER PRIMARY KEY, nombre TEXT,description TEXT,  precio REAL)');
  }

  //creamos el metodo que nos permitira cerrar la base de datos
  Future<void> cerrar() async {
    final Database db = await abrir();
    db.close();
  }

//----------------------------------------------------------------------------------------------------------
//metodo para nuevo registro check_in de la tabla login
  Future<void> nuevoRegistro(String name, String last_name, String email,
      String password) async {
    final Database db = await abrir();
    await db.insert(
      'login',
      {
        'name': name,
        'last_name': last_name,
        'email': email,
        'password': password
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  //metodo de validacion de usuario de la tabla login
  Future<List<Map<String, dynamic>>> validarUsuario(String email, String password) async {
    final Database db = await abrir();
    return db.query('login', where: 'email = ? and password = ?', whereArgs: [email, password]);
  }


  //metodo para nuevo registro de la tabla products
  Future<void> nuevoProducto(String nombre, String description, double precio) async {
    final Database db = await abrir();
    await db.insert(
      'products',
      {
        'nombre': nombre,
        'description': description,
        'precio': precio
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //metodo para eliminar un producto de la tabla products
  Future<void> eliminarProducto(int id) async {
    final Database db = await abrir();
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //metodo para actualizar un producto de la tabla products
  Future<void> actualizarProducto(int id, String nombre, String description, double precio) async {
    final Database db = await abrir();
    await db.update(
      'products',
      {
        'nombre': nombre,
        'description': description,
        'precio': precio
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //metodo para obtener todos los productos de la tabla products
  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final Database db = await abrir();
    return db.query('products');
  }

  //metodo para obtener un producto de la tabla products
  Future<List<Map<String, dynamic>>> obtenerProducto(int id) async {
    final Database db = await abrir();
    return db.query('products', where: 'id = ?', whereArgs: [id]);
  }

}