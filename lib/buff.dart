import 'global_data.dart';
import 'basics.dart';

abstract class Buff extends IGameEventListener {
  String name, description;
  int roundGained, lastingRounds;

  Buff(this.name, this.description, this.roundGained, this.lastingRounds);

  bool expired() {
    return roundGained + lastingRounds < GlobalData.singleton.round;
  }

  int remainingRounds() {
    return roundGained + lastingRounds - GlobalData.singleton.round;
  }
}
