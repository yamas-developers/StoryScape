import 'dart:io';

import 'package:flutter/material.dart';

class Story {
  String? identifier;
  String? name;

  // String? cover;
  String? basePath;
  String? musicPath;
  String? storyPath;
  Color? storyColor;

  // num? totalPages = -1;
  List<File> images = [];
  Map<String, String> data = {};
  int itemIndex = -1;
  int downloadProgress = -1;
  bool isDownloaded = false;

  String? pages;
  String? size;
  Map<String, String> covers = {};
  bool isProcessed = false;

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
    this.storyColor,
    this.covers = const {},
    this.isProcessed = false,
    this.downloadProgress = -1,
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
        identifier: map['identifier'] ?? '',
        name: map['name'] ?? '',
        pages: map['pages'] ?? '',
        size: map['size'] ?? '',
        covers: map['covers'] ?? {},
        storyColor: map['color']
        // isProcessed: map['isProcessed'] ?? false,
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
      'isProcessed': isProcessed,
    };
  }
}
