import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/chart/chart.dart';
import 'package:expenses_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'expenses_list/expanses_list.dart';

class Expenses extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const Expenses({super.key, required this.onToggleTheme});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseFirestore.instance
        .collection('expenses')
        .snapshots()
        .listen((snapshot) {
      final loadedExpenses = snapshot.docs
          .map((doc) => Expense.fromFirestore(doc.data(), doc.id))
          .toList();

      setState(() {
        _registeredExpenses.clear();
        _registeredExpenses.addAll(loadedExpenses);
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _addExpense(Expense expense) async {
    await FirebaseFirestore.instance
        .collection('expenses')
        .add(expense.toMap());
  }

  Future<void> _removeExpense(Expense expense) async {
    if (expense.firestoreId == null) return;
    await FirebaseFirestore.instance
        .collection('expenses')
        .doc(expense.firestoreId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    var width = MediaQuery.of(context).size.width;
    Widget mainContent = Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: TextStyle(color: textColor),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Expenses Tracker App')),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => NewExpense(onAddExpense: _addExpense),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
      ),
    );
  }
}
