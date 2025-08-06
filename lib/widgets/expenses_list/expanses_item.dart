import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpansesItem extends StatelessWidget {
  const ExpansesItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 4),
                    Text(expense.formattedDate())
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.drink: Icons.local_drink,
  Category.travel: Icons.flight_takeoff,
  Category.shopping: Icons.shopping_bag,
  Category.work: Icons.work,
  Category.other: Icons.add_circle_outline_sharp,
};
