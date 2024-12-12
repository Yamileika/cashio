import 'package:flutter/material.dart';
import 'add_expense_screen.dart'; 
import 'add_income_screen.dart'; 
import 'expenses_list_screen.dart'; 
import 'income_list_screen.dart'; 
import 'expense.dart'; 
import 'income.dart'; 

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId; 

  const HomeScreen({super.key, required this.username, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Inicio es el índice predeterminado

  List<Expense> _expenses = []; // Lista de gastos
  List<Income> _incomes = []; // Lista de ingresos

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) { // Gastos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpensesListScreen(expenses: _expenses)),
      );
    } else if (index == 1) { // Ingresos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IncomeListScreen(incomes: _incomes)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Simulación de gastos iniciales
    // Puedes dejarlo vacío o agregar algunos ejemplos si lo deseas
    // _expenses.add(...);
    
    // Simulación de ingresos iniciales
    // Puedes dejarlo vacío o agregar algunos ejemplos si lo deseas
    // _incomes.add(...);
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (total, expense) => total + expense.amount);
  }

  double getTotalIncomes() { 
    return _incomes.fold(0.0, (total, income) => total + income.amount); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${widget.username}'),
        backgroundColor: const Color(0xFF376C5C),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total de Gastos: \$${getTotalExpenses().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height :20),
            Text(
              'Total de Ingresos:\$${getTotalIncomes().toStringAsFixed(2)}',
              style :const TextStyle(fontSize :24),
            ),
            const SizedBox(height :20),
            ElevatedButton(
              onPressed : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context)=> AddExpenseScreen(userId :widget.userId)), 
                ).then((newExpense) {
                  if (newExpense != null) {
                    setState(() {
                      _expenses.add(newExpense); // Agregar el nuevo gasto a la lista
                    });
                  }
                });
              },
              child :const Text('Agregar Gasto'),
            ),
            const SizedBox(height :20),
            ElevatedButton(
              onPressed : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context)=> AddIncomeScreen(userId :widget.userId)), 
                ).then((newIncome) {
                  if (newIncome != null) {
                    setState(() {
                      _incomes.add(newIncome); // Agregar el nuevo ingreso a la lista
                    });
                  }
                });
              },
              child :const Text('Agregar Ingreso'),
            ),
          ],
        ),
      ),
      bottomNavigationBar : BottomNavigationBar(
        backgroundColor :const Color(0xFF376C5C),
        items :const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon :Icon(Icons.money), label:'Gastos'),
          BottomNavigationBarItem(icon :Icon(Icons.attach_money), label:'Ingresos'),
          BottomNavigationBarItem(icon :Icon(Icons.home), label:'Inicio'),
          BottomNavigationBarItem(icon :Icon(Icons.account_circle), label:'Perfil'),
        ],
        currentIndex :_selectedIndex,
        selectedItemColor :Color(0xFF376C5C),
        unselectedItemColor :Color(0xFF376C5C),
        onTap :_onItemTapped,
      ),
    );
  }
}
