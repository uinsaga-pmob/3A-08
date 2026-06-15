class OrderRecord {
  final String orderId;
  final String date;
  final double amount;
  final String itemsSummary;
  final String paymentMethod;
  final String notes;

  OrderRecord({
    required this.orderId,
    required this.date,
    required this.amount,
    required this.itemsSummary,
    required this.paymentMethod,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'date': date,
      'amount': amount,
      'items_summary': itemsSummary,
      'payment_method': paymentMethod,
      'notes': notes,
    };
  }

  factory OrderRecord.fromMap(Map<String, dynamic> map) {
    return OrderRecord(
      orderId: map['order_id'] ?? '',
      date: map['date'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      itemsSummary: map['items_summary'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
