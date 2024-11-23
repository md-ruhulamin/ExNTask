class Expense {
  final int? expenseId;
  final String category;
  final String description;
  final double amount;
  final String dateTime;
  final int color;
  final String type; // 'earning' or 'expense'

  Expense({
    this.expenseId,
    required this.category,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.color,
    required this.type, // Must be 'earning' or 'expense'
  });

  // Convert Expense to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'category': category,
      'description': description,
      'amount': amount,
      'dateTime': dateTime,
      'color': color,
      'type': type,
    };
  }

  // Factory constructor to create an Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      expenseId: map['expenseId'],
      category: map['category'],
      description: map['description'] ?? '',
      amount: map['amount'],
      dateTime: map['dateTime'],
      color: map['color'] ?? 0,
      type: map['type'], // Either 'earning' or 'expense'
    );
  }
}
