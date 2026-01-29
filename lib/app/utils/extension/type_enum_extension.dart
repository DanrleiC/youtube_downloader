import 'package:youtube_downloader/app/utils/enum/download_type.enum.dart';

extension ETypeEnumExtension on DownloadTypeEnum {
  String get title {
    switch (this) {
      case DownloadTypeEnum.audio:
        return 'Áudio';
      case DownloadTypeEnum.video:
        return 'Vídeo';
      }
  }
}