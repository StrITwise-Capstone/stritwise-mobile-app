import 'package:meta/meta.dart';

/// {@category Model}
/// Credit Transaction Firestore Model in the events subcollection.
class CreditTransactionModel {
  final DateTime createdAt;
  final int creditModified;
  final String userId;

  CreditTransactionModel(
      {@required this.creditModified,
      @required this.userId,
      @required this.createdAt});

  /// Maps all fields to a map for firebase transaction.
  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'credit_modified': creditModified,
        'user_id': userId,
      };
}
