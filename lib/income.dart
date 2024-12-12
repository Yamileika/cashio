// lib/income.dart
class Income {
  final String name;
  final String date;
  final double amount;
  final String paymentMethod;
  final String description;
  final int userId;
  final int categoryId;

  Income({
    required this.name,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    required this.description,
    required this.userId,
    required this.categoryId,
  });
}
