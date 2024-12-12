import 'package:flutter/material.dart';
import 'expense.dart'; // Asegúrate de importar la clase Expense

class ExpensesListScreen extends StatelessWidget {
   final List<Expense> expenses;

   const ExpensesListScreen({Key? key, required this.expenses}) : super(key:key);

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Lista de Gastos')),
       body: ListView.builder(
         itemCount: expenses.length,
         itemBuilder: (context, index) {
           final expense = expenses[index];
           return ListTile(
             title: Text(expense.name),
             subtitle:
                 Text('${expense.date} - \$${expense.amount.toStringAsFixed(2)} - ${expense.paymentMethod}'),
           );
         },
       ),
     );
   }
}


