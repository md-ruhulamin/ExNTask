

import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/expences/expense_controller.dart';
import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';

import 'expense.dart';

class UpdateExpenseForm extends StatefulWidget {
  final Expense expense;

  UpdateExpenseForm({required this.expense});

  @override
  _UpdateExpenseFormState createState() => _UpdateExpenseFormState();
}

class _UpdateExpenseFormState extends State<UpdateExpenseForm> {
  final ExpenseController controller = Get.find<ExpenseController>();
   TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _category;
  late String _description;
  late double _amount;
  late DateTime _selectedDate;
  late String _type;

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with existing expense data
    _category = widget.expense.category;
    _description = widget.expense.description ?? '';
    _amount = widget.expense.amount;
    _selectedDate = DateTime.parse(widget.expense.dateTime);
    _type = widget.expense.type;
    _amountController = TextEditingController(text: widget.expense.amount.toString());
  }

  // Helper function to show date picker
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      final updatedExpense = Expense(
        expenseId: widget.expense.expenseId, // Use the existing ID for updating
        category: _category,
        description: _description,
        amount: _amount,
        dateTime: _selectedDate.toIso8601String(),
        color: _type == 'Earning' ? Colors.green.value : Colors.purple.value,
        type: _type,
      );
      controller.updateExpense(updatedExpense);
      controller.fetchAllExpenses();
      // Call the update method
      Get.back(); // Close the form screen after saving
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
          child: CustomAppBar(title: "Update Expenses")),
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
                initialValue: _category,
                decoration: InputDecoration(
                    labelText: 'Category', border: OutlineInputBorder()),
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
                initialValue: _description,
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
                //  initialValue: _amount.toString(),
                decoration: InputDecoration(
                    labelText: 'Amount', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an amount' : null,
                //    onSaved: (value) => _amount = double.parse(value!),
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
              // Type selection (earning or expense)
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

              // Submit button
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
