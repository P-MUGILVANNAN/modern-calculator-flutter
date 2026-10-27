import 'package:intl/intl.dart';

/// Represents a single persisted calculation entry.
class CalculationHistoryItem {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistoryItem({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'expression': expression,
    'result': result,
    'timestamp': timestamp.toIso8601String(),
  };

  factory CalculationHistoryItem.fromJson(Map<String, dynamic> json) {
    return CalculationHistoryItem(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      expression: json['expression'] as String? ?? '',
      result: json['result'] as String? ?? '0',
      timestamp:
          json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
              : DateTime.now(),
    );
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE, hh:mm a').format(timestamp);
    } else {
      return DateFormat('MMM d, yyyy · hh:mm a').format(timestamp);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationHistoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
