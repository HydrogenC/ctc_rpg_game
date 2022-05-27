import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/buff.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/skills_and_buffs/stunned.dart';
import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/widgets/entity_view.dart';

class ArmourDamage {
  Entity from;
  int amount;

  ArmourDamage(this.from, this.amount);
}

class Toughness extends PermanentBuff implements ICustomEntityDisplay {
  int _armour = 0;
  List<ArmourDamage> damages = [];
  static const String _description = "本回合获得10点护甲，回合结束时，对对手造成失去护甲的同等伤害";

  Toughness() : super("坚韧", _description);

  @override
  void onNewTurn(Entity self) {
    for (var element in damages) {
      formMessage(
          "“${self.name}”对“${element.from.name}”造成${element.amount}点反弹伤害");
      element.from.receiveDamage(self, element.amount);
    }

    damages.clear();
    _armour = 10;
  }

  @override
  void afterDamaged(Entity self, Entity attacker, int damage) {
    int absorbed = damage.clamp(0, _armour);
    _armour -= absorbed;

    if (absorbed > 0) {
      formMessage("“${self.name}”的护盾吸收了$absorbed点伤害，剩余$_armour点护盾");
      damages.add(ArmourDamage(attacker, absorbed));
      self.cure(absorbed);
    }
  }

  @override
  PermanentBuff clone() {
    return Toughness();
  }

  @override
  List<Widget> getHealthBarAdditionalWidgets(Entity self) {
    return [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      ),
      const Icon(Icons.add_circle, color: Colors.white, size: 16),
      Padding(
        padding: textPadding,
        child: Text(_armour.toString(), style: whiteText),
      ),
    ];
  }

  @override
  List<Widget> getNameBarAdditionalWidgets(Entity self) => [];

  @override
  List<Widget> getWeaponBarAdditionalWidgets(Entity self) => [];
}
