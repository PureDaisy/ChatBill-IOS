import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'Food',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4ECDC4),
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFFE66D),
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFA8E6CF),
    ),
    Category(
      id: 'health',
      name: 'Health',
      icon: Icons.local_hospital,
      color: Color(0xFFFF8A5B),
    ),
    Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF4D96FF),
    ),
    Category(
      id: 'bills',
      name: 'Bills',
      icon: Icons.receipt_long,
      color: Color(0xFF6C5CE7),
    ),
    Category(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF95A5A6),
    ),
  ];

  static Category getById(String id) {
    return defaultCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => defaultCategories.last,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.toARGB32(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    final existing = defaultCategories.where((c) => c.id == map['id']).firstOrNull;
    if (existing != null) return existing;

    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: IconData(map['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['colorValue'] as int),
    );
  }
}
