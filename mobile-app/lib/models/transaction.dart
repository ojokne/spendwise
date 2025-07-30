// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String? userId;
  final String? id;
  final DateTime date;
  final String name;
  final int amount;
  const Transaction({
    this.userId,
    this.id,
    required this.date,
    required this.name,
    required this.amount,
  });

  Transaction copyWith({
    String? userId,
    String? id,
    DateTime? date,
    String? name,
    int? amount,
  }) {
    return Transaction(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      userId: map['userId'] != null ? map['userId'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      date: DateTime.parse(map['date'] as String),
      name: map['name'] as String,
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [userId, id, date, name, amount];
  }
}
