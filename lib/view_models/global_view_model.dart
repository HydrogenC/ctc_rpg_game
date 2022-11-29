import 'package:ctc_rpg_game/global_data.dart';
import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/entity.dart';

class GlobalViewModel extends ChangeNotifier {
  GlobalViewModel() {
    activeEntity = GlobalData.singleton.activeEntity;
    GlobalData.singleton.viewModel = this;
  }

  late Entity activeEntity;

  void updateActiveEntity(Entity entity) {
    activeEntity = entity;
    notifyListeners();
  }

  // Call when an entity dies
  void forceUpdate() {
    notifyListeners();
  }
}
