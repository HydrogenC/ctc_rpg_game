import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:flutter/material.dart';

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

  EntityViewModel(this.name, this.normalAttackDamage, this.activeSkills,
      this.passiveSkills);

  static EntityViewModel fromEntity(Entity entity) {
    return EntityViewModel(entity.name, entity.normalAttackDamage, [
      ...entity.activeSkillList.asMap().entries.map(
          (e) => ActiveSkillViewModel(e.value.name, e.value.description, e.key))
    ], [
      ...entity.passiveSkillList
          .asMap()
          .entries
          .map((e) => PassiveSkillViewModel(e.value.name, e.value.description))
    ]);
  }
}
