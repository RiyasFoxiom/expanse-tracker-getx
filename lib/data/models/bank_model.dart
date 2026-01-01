
class BankModel {
  int? id;
  late String name;
  late String type; // 'savings', 'credit', 'debit'
  late String cardNumber; // New field
  late double balance;
  late DateTime createdAt;
  DateTime? updatedAt;

  BankModel({
    this.id,
    required this.name,
    required this.type,
    required this.cardNumber,
    required this.balance,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'card_number': cardNumber,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      cardNumber: map['card_number'] ?? '',
      balance: map['balance'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}