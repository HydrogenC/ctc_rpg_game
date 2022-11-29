import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/active_skill.dart';

class Punishment extends ActiveSkill {
  static const String _description = "造成999999点伤害";

  Punishment() : super("惩戒", _description, const DamageValue(0, 0, 999999));

  @override
  ActiveSkill clone() {
    return Punishment();
  }
}
