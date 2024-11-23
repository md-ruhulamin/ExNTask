import 'package:get/get.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/expences/expense.dart';

class ExpenseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // Observable list of expenses
  var expenses = <Expense>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllExpenses();
  }

  var totalExpense = 0.0.obs;
  var totalEarning = 0.0.obs;
  var currentBalance = 0.0.obs;

  void fetchAllExpenses() async {
    final List<Expense> allExpenses = await _dbHelper.getAllExpenses();

    expenses.assignAll(allExpenses);
    expenses.value = expenses.reversed.toList();
    calculateTotals();
  }

  void calculateTotals() {
    double expenseSum = 0.0;
    double earningSum = 0.0;

    for (var expense in expenses) {
      if (expense.type == 'Expense') {
        expenseSum += expense.amount;
      } else if (expense.type == 'Earning') {
        earningSum += expense.amount;
      }
    }

    totalExpense.value = expenseSum;
    totalEarning.value = earningSum;
    currentBalance.value =
        earningSum - expenseSum; // Balance = total earnings - total expenses
  }

  // Fetch all expenses and update the observable list
  // void fetchAllExpenses() async {
  //   final List<Expense> allExpenses = await _dbHelper.getAllExpenses();
  //   print(allExpenses.length);
  //   print(allExpenses[0].category);
  //   expenses.assignAll(allExpenses);
  // }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    fetchAllExpenses(); // Refresh the list
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    fetchAllExpenses(); // Refresh the list
  }

  // Delete an expense
  Future<void> deleteExpense(int expenseId) async {
    await _dbHelper.deleteExpense(expenseId);
    fetchAllExpenses(); // Refresh the list
  }

  // void fetchOnlyExpenses() async {
  //   final List<Expense> expenseList = await _dbHelper.getAllExpenses();
  //   expenses.assignAll(
  //       expenseList.where((expense) => expense.type == 'Expense').toList());
  //   expenses.reversed;
  // }

  // void fetchOnlyEarnings() async {
  //   final List<Expense> earningList = await _dbHelper.getAllExpenses();
  //   expenses.assignAll(
  //       earningList.where((expense) => expense.type == 'Earning').toList());
  // }



  // Map<DateTime, List<Expense>> groupTasksByDate(List<Expense> expenses) {
  //   Map<DateTime, List<Expense>> groupedTasks = {};

  //   for (var expense in expenses) {
  //     // Get only the date part (year, month, day)
  //     DateTime date = DateTime(expense.dateTime,
  //         task.startDateTime.month, task.startDateTime.day);

  //     if (groupedTasks[date] == null) {
  //       groupedTasks[date] = [];
  //     }
  //     groupedTasks[date]!.add(task);
  //   }

  //   // Sort tasks within each date by time
  //   for (var date in groupedTasks.keys) {
  //     groupedTasks[date]!
  //         .sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  //   }

  //   return groupedTasks;
  // }
}
