import 'package:newjarvis/models/conversation_item_model.dart';

class ConversationResponseModel {
  final String cursor; // Search, filter data by cursor
  final bool hasMore;
  final int limit; // Default 100
  final List<ConversationItemModel> items; // List of conversation items

  ConversationResponseModel({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  factory ConversationResponseModel.fromMap(Map<String, dynamic> map) {
    return ConversationResponseModel(
      cursor: map['cursor'] as String,
      hasMore: map['hasMore'] as bool,
      limit: map['limit'] as int,
      items: List<ConversationItemModel>.from(
        map['items'].map((x) => ConversationItemModel.fromMap(x)),
      ),
    );
  }

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationResponseModel(
      cursor: json['cursor'],
      hasMore: json['hasMore'] ?? false,
      limit: json['limit'],
      items: List<ConversationItemModel>.from(
        json['items'].map((x) => ConversationItemModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cursor': cursor,
      'hasMore': hasMore,
      'limit': limit,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  @override
  String toString() =>
      'ConversationResponseModel(cursor: $cursor, hasMore: $hasMore, limit: $limit, items: $items)';
}
