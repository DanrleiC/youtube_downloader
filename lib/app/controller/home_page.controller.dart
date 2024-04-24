import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../enum/type.enum.dart';

class HomePageController {
  // Instância única da classe
  static final HomePageController _instance = HomePageController._internal();

  final ValueNotifier<String> _message = ValueNotifier('');

  final yt = YoutubeExplode();

  final ValueNotifier<DownloadType> _type = ValueNotifier(DownloadType.video);

  // Construtor privado
  HomePageController._internal();

  // Método estático para acessar a instância única
  factory HomePageController() {
    return _instance;
  }

  // Pega o valor referente ao tipo de formato
  ValueNotifier<DownloadType> get type => _type;

  // Seta o valor referente ao tipo de formato
  set typex(DownloadType tp) {
    _type.value = tp;
  }

  // Pega o valor da mensagem
  ValueNotifier<String> get message => _message;

  /// Extrai o ID de um vídeo do YouTube a partir de uma URL.
  ///
  /// Esta função recebe uma URL de vídeo do YouTube como entrada e retorna o ID
  /// do vídeo contido nessa URL. Se a URL não contiver um ID de vídeo válido,
  /// a função retorna uma string vazia.
  String extractVideoId(String url) {
    RegExp regExp = RegExp(r"(?<=v=|youtu\.be\/)[a-zA-Z0-9_-]+");
    final match = regExp.firstMatch(url);
    return match?.group(0) ?? '';
  }

  /// Obtém o caminho de um diretório selecionado pelo usuário para salvar um arquivo.
  ///
  /// Esta função utiliza a biblioteca FilePicker para permitir que o usuário selecione
  /// um diretório em que deseja salvar um arquivo. Ele retorna um objeto Future que
  /// eventualmente contém o caminho do diretório selecionado.
  Future<String> pickSaveLocation() async {
    return (await FilePicker.platform.getDirectoryPath())!;
  }

  /// Baixa um vídeo do YouTube como arquivo MP3 ou MP4.
  ///
  /// Recebe uma [url] do YouTube e o [savePath] onde o arquivo será salvo.
  ///
  /// Lança exceções [YoutubeExplodeException] em caso de erro com a biblioteca
  /// YoutubeExplode, [SocketException] em caso de erro de conexão e
  /// exceções genéricas [Exception] para outros erros.
  Future<void> downloadMedia({required String url, required String savePath}) async {

    try {
      var videoId = extractVideoId(url);
      if (videoId.isEmpty) {
        _message.value = 'URL inválida. Por favor, insira uma URL válida do YouTube.';
        return;
      }

      var video = await yt.videos.get(videoId);

      //Retorna o titulo do video
      String title = video.title;

      var manifest = await yt.videos.streamsClient.getManifest(videoId);

      switch (type.value) {
        case DownloadType.audio:
          var streamInfo = manifest.audioOnly.withHighestBitrate();
          await _download(
            savePath: savePath,
            title: title,
            streamInfo: streamInfo,
            type: 'mp3'
          );
          break;
        case DownloadType.video:
          var streamInfo = manifest.muxed.bestQuality;
          await _download(
            savePath: savePath,
            title: title,
            streamInfo: streamInfo,
            type: 'mp4'
          );
          break;
      }
    } on YoutubeExplodeException catch (e) {
      _message.value = 'Erro ao realizar o download: $e';
    } on SocketException catch (e) {
      _message.value = 'Erro de conexão: $e';
    } catch (e) {
      _message.value = 'Erro desconhecido: $e';
    }
  }

  /// Realiza o download de um arquivo de vídeo de uma URL especificada e o salva localmente.
  ///
  /// Parâmetros:
  ///   - [savePath]: O caminho onde o arquivo será salvo.
  ///   - [title]: O título do arquivo.
  ///   - [streamInfo]: Informações sobre o fluxo de vídeo. (E.g., URL do vídeo)
  ///   - [type]: O tipo de arquivo (extensão), como "mp4".
  Future<void> _download({required String savePath, required String title, dynamic streamInfo, required String type}) async{
    var file = File('$savePath/$title.$type');
    var fileStream = file.openWrite();
    await yt.videos.streamsClient.get(streamInfo).pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();
    _message.value = 'Download concluído com sucesso! O arquivo foi salvo em: $savePath/$title.$type';
  }
}