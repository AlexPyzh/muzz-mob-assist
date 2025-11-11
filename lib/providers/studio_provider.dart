import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';

class StudioProvider extends ChangeNotifier {
  Artist? _artist;

  Artist? get artist => _artist;

  set artist(Artist? changedrtist) {
    _artist = changedrtist;
    notifyListeners();
  }
}
