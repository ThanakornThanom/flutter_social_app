// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.lastRead,
    required this.data,
  });

  dynamic lastRead;
  List<Datum> data;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        lastRead: json["lastRead"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastRead": lastRead,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.description,
    required this.networkId,
    required this.userId,
    required this.verb,
    required this.targetId,
    required this.targetGroup,
    required this.imageUrl,
    required this.targetType,
    required this.hasRead,
    required this.lastUpdate,
    required this.actors,
    required this.actorsCount,
  });

  String description;
  String networkId;
  String userId;
  String verb;
  String targetId;
  String targetGroup;
  String imageUrl;
  String targetType;
  bool hasRead;
  int lastUpdate;
  List<Actor> actors;
  int actorsCount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        description: json["description"] == null ? null : json["description"],
        networkId: json["networkId"] == null ? null : json["networkId"],
        userId: json["userId"] == null ? null : json["userId"],
        verb: json["verb"] == null ? null : json["verb"],
        targetId: json["targetId"] == null ? null : json["targetId"],
        targetGroup: json["targetGroup"] == null ? null : json["targetGroup"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        targetType: json["targetType"] == null ? null : json["targetType"],
        hasRead: json["hasRead"] == null ? null : json["hasRead"],
        lastUpdate: json["lastUpdate"] == null ? null : json["lastUpdate"],
        actors: List<Actor>.from(json["actors"].map((x) => Actor.fromJson(x))),
        actorsCount: json["actorsCount"] == null ? null : json["actorsCount"],
      );

  Map<String, dynamic> toJson() => {
        "description": description == null ? null : description,
        "networkId": networkId == null ? null : networkId,
        "userId": userId == null ? null : userId,
        "verb": verb == null ? null : verb,
        "targetId": targetId == null ? null : targetId,
        "targetGroup": targetGroup == null ? null : targetGroup,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "targetType": targetType == null ? null : targetType,
        "hasRead": hasRead == null ? null : hasRead,
        "lastUpdate": lastUpdate == null ? null : lastUpdate,
        "actors": actors == null
            ? null
            : List<dynamic>.from(actors.map((x) => x.toJson())),
        "actorsCount": actorsCount == null ? null : actorsCount,
      };
}

class Actor {
  Actor({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
