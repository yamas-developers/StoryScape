import 'package:flutter/material.dart';

import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  Story? _story;

  Story? get story => _story;

  set story(Story? value) {
    if (value == null) {
      return;
    }
    _story = value;
    notifyListeners();
  }
}
