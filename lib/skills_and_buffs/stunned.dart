import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/buff.dart';

class Stunned extends Buff {
  static const String _description = "本回合无法操作";

  Stunned(int roundGained, int lastingRounds)
      : super("眩晕", _description, roundGained, lastingRounds);

  @override
  void onNewTurn(Entity self) {
    self.remainingUses--;
  }
}
