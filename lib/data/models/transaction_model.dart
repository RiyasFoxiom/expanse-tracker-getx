class TransactionModel {
  int? id;
  late double amount;
  late String category;
  late String type; // 'income' or 'expense'
  late DateTime date;
  String? notes;
  int? bankId; // Foreign key to banks
  late DateTime createdAt;
  DateTime? updatedAt;
  bool isPayback;
  bool isCompleted;

  TransactionModel({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.notes,
    this.bankId,
    DateTime? createdAt,
    this.updatedAt,
    this.isPayback = false,
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert model to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date.toIso8601String(),
      'notes': notes,
      'bank_id': bankId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_payback': isPayback ? 1 : 0,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  // Create model from Map from database
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      bankId: map['bank_id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      isPayback: (map['is_payback'] ?? 0) == 1,
      isCompleted: (map['is_completed'] ?? 0) == 1,
    );
  }

  TransactionModel copyWith({
    int? id,
    double? amount,
    String? category,
    String? type,
    DateTime? date,
    String? notes,
    int? bankId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPayback,
    bool? isCompleted,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      bankId: bankId ?? this.bankId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPayback: isPayback ?? this.isPayback,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
