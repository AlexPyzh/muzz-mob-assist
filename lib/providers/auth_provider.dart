import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/user.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';

class AuthProvider extends ChangeNotifier {
  final muzzClient = MuzzClient();
  //bool _isLoggedIn = false;
  // todo: remove
  bool _isLoggedIn = true;
  String _token = "";

  //final User _loggedInUser = User();
  // todo: remove
  final User _loggedInUser =
      User(id: 1, email: "u@e.com", name: "Alex Pyzh", role: "User");
  Future<List<Artist>>? _userArtists;

  bool get isLoggedIn => _isLoggedIn;
  String get token => _token;
  User get loggedInUser => _loggedInUser;

  Future<List<Artist>>? get userArtists {
    if (_userArtists == null) {
      loadUserArtists();
    }
    return _userArtists;
  }

  set isLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  set token(String token) {
    _token = token;
    decodeToken(token);
    notifyListeners();
  }

  void decodeToken(String token) {
    var decodedToken = JwtDecoder.decode(token);

    _loggedInUser.id = int.parse(decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"]);
    _loggedInUser.email = decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
    _loggedInUser.name = decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
    _loggedInUser.role = decodedToken[
        "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
  }

  Future loadUserArtists() async {
    if (_loggedInUser != null) {
      _userArtists = muzzClient.getUserArtists(_loggedInUser.id!);
    }
  }
}
