import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:youtube_downloader/app/utils/enum/preference_key.enum.dart';
import 'package:youtube_downloader/app/utils/extension/preference_key.extension.dart';
import 'package:youtube_downloader/app/utils/global_state_notifier.dart';

class SettingsPageController {
  /// Instância única do controlador de página de configurações.
  static final SettingsPageController _instance = SettingsPageController._internal();

  /// Construtor interno para controlador de página de configurações.
  SettingsPageController._internal();

  /// Método de fábrica para obter a instância do controlador de página de configurações.
  factory SettingsPageController() {
    return _instance;
  }

  late final SharedPreferences prefs;

  final stateNotifier = GlobalStateNotifier();

  final savePath = ValueNotifier<String>('');

  final clearButtonEnabled = ValueNotifier<bool>(false);

  final pasteButtonEnabled = ValueNotifier<bool>(false);

  final utilizeSavePathButtonEnabled = ValueNotifier<bool>(false);

  /// Carrega as configurações das preferências.
  Future<void> loadSettings() async {
    _loadPreference<String>(PreferenceKeyEnum.savePath.key, savePath);
    _loadPreference<bool>(PreferenceKeyEnum.clearButtonEnabled.key, clearButtonEnabled);
    _loadPreference<bool>(PreferenceKeyEnum.pasteButtonEnabled.key, pasteButtonEnabled);
    _loadPreference<bool>(PreferenceKeyEnum.utilizeSavePathButtonEnabled.key, utilizeSavePathButtonEnabled);
  }

  /// Carrega uma preferência específica das preferências.
  void _loadPreference<T>(String key, ValueNotifier<T> notifier) {
    final value = prefs.get(key);
    if (value != null) {
      notifier.value = value as T;
    }
  }

  /// Define uma preferência específica nas preferências.
  void _setPreference<T>(String key, T value, ValueNotifier<T> notifier) async {
    notifier.value = value;

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }

    stateNotifier.triggerUpdate();
  }

  void setClearButtonEnabled(bool value) {
    _setPreference<bool>(PreferenceKeyEnum.clearButtonEnabled.key, value, clearButtonEnabled);
  }

  void setPasteButtonEnabled(bool value) {
    _setPreference<bool>(PreferenceKeyEnum.pasteButtonEnabled.key, value, pasteButtonEnabled);
  }

  void setUtilizePickSaveLocationButtonEnabled(bool value, BuildContext? context) async {
    if (value && context != null) { 
      _loadPreference<String>(PreferenceKeyEnum.savePath.key, savePath);

      if(savePath.value.isEmpty) {
        alertUtilizePickSave(context);
      } else {
        _setUtilizeSavePath(value);
      }
    } else {
      _setUtilizeSavePath(value);
    }
  }

  /// Seleciona um caminho de salvamento usando o seletor de arquivo.
  Future<String?> pickSaveLocation(BuildContext context) async {
    return FilePicker.platform.getDirectoryPath();
  }

  /// Função auxiliar.
  void _setSavePath(String path) {
    _setPreference<String>(PreferenceKeyEnum.savePath.key, path, savePath);
  }

  /// Função auxiliar.
  /// 
  /// Proposito de reduzir o tamanho do codigo, tornando mais facil de entender.
  void _setUtilizeSavePath (bool value) {
    _setPreference<bool>(PreferenceKeyEnum.utilizeSavePathButtonEnabled.key, value, utilizeSavePathButtonEnabled);
  }

  /// Manipula o pressionamento do botão de seleção de local de salvamento.
  void onClickSaveLocationButtonPress(BuildContext context) async {
    final path = await pickSaveLocation(context);
    if (path != null) {
      _setSavePath(path);
    }
  }

  /// Limpa o caminho de salvamento e desabilita o botão de utilização.
  void setClearSaveLocation() {
    _setSavePath('');
    setUtilizePickSaveLocationButtonEnabled(false, null);
  }

  /// Exibe um alerta solicitando ao usuário que selecione um local de salvamento.
  void alertUtilizePickSave(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAlert(context);
      },
    );
  }

  /// Constrói o diálogo de alerta para seleção de caminho de salvamento.
  AlertDialog _buildAlert(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleção de Caminho'),
      content: const Text('Por favor, selecione um caminho para definir o local de salvamento.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
        TextButton(
          onPressed: () async {
            final path = await pickSaveLocation(context);
            if (path != null) {
              _setSavePath(path);
              _setUtilizeSavePath(true);
              Navigator.pop(context);
            } else {
              throw "O usuário não escolheu o local para salvar";
            }
          },
          child: const Text('Selecionar caminho'),
        ),
      ],
    );
  }
}