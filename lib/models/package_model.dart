// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PackageModel {
  String title;
  String likes;
  String description;
  String version;
  List<String> tags;

  PackageModel({
    required this.title,
    required this.likes,
    required this.description,
    required this.version,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'likes': likes,
      'description': description,
      'version': version,
      'tags': tags,
    };
  }

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
        title: map['title'] as String,
        likes: map['likes'] as String,
        description: map['description'] as String,
        version: map['version'] as String,
        tags: List<String>.from(
          (map['tags'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory PackageModel.fromJson(String source) =>
      PackageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
