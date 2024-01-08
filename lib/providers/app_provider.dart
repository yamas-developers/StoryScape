import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stories_app/models/story.dart';

import '../constants.dart';
import '../routes/session_manager.dart';
import '../utils/public_methods.dart';

class AppProvider with ChangeNotifier {
  init(String locale) async {
    SessionManager sessionManager = SessionManager();
    String? name = await sessionManager.getData(NAME);
    String? gender = await sessionManager.getData(GENDER);
    if (isValidGenderString(gender) && name != null) {
      _name = name;
      _gender = gender == BOY ? Genders.Boy : Genders.Girl;
      _initialized = true;
    }
    playAppAudio();
    _locale = locale;
    notifyListeners();
    checkForStories();
  }

  checkForStories() async {
    final directory = await getApplicationDocumentsDirectory();

    for (Story story in stories) {
      if (story.identifier != null || story.identifier != '') {
        final Directory destinationDirectory =
            Directory('${directory.path}/${story.identifier}');
        bool folderExists = await destinationDirectory.exists();
        story.isDownloaded = folderExists;
      }
    }
    notifyListeners();
  }

  List<Story> _stories =
      storiesData.map((storyData) => Story.fromMap(storyData)).toList();

  List<Story> get stories => _stories;

  set stories(List<Story> value) {
    _stories = value;
    notifyListeners();
  }

  bool? _initialized;
  AudioPlayer _audioPlayer = AudioPlayer();

  bool get muted => _muted;

  set muted(bool value) {
    _muted = value;
    _checkifMuted();
    notifyListeners();
  }

  bool _muted = false;
  String? _name;
  String _locale = 'en';

  String get locale => _locale;

  set locale(String value) {
    _locale = value;
    notifyListeners();
  }

  Genders? _gender;
  bool? _dayTime;

  String? get name => _name;

  set name(String? value) {
    if (value == null) {
      print('name is null');
      return;
    }
    SessionManager sessionManager = SessionManager();
    sessionManager.storeString(NAME, value);
    _name = value;
    notifyListeners();
  }

  bool? get dayTime => _dayTime;

  bool? get initialized => _initialized;

  set initialized(bool? value) {
    _initialized = value;
    notifyListeners();
  }

  set dayTime(bool? value) {
    _dayTime = value;
  }

  Genders? get gender => _gender;

  String get genderString => getGenderString(_gender);

  set gender(Genders? value) {
    if (value == null) {
      print('gender is null');
      return;
    }
    SessionManager sessionManager = SessionManager();
    sessionManager.storeString(GENDER, value == Genders.Boy ? BOY : GIRL);
    _gender = value;
    notifyListeners();
  }

  _checkifMuted() {
    if (_muted) {
      _audioPlayer.setVolume(0.0);
    } else {
      _audioPlayer.setVolume(1.0);
    }
  }

  void playStoryAudio(String musicPath) {
    if (musicPath.isEmpty) {
      return;
    }
    _audioPlayer.stop();

    _audioPlayer.play(DeviceFileSource(musicPath));
    _checkifMuted();
  }

  stopStoryAudio() {
    _audioPlayer.stop();
    playAppAudio();
  }

  playAppAudio() {
    _audioPlayer.play(AssetSource('audio/app_music.ogg'));
    _checkifMuted();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

// muteAudio() {
//   _audioPlayer.setVolume(0.0);
// }
}
