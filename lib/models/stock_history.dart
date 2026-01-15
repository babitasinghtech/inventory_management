class StockHistory {
  final int? historyId;
  final String productId;
  final int changeAmount;
  final int stockAfterChange;
  final DateTime timestamp;
  final String changeType;

  StockHistory({
    this.historyId,
    required this.productId,
    required this.changeAmount,
    required this.stockAfterChange,
    required this.timestamp,
    required this.changeType,
  });

  Map<String, dynamic> toMap() {
    return {
      'historyId': historyId,
      'productId': productId,
      'changeAmount': changeAmount,
      'stockAfterChange': stockAfterChange,
      'timestamp': timestamp.toIso8601String(),
      'changeType': changeType,
    };
  }

  factory StockHistory.fromMap(Map<String, dynamic> map) {
    return StockHistory(
      historyId: map['historyId'] as int?,
      productId: map['productId'] as String,
      changeAmount: map['changeAmount'] as int,
      stockAfterChange: map['stockAfterChange'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      changeType: map['changeType'] as String,
    );
  }
}
