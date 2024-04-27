import 'package:flutter/foundation.dart';

class GlobalStateNotifier {
  // Instância Singleton
  static final GlobalStateNotifier _instance = GlobalStateNotifier._internal();

  factory GlobalStateNotifier() {
    return _instance;
  }

  GlobalStateNotifier._internal();

  // ValueNotifier para disparar atualizações
  final updateTrigger = ValueNotifier<bool>(false);

  // Método para disparar a atualização
  void triggerUpdate() {
    updateTrigger.value = !updateTrigger.value;
  }
}
