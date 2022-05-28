import 'package:ctc_rpg_game/buff_type.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/buff.dart';

class Stunned extends Buff {
  static const String _description = "本回合无法操作";

  Stunned(BuffType type) : super("眩晕", _description, type);

  @override
  void onNewTurn(Entity self) {
    self.remainingUses--;
  }

  @override
  void onGain(Entity self) {
    self.remainingUses = 0;
  }

  @override
  Buff clone(BuffType type) => Stunned(type);
}
