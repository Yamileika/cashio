import 'package:flutter/material.dart';
import 'expense.dart'; 
import 'expenses_list_screen.dart'; 

class AddExpenseScreen extends StatefulWidget {
  final int userId; // Recibe el ID del usuario

  const AddExpenseScreen({Key? key, required this.userId}) : super(key:key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  // Variables para manejar las categorías
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId; // Almacena el ID de la categoría seleccionada

   @override
   void initState() {
     super.initState();
     // Simulación de categorías iniciales
     _categories = [
       {'id_categoria': 1, 'nombre': 'Alimentación'},
       {'id_categoria': 2, 'nombre': 'Transporte'},
       {'id_categoria': 3, 'nombre': 'Salario'},
       {'id_categoria': 4, 'nombre': 'Ahorros'},
     ];
   }

   void _addExpense() async {
     setState(() {
       _isLoading = true;
     });

     String name = _nameController.text.trim();
     String date = _dateController.text.trim();
     double amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
     String paymentMethod = _paymentMethodController.text.trim();

     if (name.isEmpty || date.isEmpty || amount <= 0 || paymentMethod.isEmpty || _selectedCategoryId == null) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Por favor completa todos los campos')),
       );
       setState(() {
         _isLoading = false;
       });
       return;
     }

     try {
       // Crear un nuevo gasto y agregarlo a la lista
       Expense newExpense = Expense(
         name: name,
         date: date,
         amount: amount,
         paymentMethod: paymentMethod,
         description: _descriptionController.text.trim(),
         userId: widget.userId, // Usar el ID del usuario pasado.
         categoryId: _selectedCategoryId!, // Usar la categoría seleccionada.
       );

       Navigator.pop(context, newExpense); // Regresar a la pantalla anterior y pasar el nuevo gasto.
       
     } catch (error) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error inesperado: $error')),
       );
     } finally {
       setState(() {
         _isLoading = false;
       });
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Agregar Gasto')),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child:
         SingleChildScrollView(child:
           Column(children:[
             TextField(controller:_nameController,decoration:
             const InputDecoration(labelText:'Nombre del Gasto'),),
             TextField(controller:_dateController,decoration:
             const InputDecoration(labelText:'Fecha (YYYY-MM-DD)'),),
             TextField(controller:_amountController,decoration:
             const InputDecoration(labelText:'Monto'),keyboardType:
             TextInputType.number,),
             DropdownButton<int>(
               hint:
               const Text('Selecciona una categoría'),
               value:_selectedCategoryId,
               onChanged:(int? newValue){
                 setState((){_selectedCategoryId=newValue;});
               },
               items:_categories.map<DropdownMenuItem<int>>((Map<String,dynamic>category){
                 return DropdownMenuItem<int>(
                   value:
                   category['id_categoria'],
                   child:
                   Text(category['nombre']),
                 );
               }).toList(),
             ),
             TextField(controller:_paymentMethodController,
               decoration:
               const InputDecoration(labelText:'Método de Pago'),),
             TextField(controller:_descriptionController,
               decoration:
               const InputDecoration(labelText:'Descripción'),),
             const SizedBox(height:20),
             _isLoading?
             const CircularProgressIndicator():
             ElevatedButton(onPressed:_addExpense,
               child:
               const Text('Agregar Gasto'),),],)),),);}}
