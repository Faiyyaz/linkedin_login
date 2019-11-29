// To parse this JSON data, do
//
//     final linkedinShareRequest = linkedinShareRequestFromJson(jsonString);

import 'dart:convert';

LinkedinShareRequest linkedinShareRequestFromJson(String str) =>
    LinkedinShareRequest.fromJson(json.decode(str));

String linkedinShareRequestToJson(LinkedinShareRequest data) =>
    json.encode(data.toJson());

class LinkedinShareRequest {
  Content content;
  Distribution distribution;
  String owner;
  String subject;
  ContentText text;

  LinkedinShareRequest({
    this.content,
    this.distribution,
    this.owner,
    this.subject,
    this.text,
  });

  factory LinkedinShareRequest.fromJson(Map<String, dynamic> json) =>
      LinkedinShareRequest(
        content: Content.fromJson(json["content"]),
        distribution: Distribution.fromJson(json["distribution"]),
        owner: json["owner"],
        subject: json["subject"],
        text: ContentText.fromJson(json["text"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "distribution": distribution.toJson(),
        "owner": owner,
        "subject": subject,
        "text": text.toJson(),
      };
}

class Content {
  List<ContentEntity> contentEntities;
  String title;

  Content({
    this.contentEntities,
    this.title,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        contentEntities: List<ContentEntity>.from(
            json["contentEntities"].map((x) => ContentEntity.fromJson(x))),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "contentEntities":
            List<dynamic>.from(contentEntities.map((x) => x.toJson())),
        "title": title,
      };
}

class ContentEntity {
  String entityLocation;
  List<Thumbnail> thumbnails;

  ContentEntity({
    this.entityLocation,
    this.thumbnails,
  });

  factory ContentEntity.fromJson(Map<String, dynamic> json) => ContentEntity(
        entityLocation: json["entityLocation"],
        thumbnails: List<Thumbnail>.from(
            json["thumbnails"].map((x) => Thumbnail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entityLocation": entityLocation,
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
      };
}

class Thumbnail {
  String resolvedUrl;

  Thumbnail({
    this.resolvedUrl,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        resolvedUrl: json["resolvedUrl"],
      );

  Map<String, dynamic> toJson() => {
        "resolvedUrl": resolvedUrl,
      };
}

class Distribution {
  LinkedInDistributionTarget linkedInDistributionTarget;

  Distribution({
    this.linkedInDistributionTarget,
  });

  factory Distribution.fromJson(Map<String, dynamic> json) => Distribution(
        linkedInDistributionTarget: LinkedInDistributionTarget.fromJson(
            json["linkedInDistributionTarget"]),
      );

  Map<String, dynamic> toJson() => {
        "linkedInDistributionTarget": linkedInDistributionTarget.toJson(),
      };
}

class LinkedInDistributionTarget {
  LinkedInDistributionTarget();

  factory LinkedInDistributionTarget.fromJson(Map<String, dynamic> json) =>
      LinkedInDistributionTarget();

  Map<String, dynamic> toJson() => {};
}

class ContentText {
  String text;

  ContentText({
    this.text,
  });

  factory ContentText.fromJson(Map<String, dynamic> json) => ContentText(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
