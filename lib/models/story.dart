import 'dart:io';

class Story {
  String? identifier;
  String? name;

  // String? cover;
  String? basePath;
  String? musicPath;
  String? storyPath;

  // num? totalPages = -1;
  List<File> images = [];
  Map<String, String> data = {};
  int itemIndex = -1;
  bool isDownloaded = false;

  String? pages;
  String? size;
  Map<String, String> covers = {};

  Story({
    this.identifier,
    this.name,
    // this.cover,
    this.isDownloaded = false,
    this.basePath,
    this.musicPath,
    this.storyPath,
    this.images = const [],
    this.data = const {},
    this.itemIndex = -1,
    // this.totalPages = -1,
    this.pages,
    this.size,
    this.covers = const {},
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      identifier: map['identifier'] ?? '',
      name: map['name'] ?? '',
      pages: map['pages'] ?? '',
      size: map['size'] ?? '',
      covers: map['covers'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'name': name,
      'pages': pages,
      'isDownloaded': isDownloaded,
      'size': size,
      'covers': covers,
    };
  }
}
