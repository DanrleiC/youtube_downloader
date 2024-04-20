import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePageController {
  // Instância única da classe
  static final HomePageController _instance = HomePageController._internal();

  final ValueNotifier<String> _message = ValueNotifier('');

  // Construtor privado
  HomePageController._internal();

  // Método estático para acessar a instância única
  factory HomePageController() {
    return _instance;
  }

  ValueNotifier<String> get message => _message;

  /// Extrai o ID de um vídeo do YouTube a partir de uma URL.
  ///
  /// Esta função recebe uma URL de vídeo do YouTube como entrada e retorna o ID
  /// do vídeo contido nessa URL. Se a URL não contiver um ID de vídeo válido,
  /// a função retorna uma string vazia.
  String extractVideoId(String url) {
    var regExp = RegExp(r"(?<=v=)[a-zA-Z0-9_-]+");
    var match = regExp.firstMatch(url);
    return match?.group(0) ?? '';
  }

  /// Obtém o caminho de um diretório selecionado pelo usuário para salvar um arquivo.
  ///
  /// Esta função utiliza a biblioteca FilePicker para permitir que o usuário selecione
  /// um diretório em que deseja salvar um arquivo. Ele retorna um objeto Future que
  /// eventualmente contém o caminho do diretório selecionado.
  Future<String> pickSaveLocation() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    return result!;
  }


  /// Baixa um vídeo do YouTube como arquivo MP3 ou MP4.
  ///
  /// Recebe uma [url] do YouTube e o [savePath] onde o arquivo será salvo.
  ///
  /// Lança exceções [YoutubeExplodeException] em caso de erro com a biblioteca
  /// YoutubeExplode, [SocketException] em caso de erro de conexão e
  /// exceções genéricas [Exception] para outros erros.
  Future<void> downloadVideo(String url, String savePath) async {
    var yt = YoutubeExplode();

    try {
      var videoId = extractVideoId(url);
      if (videoId.isEmpty) {
        _message.value = 'URL inválida. Por favor, insira uma URL válida do YouTube.';
        return;
      }

      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      var file = File('$savePath/video.mp3');

      try {
        // Tenta abrir o arquivo para escrita
        var fileStream = file.openWrite();

        // Pipe para o arquivo em vez de usar .get
        await yt.videos.streamsClient.get(audioStreamInfo).pipe(fileStream);

        await fileStream.flush();
        await fileStream.close();

        _message.value = 'Download concluído! O arquivo foi salvo em: $savePath';
      } catch (e) {
        _message.value = 'Erro ao escrever o arquivo: $e';
      }
    } on YoutubeExplodeException catch (e) {
      _message.value = 'Erro ao realizar o download: $e';
    } on SocketException catch (e) {
      _message.value = 'Erro de conexão: $e';
    } catch (e) {
      _message.value = 'Erro desconhecido: $e';
    } finally {
      yt.close();
    }
  }
}