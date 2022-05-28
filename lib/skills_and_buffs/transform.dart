import 'package:ctc_rpg_game/buff.dart';

import '../buff_type.dart';
import '../entity.dart';

class Transform extends Buff {
  static const String _description = "每次攻击时候会汲取对手的能量反哺自身，生命值+(攻击的伤害/2)";

  Transform(BuffType type) : super("转化", _description, type);

  @override
  void afterAttack(Entity self, Entity target, int damage) {
    damage ~/= 2;
    self.cure(damage);
    formMessage("生命值+$damage");
  }

  @override
  Buff clone(BuffType type) => Transform(type);
}
