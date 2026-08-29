import 'dart:convert';

/// Category enum for items in the Bill of Quantities
enum BoqCategory {
  concrete,
  masonry,
  steel,
  formwork,
  earthwork,
  other,
}

extension BoqCategoryExt on BoqCategory {
  String get displayName {
    switch (this) {
      case BoqCategory.concrete:
        return 'الخرسانة المسلحة والعادية';
      case BoqCategory.masonry:
        return 'أعمال البلوك والمباني';
      case BoqCategory.steel:
        return 'حديد التسليح والكانات';
      case BoqCategory.formwork:
        return 'الشدات الخشبية والقوالب';
      case BoqCategory.earthwork:
        return 'الحفر والردم والتربة';
      case BoqCategory.other:
        return 'أعمال أخرى ومصنعيات';
    }
  }

  String get shortName {
    switch (this) {
      case BoqCategory.concrete:
        return 'خرسانة';
      case BoqCategory.masonry:
        return 'بناء';
      case BoqCategory.steel:
        return 'تسليح';
      case BoqCategory.formwork:
        return 'شدات';
      case BoqCategory.earthwork:
        return 'تربة';
      case BoqCategory.other:
        return 'أخرى';
    }
  }
}

/// Item in the Bill of Quantities (BOQ)
class BoqItemModel {
  final String id;
  final BoqCategory category;
  final String title;
  final String description;
  final String unit;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;

  const BoqItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
  });

  BoqItemModel copyWith({
    String? id,
    BoqCategory? category,
    String? title,
    String? description,
    String? unit,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return BoqItemModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? (quantity != null && unitPrice != null ? quantity * unitPrice : this.totalPrice),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.index,
      'title': title,
      'description': description,
      'unit': unit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BoqItemModel.fromMap(Map<String, dynamic> map) {
    return BoqItemModel(
      id: map['id'] ?? '',
      category: BoqCategory.values[map['category'] as int? ?? 0],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      unit: map['unit'] ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BoqItemModel.fromJson(String source) =>
      BoqItemModel.fromMap(json.decode(source));
}
