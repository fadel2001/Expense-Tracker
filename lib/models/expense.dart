import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final dateFormat = DateFormat.yMd();

enum Category {
  food,
  drink,
  travel,
  shopping,
  work,
  other,
}

class Expense {
  final String id; // local unique id
  final String? firestoreId; // Firestore document ID
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.category,
    required this.title,
    required this.amount,
    required this.date,
    this.firestoreId,
  }) : id = uuid.v4();

  String formattedDate() {
    return dateFormat.format(date);
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category.name,
      };

  static Expense fromFirestore(Map<String, dynamic> data, String docId) {
    return Expense(
      firestoreId: docId,
      category: Category.values.firstWhere(
          (cat) => cat.name == data['category'],
          orElse: () => Category.other),
      title: data['title'],
      amount: (data['amount'] as num).toDouble(),
      date: DateTime.parse(data['date']),
    );
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket(this.category, this.expenses);

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (var expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
