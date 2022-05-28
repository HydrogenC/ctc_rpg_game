import 'buff_type.dart';
import 'entity.dart';
import 'global_data.dart';
import 'basics.dart';

abstract class Buff extends IGameEventListener {
  String name, description;
  BuffType buffType;

  Buff(this.name, this.description, this.buffType);

  void formMessage(String msg) {
    GlobalData.singleton
        .appendMessage("(${buffType.getTypeName()})$name: $msg");
  }

  void onGain(Entity self) {}

  void onRemove(Entity self) {}

  Buff clone(BuffType type);
}
