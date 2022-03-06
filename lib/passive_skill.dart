import 'global_data.dart';
import 'basics.dart';
import 'entity.dart';

abstract class PassiveSkill extends IGameEventListener {
  String name, description;

  void formMessage(String msg){
    GlobalData.singleton.appendMessage("(被动)$name: $msg");
  }

  PassiveSkill(this.name, this.description);

  PassiveSkill clone();
}
