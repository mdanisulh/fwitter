import 'package:fwitter/core/enums/tweet_type_enum.dart';

class Tweet {
  final String text;
  final String link;
  final String uid;
  final List<String> hashtags;
  final List<String> imageLinks;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int retweetCount;
  final String retweetedBy;
  final String repliedTo;

  Tweet({
    required this.text,
    required this.link,
    required this.uid,
    required this.hashtags,
    required this.imageLinks,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.retweetCount,
    required this.retweetedBy,
    required this.repliedTo,
  });

  Tweet copyWith({
    String? text,
    String? link,
    String? uid,
    List<String>? hashtags,
    List<String>? imageLinks,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? retweetCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      link: link ?? this.link,
      uid: uid ?? this.uid,
      hashtags: hashtags ?? this.hashtags,
      imageLinks: imageLinks ?? this.imageLinks,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      retweetCount: retweetCount ?? this.retweetCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'link': link,
      'uid': uid,
      'hashtags': hashtags,
      'imageLinks': imageLinks,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'retweetCount': retweetCount,
      'retweetedBy': retweetedBy,
      'repliedTo': repliedTo,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] ?? '',
      link: map['link'] ?? '',
      uid: map['uid'] ?? '',
      hashtags: List<String>.from(map['hashtags'] ?? []),
      imageLinks: List<String>.from(map['imageLinks'] ?? []),
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']),
      likes: List<String>.from(map['likes'] ?? []),
      commentIds: List<String>.from(map['commentIds'] ?? []),
      id: map['\$id'] ?? '',
      retweetCount: map['retweetCount'] ?? 0,
      retweetedBy: map['retweetedBy'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, link: $link, uid: $uid, hashtags: $hashtags, imageLinks: $imageLinks, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, retweetCount: $retweetCount), retweetedBy: $retweetedBy, repliedTo: $repliedTo';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;
    return other.text == text && other.link == link && other.uid == uid && other.hashtags == hashtags && other.imageLinks == imageLinks && other.tweetType == tweetType && other.tweetedAt == tweetedAt && other.likes == likes && other.commentIds == commentIds && other.id == id && other.retweetCount == retweetCount && other.retweetedBy == retweetedBy && other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^ link.hashCode ^ uid.hashCode ^ hashtags.hashCode ^ imageLinks.hashCode ^ tweetType.hashCode ^ tweetedAt.hashCode ^ likes.hashCode ^ commentIds.hashCode ^ id.hashCode ^ retweetCount.hashCode ^ retweetedBy.hashCode ^ repliedTo.hashCode;
  }
}
