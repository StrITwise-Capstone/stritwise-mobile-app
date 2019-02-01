import 'package:meta/meta.dart';

class CreditTransactionModel {
  final DateTime createdAt;
  final int creditModified;
  final String userId;

  CreditTransactionModel(
      {@required this.creditModified,
      @required this.userId,
      @required this.createdAt});

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'credit_modified': creditModified,
        'user_id': userId,
      };
}
