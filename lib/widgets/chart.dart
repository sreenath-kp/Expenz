import 'package:flutter/material.dart';
import 'package:expenz/widgets/chart_bar.dart';
import 'package:expenz/model/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  // Create a list of buckets
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.Food),
      ExpenseBucket.forCategory(expenses, Category.Leisure),
      ExpenseBucket.forCategory(expenses, Category.Travel),
      ExpenseBucket.forCategory(expenses, Category.Work),
      ExpenseBucket.forCategory(expenses, Category.Shopping),
      ExpenseBucket.forCategory(expenses, Category.Bills),
      ExpenseBucket.forCategory(expenses, Category.Others),
    ];
  }

  // Get the highest total expense
  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpense > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpense;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(0.4)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpense == 0
                        ? 0
                        : bucket.totalExpense / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF0E0D0D),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
