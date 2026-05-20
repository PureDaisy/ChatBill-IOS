import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final _uuid = const Uuid();

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedMonth = DateTime.now();

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedMonth => _selectedMonth;

  DateTime get monthStart => DateTime(_selectedMonth.year, _selectedMonth.month, 1);
  DateTime get monthEnd => DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59);

  List<Expense> get currentMonthExpenses {
    return _expenses.where((e) {
      return e.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
             e.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
    }).toList();
  }

  double get currentMonthTotal {
    return currentMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> get categoryTotals {
    final totals = <String, double>{};
    for (final expense in currentMonthExpenses) {
      totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount;
    }
    return totals;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _db.getAllExpenses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense({
    required double amount,
    required String description,
    required String categoryId,
    required DateTime date,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      description: description,
      categoryId: categoryId,
      date: date,
    );

    try {
      await _db.insertExpense(expense);
      _expenses.insert(0, expense);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _db.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _db.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  List<MapEntry<Category, double>> getSortedCategoryTotals() {
    final entries = categoryTotals.entries.map((e) {
      return MapEntry(Category.getById(e.key), e.value);
    }).toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
