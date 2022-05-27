import 'global_data.dart';
import 'basics.dart';

abstract class Buff extends IGameEventListener {
  String name, description;

  Buff(this.name, this.description);

  void formMessage(String msg);

  bool expired();
}

abstract class TemporaryBuff extends Buff {
  TemporaryBuff(name, description, this.roundGained, this.lastingRounds)
      : super(name, description);
  int roundGained, lastingRounds;

  @override
  void formMessage(String msg) {
    GlobalData.singleton.appendMessage("(BUFF)$name: $msg");
  }

  @override
  bool expired() {
    return roundGained + lastingRounds < GlobalData.singleton.round;
  }

  int remainingRounds() {
    return roundGained + lastingRounds - GlobalData.singleton.round;
  }
}

// Use permanent buff as passive skills
abstract class PermanentBuff extends Buff {
  PermanentBuff(name, description) : super(name, description);

  @override
  bool expired() => false;

  PermanentBuff clone();

  @override
  void formMessage(String msg) {
    GlobalData.singleton.appendMessage("(被动)$name: $msg");
  }
}
