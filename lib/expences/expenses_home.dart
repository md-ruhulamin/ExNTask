// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/expences/add_expense.dart';
import 'package:note_app/expences/expense_controller.dart';
import 'package:note_app/expences/expense.dart';
import 'package:note_app/expences/update_expense.dart';
import 'package:note_app/task/task_controller.dart';

import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';

class ExpensesHome extends StatelessWidget {
  final ExpenseController controller = Get.put(ExpenseController());
  String formatDateTime(DateTime dateTime) {
    // Format: dd-MM-yyyy HH:mm
    return DateFormat('dd-MM-yyyy  HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: CustomAppBar(title: "All Expenses"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade100.withAlpha(120)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/balance.png",
                      height: 45,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Column(
                      children: [
                        CustomText(
                          text: "Current Balance: ",
                          size: 17,
                        ),Obx(
                      () => CustomText(maxLine: 2,
                        text:
                            '${controller.currentBalance.value.toStringAsFixed(1)} TK',
                        size: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      ],
                    ),
                    


                    
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Obx(
                  () => ExpancesBox(
                    text: 'Income',
                    imjPath: "assets/wallet.png",
                    value: controller.totalEarning.value.toStringAsFixed(0),
                    color: Colors.green.shade100,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Obx(
                  () => ExpancesBox(
                      text: 'Expense',
                      imjPath: "assets/reduction.png",
                      value: controller.totalExpense.value.toStringAsFixed(0),
                      color: Colors.tealAccent.shade100),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Obx(() {
                if (controller.expenses.isEmpty) {
                  return Center(child: Text('No expenses added'));
                }
                return ListView.builder(
                  itemCount: controller.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = controller.expenses[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Color(expense.color).withAlpha(20),
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        title: Row(
                          children: [
                            CustomText(
                              text: expense.category,
                              fontWeight: FontWeight.bold,
                              size: 15,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.description,
                              maxLines: 1,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(expense
                                    .dateTime), // Parse string to DateTime
                              ),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        trailing: Text(
                          '${expense.type == 'Earning' ? '+ ' : ' - '}${expense.amount.toStringAsFixed(0)} TK',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: expense.type == 'Earning'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onTap: () {
                          Get.to(UpdateExpenseForm(
                            expense: expense,
                          ));
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Are You want to delete this transaction?"),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      controller.deleteExpense(
                                          expense.expenseId ?? 1);
                                      controller.fetchAllExpenses();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: "addbtn",
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () {
          Get.to(AddExpenseForm());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ExpancesBox extends StatelessWidget {
  final Color color;
  final String text;
  final String value;
  final String imjPath;
  const ExpancesBox({
    Key? key,
    required this.text,
    required this.value,
    required this.imjPath,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20)),
          height: 70,
          child: ListTile(
            horizontalTitleGap: 2,
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: color.withAlpha(150),
                    borderRadius: BorderRadius.circular(15)),
                child: Image.asset(width: 35, imjPath)),
            title: Text(text),
            subtitle: CustomText(
              text: "${value} TK",
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          )),
    );
  }
}
