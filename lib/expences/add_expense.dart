import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/expences/expense_controller.dart';
import 'package:note_app/expences/expense.dart';
import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';
import 'package:expressions/expressions.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final ExpenseController controller = Get.find<ExpenseController>();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _category = '';
  String _description = '';
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _type = 'Expense'; // Default type

  // Helper function to show date picker
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Helper function to submit form
  void _submitForm() {
    evaluateAndSetAmount(); // Calculate the amount first
    if (_amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Amount is invalid or missing")),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final expense = Expense(
        category: _category,
        description: _description,
        amount: _amount,
        dateTime: _selectedDate.toIso8601String(),
        color: _type == 'Earning' ? Colors.green.value : Colors.purple.value,
        type: _type,
      );
      controller.addExpense(expense);
      Get.back(); // Close form screen
    }
  }

  String _result = "Noting";

  void evaluateAndSetAmount() {
    String input = _amountController.text;
    final validCharacters = RegExp(r'^[\d\s\+\-\*\/\(\)\.]+$');
    if (!validCharacters.hasMatch(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Amount")),
      );
      return;
    }
    try {
      final expression = Expression.parse(input);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});

      setState(() {
        _amount = result is double ? result : (result as num).toDouble();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Invalid Amount")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "Add Expenses")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Category (Ex:Food,Cloth,Device...)',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a category' : null,
                onSaved: (value) => _category = value!,
              ),
              SizedBox(
                height: 10,
              ),
              // Description input
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(
                height: 10,
              ),
              // Amount input
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                    labelText: 'Amount', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an amount' : null,
              ),
              SizedBox(
                height: 10,
              ),
              // Date picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _pickDate,
                    child: CustomText(
                      text: 'Pick Date',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type', style: TextStyle(fontSize: 16)),
                  ListTile(
                    title: Text('Expense'),
                    leading: Radio<String>(
                      value: 'Expense',
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Earning'),
                    leading: Radio<String>(
                      value: 'Earning',
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              Text(_result, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
            heroTag: "addbtn",
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: _submitForm,
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
