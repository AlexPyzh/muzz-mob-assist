import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class InvestProvider extends ChangeNotifier {
  Track? _track;
  List<Investment>? _investments;

  Track? get track => _track;

  List<Investment>? get investments => _investments;

  set track(Track? track) {
    _track = track;
    notifyListeners();
  }

  set investments(List<Investment>? updatedInvests) {
    _investments = updatedInvests;
    notifyListeners();
  }
}
