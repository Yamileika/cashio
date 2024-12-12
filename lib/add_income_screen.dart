import 'package:flutter/material.dart';
import 'income.dart'; // Importa la clase Income
import 'income_list_screen.dart'; // Importa la pantalla de lista de ingresos

class AddIncomeScreen extends StatefulWidget {
  final int userId; // Recibe el ID del usuario

  const AddIncomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  // Variables para manejar las categorías
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId; // Almacena el ID de la categoría seleccionada

  // Lista para almacenar los ingresos en memoria
  List<Income> _incomes = [];

  @override
  void initState() {
    super.initState();
    // Simulación de categorías iniciales
    _categories = [
      {'id_categoria': 1, 'nombre': 'Salario'},
      {'id_categoria': 2, 'nombre': 'Inversiones'},
      {'id_categoria': 3, 'nombre': 'Otros'},
    ];
  }

  void _addIncome() async {
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
      // Crear un nuevo ingreso y agregarlo a la lista
      Income newIncome = Income(
        name: name,
        date: date,
        amount: amount,
        paymentMethod: paymentMethod,
        description: _descriptionController.text.trim(),
        userId: widget.userId, // Usar el ID del usuario pasado.
        categoryId: _selectedCategoryId!, // Usar la categoría seleccionada.
      );

      setState(() {
        _incomes.add(newIncome); // Agregar el ingreso a la lista
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso agregado con éxito')),
      );

      Navigator.pop(context); // Regresar a la pantalla anterior.
      
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
       appBar: AppBar(title: const Text('Agregar Ingreso')),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child:
         SingleChildScrollView(child:
           Column(children:[
             TextField(controller:_nameController,decoration:
             const InputDecoration(labelText:'Nombre del Ingreso'),),
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
             ElevatedButton(onPressed:_addIncome,
               child:
               const Text('Agregar Ingreso'),),],)),),);}}
