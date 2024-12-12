import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _primerApellidoController = TextEditingController();
  final _segundoApellidoController = TextEditingController();

  bool _isLogin = true; // Alternar entre login y registro
  bool _isLoading = false; // Estado de carga

  // Método para iniciar sesión
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final dbHelper = DatabaseHelper();
      final user = await dbHelper.getUserByEmail(email);
      if (user != null && user['password'] == password) {
        // Login exitoso
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: email, userId: user['id_usuario'])),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Credenciales incorrectas')),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $error')),
      );
    }
  }

  // Método para registrar al usuario y sus datos adicionales
  void _register() async {
    setState(() {
      _isLoading = true;
    });

    String email = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String nombre = _nombreController.text.trim();
    String primerApellido = _primerApellidoController.text.trim();
    String segundoApellido = _segundoApellidoController.text.trim();

    if (email.isEmpty || password.isEmpty || nombre.isEmpty || primerApellido.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos obligatorios')),
      );
      return;
    }

    try {
      final dbHelper = DatabaseHelper();
      final userExists = await dbHelper.getUserByEmail(email);
      
      if (userExists != null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo electrónico ya está registrado')),
        );
        return;
      }

      // Insertar nuevo usuario en la base de datos local
      await dbHelper.insertUser({
        'email': email,
        'password': password,
        'nombre': nombre,
        'primer_apellido': primerApellido,
        'segundo_apellido': segundoApellido,
      });

      setState(() { 
         _isLoading = false; 
         _isLogin = true; 
       });

       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Registro exitoso, ahora puedes iniciar sesión')),
       );

     } catch (error) {
       setState(() { 
         _isLoading = false; 
       });
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error inesperado: $error')),
       );
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: const Color(0xFF376C5C),
       appBar: AppBar(
         backgroundColor: const Color(0xFF376C5C),
         title: Text(_isLogin ? 'Iniciar Sesión' : 'Registro'),
       ),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Image.asset('assets/images/logo.png', height: 100),
               const SizedBox(height: 30),
               Text(
                 _isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                 style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 30),
               TextField(
                 controller: _usernameController,
                 decoration: InputDecoration(
                   labelText: 'Correo electrónico',
                   labelStyle: const TextStyle(color: Colors.black),
                   filled: true,
                   fillColor: Colors.white,
                   border:
                       OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide:
                       const BorderSide(color: Colors.grey)),
                   enabledBorder:
                       OutlineInputBorder(borderRadius:
                       BorderRadius.circular(12.0), borderSide:
                       const BorderSide(color:
                       Colors.grey)),
                   focusedBorder:
                       OutlineInputBorder(borderRadius:
                       BorderRadius.circular(12.0), borderSide:
                       const BorderSide(color:
                       Color(0xFF376C5C))),
                   prefixIcon:
                       const Icon(Icons.person, color:
                       Colors.black),
                 ),
                 style:
                     const TextStyle(color:
                     Colors.black),
               ),
               const SizedBox(height:
               20),
               TextField(
                 controller:
                 _passwordController,
                 obscureText:
                 true,
                 decoration:
                 InputDecoration(labelText:
                 'Contraseña', labelStyle:
                 const TextStyle(color:
                 Colors.black), filled:
                 true, fillColor:
                 Colors.white, border:
                 OutlineInputBorder(borderRadius:
                 BorderRadius.circular(12.0), borderSide:
                 const BorderSide(color:
                 Colors.grey),), enabledBorder:
                 OutlineInputBorder(borderRadius:
                 BorderRadius.circular(12.0), borderSide:
                 const BorderSide(color:
                 Colors.grey),), focusedBorder:
                 OutlineInputBorder(borderRadius:
                 BorderRadius.circular(12.0), borderSide:
                 const BorderSide(color:
                 Color(0xFF376C5C)),), prefixIcon:
                 const Icon(Icons.lock, color:
                 Colors.black),), style:
                     const TextStyle(color:
                     Colors.black),), 
              const SizedBox(height:
              20), 
              if (!_isLogin) ...[
                TextField(controller:_nombreController,decoration:
                const InputDecoration(labelText:'Nombre'),),
                TextField(controller:_primerApellidoController,decoration:
                const InputDecoration(labelText:'Primer Apellido'),),
                TextField(controller:_segundoApellidoController,decoration:
                const InputDecoration(labelText:'Segundo Apellido (opcional)'),),
              ],
              const SizedBox(height :20),
              // Botón para iniciar sesión o registrarse
              _isLoading ? 
                const Center(child : CircularProgressIndicator()) : 
                ElevatedButton(
                  onPressed:_isLogin ?_login :_register,
                  style : ElevatedButton.styleFrom(
                    padding :const EdgeInsets.symmetric(vertical :15),
                    backgroundColor :Colors.white,
                    textStyle :const TextStyle(color :Colors.black), 
                    shape :RoundedRectangleBorder(borderRadius :BorderRadius.circular(12.0),), 
                  ), 
                  child :Text(_isLogin ?'Iniciar Sesión' :'Registrar'), 
                ),
              // Enlace para recuperación de contraseña
              TextButton(
                onPressed :() { 
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content :Text('Recuperación de contraseña'))); 
                },
                child :const Text('¿Olvidaste tu contraseña?', style :TextStyle(color :Colors.white),), 
              ),
              const SizedBox(height :20), 
              // Enlace para cambiar entre iniciar sesión y registro
              TextButton(
                onPressed :() { 
                  setState(() { 
                    _isLogin = !_isLogin; 
                  }); 
                },
                child :Text(_isLogin ?'¿No tienes cuenta? Regístrate' :'¿Ya tienes cuenta? Inicia sesión', style :const TextStyle(color :Colors.white),), 
              ), 
            ], 
          ), 
         ), 
       ), 
     ); 
   } 
}
