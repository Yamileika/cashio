import 'package:flutter/material.dart';
import 'income.dart'; // Asegúrate de importar la clase Income

class IncomeListScreen extends StatelessWidget {
   final List<Income> incomes;

   const IncomeListScreen({Key? key, required this.incomes}) : super(key:key);

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Lista de Ingresos')),
       body: ListView.builder(
         itemCount: incomes.length,
         itemBuilder: (context, index) {
           final income = incomes[index];
           return ListTile(
             title: Text(income.name),
             subtitle:
                 Text('${income.date} - \$${income.amount.toStringAsFixed(2)} - ${income.paymentMethod}'),
           );
         },
       ),
     );
   }
}
