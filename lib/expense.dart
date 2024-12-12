// lib/expense.dart
class Expense {
  final String name;
  final String date;
  final double amount;
  final String paymentMethod;
  final String description;
  final int userId;
  final int categoryId;

  Expense({
    required this.name,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    required this.description,
    required this.userId,
    required this.categoryId,
  });
}
