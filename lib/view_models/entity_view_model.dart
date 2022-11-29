import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:flutter/material.dart';

import 'limited_property.dart';

class PassiveSkillViewModel {
  final String name;
  final String description;

  PassiveSkillViewModel(this.name, this.description);
}

class ActiveSkillViewModel {
  final String name;
  final String description;
  final int id;

  ActiveSkillViewModel(this.name, this.description, this.id);
}

class BuffViewModel {
  final String name, description;
  final int remainingRounds;

  BuffViewModel(this.name, this.description, this.remainingRounds);
}

class EntityViewModel extends ChangeNotifier {
  final String name;
  final DamageValue normalAttackDamage;
  final List<ActiveSkillViewModel> activeSkills;
  final List<PassiveSkillViewModel> passiveSkills;
  List<BuffViewModel> buffs = [];
  Map<String, Object> properties = {};
  bool alive = true;

  EntityViewModel(this.name, this.normalAttackDamage, this.activeSkills,
      this.passiveSkills);

  void modifyProperty(String key, Object obj) {
    properties[key] = obj;
    notifyListeners();
  }

  void setAlive(bool value) {
    if (alive != value) {
      alive = value;
      notifyListeners();
    }
  }

  void updateEntity(Entity entity) {
    // Avoid calling modifyProperty in case of unnecessary updates
    properties['hp'] = LimitedProperty(entity.hp, entity.maxHp);
    for (var element in entity.passiveSkillList) {
      element.updateViewModel(this);
    }

    for (var element in entity.buffs) {
      element.updateViewModel(this);
    }

    notifyListeners();
  }

  static EntityViewModel fromEntity(Entity entity) {
    var model = EntityViewModel(entity.name, entity.normalAttackDamage, [
      ...entity.activeSkillList.asMap().entries.map(
          (e) => ActiveSkillViewModel(e.value.name, e.value.description, e.key))
    ], [
      ...entity.passiveSkillList
          .asMap()
          .entries
          .map((e) => PassiveSkillViewModel(e.value.name, e.value.description))
    ]);
    entity.viewModel = model;
    return model;
  }
}
