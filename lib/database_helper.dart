import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'cashio.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      // Crear tabla usuarios
      db.execute('''CREATE TABLE usuarios (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        nombre TEXT NOT NULL,
        primer_apellido TEXT NOT NULL,
        segundo_apellido TEXT
      )''');

      // Crear tabla categorias
      db.execute('''CREATE TABLE categorias (
        id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        tipo TEXT NOT NULL CHECK(tipo IN ('gasto', 'ingreso', 'presupuesto'))
      )''');

      // Crear tabla gastos
      db.execute('''CREATE TABLE gastos (
        id_gasto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        fecha TEXT NOT NULL,
        monto REAL NOT NULL,
        metodo_pago TEXT NOT NULL,
        descripcion TEXT,
        id_usuario INTEGER NOT NULL,
        id_categoria INTEGER NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
      )''');

      // Crear tabla ingresos
      db.execute('''CREATE TABLE ingresos (
        id_ingreso INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        fecha TEXT NOT NULL,
        monto REAL NOT NULL,
        descripcion TEXT,
        id_usuario INTEGER NOT NULL,
        id_categoria INTEGER NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
      )''');
    });
  }

  // Métodos para manejar categorías
 // Método para insertar una nueva categoría
  Future<void> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.insert('categorias', category);
  }

  // Método para obtener todas las categorías
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categorias');
  }


  // Métodos para manejar gastos
  Future<void> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;
    await db.insert('gastos', expense);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('gastos');
  }

  // Métodos para manejar ingresos
  Future<void> insertIncome(Map<String, dynamic> income) async {
    final db = await database;
    await db.insert('ingresos', income);
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    final db = await database;
    return await db.query('ingresos');
  }
  // Método para insertar un nuevo usuario
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('usuarios', user);
  }

  // Método para buscar un usuario por correo
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

}

