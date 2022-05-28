import 'package:ctc_rpg_game/weapon.dart';
import 'global_data.dart';

class BuffType {
  String getTypeName() => "未知类型";
}

// Buff shipped with weapons
class WeaponBuff extends BuffType {
  Weapon weapon;

  WeaponBuff(this.weapon);

  @override
  String getTypeName() => "武器被动";
}

// Buff shipped with characters
class CharacterBuff extends BuffType {
  @override
  String getTypeName() => "角色被动";
}

// Temporary buffs that fades with time
class TemporaryBuff extends BuffType {
  int roundGained, lastingRounds;

  TemporaryBuff(this.roundGained, this.lastingRounds);

  @override
  String getTypeName() => "剩余 ${remainingRounds()} 回合";

  bool expired() {
    return roundGained + lastingRounds < GlobalData.singleton.round;
  }

  int remainingRounds() {
    return roundGained + lastingRounds - GlobalData.singleton.round;
  }
}
