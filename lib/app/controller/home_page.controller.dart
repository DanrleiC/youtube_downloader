import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:youtube_downloader/app/components/loading.component.dart';
import 'package:youtube_downloader/app/view/settings_page.view.dart';

import '../utils/enum/type.enum.dart';

class HomePageController {
  // Instância única da classe
  static final HomePageController _instance = HomePageController._internal();

  final yt = YoutubeExplode();
  final _message = ValueNotifier<String>('');
  final _errorText = ValueNotifier<String?>(null);
  final _titleTextController = TextEditingController();
  final _type = ValueNotifier<DownloadType>(DownloadType.audio);

  String videoId = '';

  // Construtor privado
  HomePageController._internal();

  // Método estático para acessar a instância única
  factory HomePageController() {
    return _instance;
  }

  // Pega o valor do titulo
  TextEditingController get titleTextController => _titleTextController;

  set titleTextControllerx(String title){
    _titleTextController.text = title;
  }

  // Pega o valor referente ao tipo de formato
  ValueNotifier<DownloadType> get type => _type;

  // Seta o valor referente ao tipo de formato
  set typex(DownloadType tp) {
    _type.value = tp;
  }

  // Pega o valor da mensagem
  ValueNotifier<String> get message => _message;

  ValueNotifier<String?> get errorText => _errorText;

  /// Obtém informações de um vídeo a partir de sua URL.
  ///
  /// Esta função:
  ///   - Extrai o ID do vídeo da URL fornecida.
  ///   - Utiliza o ID do vídeo para obter informações detalhadas do vídeo.
  ///   - Processa o título do vídeo para formatação ou qualquer outra operação necessária.
  ///   - Define o título processado em [titleTextControllerx] para exibição ao usuário.
  Future<void> getVideoInfo({required String url, required BuildContext context}) async {
    try {
      Loading.show(context: context);
      videoId = extractVideoId(url);
      var video = await yt.videos.get(videoId);
      String title = processesTitle(title: video.title);
      titleTextControllerx = title;
    } finally {
      Loading.hide();
    }
  }

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

  /// Remove as aspas duplas de uma string [title].
  ///
  /// Esta função recebe uma string [title] como entrada e remove todas as ocorrências
  String processesTitle({required String title}){
    return title.replaceAll(RegExp(r'["\/\|]'), '');
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
  Future<void> downloadMedia({required String savePath, required BuildContext context}) async {
    try {
      Loading.show(context: context);

      if (videoId.isEmpty) {
        _message.value = 'URL inválida. Por favor, insira uma URL válida do YouTube.';
        return;
      }

      var manifest = await yt.videos.streamsClient.getManifest(videoId);

      switch (type.value) {
        case DownloadType.audio:
          await _downloadAudio(
            savePath: savePath,
            title: titleTextController.text,
          );
          break;
        case DownloadType.video:
          var streamInfo = manifest.muxed.bestQuality;
          await _download(
            savePath: savePath,
            title: titleTextController.text,
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
    } finally {
      Loading.hide();
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

  Future<void> _downloadAudio({required String savePath, required String title}) async {
    // Obtém o manifesto de streams do vídeo
    var manifest = await yt.videos.streamsClient.getManifest(videoId);

    // Seleciona o melhor stream de áudio disponível
    var bestAudio = manifest.audio.withHighestBitrate();

    // Define os caminhos dos arquivos
    var tempFilePath = '$savePath/$title.temp';
    var finalFilePath = '$savePath/$title.mp3';

    File file;
    Platform.isWindows? file = File(tempFilePath) : file = File(finalFilePath);

    var fileStream = file.openWrite();

    // Faz o download do áudio e salva no arquivo temporário
    var audioStream = yt.videos.streamsClient.get(bestAudio);
    await audioStream.pipe(fileStream);

    await fileStream.flush();
    await fileStream.close();

    if (Platform.isWindows) {
      _message.value = 'Download concluído. Iniciando conversão para MP3...';

      // Converte o arquivo para MP3
      await convertToMp3(tempFilePath, finalFilePath);

      // Remove o arquivo temporário
      await File(tempFilePath).delete();  
    }

    _message.value = 'Arquivo final salvo em: $finalFilePath';
  }

  /// Converte um arquivo de áudio para MP3 usando FFmpeg.
  Future<void> convertToMp3(String inputPath, String outputPath) async {

    //TODO: verificar para Embeddar o Executável do FFmpeg no projeto para que não seja necessário o usuário fazer o download de mais nada somente do projeto
    String ffmpegPath = 'D:\\ffmpeg\\bin\\ffmpeg.exe';

    ProcessResult result = await Process.run(ffmpegPath, [
      '-i', inputPath,
      '-acodec', 'libmp3lame',
      '-b:a', '192k',
      outputPath
    ]);

    if (result.exitCode == 0) {
      if (kDebugMode) {
        print('Conversão concluída: $outputPath');
      }
    } else {
      if (kDebugMode) {
        print('Erro na conversão: ${result.stderr}');
      }
    }
  }

  bool validateInput(String input) {
    if (input.contains('"')) {
      _errorText.value = 'Aspas duplas não são permitidas!';
      return false;
    }
    _errorText.value = null;
    return true;
  }

  void navigatePageSetting(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPageView()));
  }

  /// Função assíncrona para lidar com o evento de escolha de local e download.
  ///
  /// Esta função:
  ///   - Chama `pickSaveLocation` do controller para permitir que o usuário escolha um local de salvamento.
  ///   - Se um local válido for selecionado, chama `downloadMedia` do controller para iniciar o download do vídeo.
  ///   - Se nenhum local for selecionado, define a mensagem de erro no controller informando que nenhum diretório foi selecionado.
  void onPressChooseLocationAndDownload(BuildContext context) async {
    final savePath = await pickSaveLocation();
    if (savePath.isNotEmpty) {
      downloadMedia(savePath: savePath, context: context);
    } else {
      message.value = 'Nenhum diretório selecionado.';
    }
  }

  /// Função assíncrona para lidar com o evento de download ( Botão de download direto, presente na home page ).
  ///
  /// Esta função:
  ///   - Obtém o caminho de salvamento do diretório preferencial das configurações.
  ///   - Se um caminho válido for encontrado, chama `downloadMedia` do controller para iniciar o download do vídeo.
  void onPressDownload(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final valor = pref.getString('savePath');
    if (valor != null) {
      downloadMedia(savePath: valor, context: context);
    }
  }
}