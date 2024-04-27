import 'package:youtube_downloader/app/utils/enum/preference_key.enum.dart';

extension PreferenceKeyExtension on PreferenceKeyEnum {
  String get key {
    switch (this) {
      case PreferenceKeyEnum.clearButtonEnabled:
        return 'clearButtonEnabled';
      case PreferenceKeyEnum.pasteButtonEnabled:
        return 'pasteButtonEnabled';
      case PreferenceKeyEnum.savePath:
        return 'savePath';
      case PreferenceKeyEnum.utilizeSavePathButtonEnabled:
        return 'utilizeSavePathButtonEnabled';
      default:
        throw Exception('Chave de preferência desconhecida');
    }
  }
}