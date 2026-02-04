import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enum/download_type.enum.dart';
import '../view/settings_page.view.dart';
import '../components/loading.component.dart';

class HomePageController {
  static final HomePageController _instance = HomePageController._internal();
  factory HomePageController() => _instance;
  HomePageController._internal();

  static const String baseUrl = 'http://127.0.0.1:8000';

  final _message = ValueNotifier<String>('');
  final _titleTextController = TextEditingController();
  final _type = ValueNotifier<DownloadTypeEnum>(DownloadTypeEnum.audio);

  String _videoUrl = '';
  String? _generatedFile;

  // ================= GETTERS =================

  ValueNotifier<String> get message => _message;
  TextEditingController get titleTextController => _titleTextController;
  ValueNotifier<DownloadTypeEnum> get type => _type;

  // ================= VIDEO INFO =================

  Future<void> getVideoInfo({
    required String url,
    required BuildContext context,
  }) async {
    if (url.isEmpty) return;

    try {
      // Loading.show(context: context);
      _videoUrl = url;

      final response = await http.post(
        Uri.parse('$baseUrl/video/info'),
        body: {'url': url},
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final data = jsonDecode(response.body);
      _titleTextController.text = _sanitizeTitle(data['title']);
      _message.value = 'Vídeo carregado com sucesso';
    } catch (e) {
      _message.value = 'Erro ao obter informações do vídeo';
    } finally {
      // Loading.hide();
    }
  }

  // ================= DOWNLOAD =================

  Future<void> downloadMedia({
    required String savePath,
    required BuildContext context,
  }) async {
    if (_videoUrl.isEmpty) {
      _message.value = 'Informe uma URL válida';
      return;
    }

    try {
      Loading.show(context: context);

      final response = await http.post(
        Uri.parse('$baseUrl/download'),
        body: {
          'url': _videoUrl,
          'format': type.value == DownloadTypeEnum.audio ? 'mp3' : 'mp4',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final data = jsonDecode(response.body);
      _generatedFile = data['file'];

      await _downloadFile(savePath);
    } catch (e) {
      _message.value = 'Erro ao baixar o arquivo';
    } finally {
      Loading.hide();
    }
  }

  // ================= FILE DOWNLOAD =================

  Future<void> _downloadFile(String savePath) async {
    if (_generatedFile == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/file/$_generatedFile'),
    );

    final file = File('$savePath/${titleTextController.text}.${type.value == DownloadTypeEnum.audio ? 'mp3' : 'mp4'}');
    await file.writeAsBytes(response.bodyBytes);

    _message.value = 'Download concluído: ${file.path}';
  }

  // ================= UTIL =================

  String _sanitizeTitle(String title) {
    return title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');
  }

  bool validateInput(String input) {
  final invalidChars = RegExp(r'[\\/:*?"<>|]');

  if (invalidChars.hasMatch(input)) {
    message.value = 'O título contém caracteres inválidos';
    return false;
  }

  return true;
}

  Future<String> pickSaveLocation() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
    return (await FilePicker.platform.getDirectoryPath()) ?? '';
  }

  void navigatePageSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPageView()),
    );
  }

  void onPressChooseLocationAndDownload(BuildContext context) async {
    final savePath = await pickSaveLocation();
    if (savePath.isNotEmpty) {
      await downloadMedia(savePath: savePath, context: context);
    } else {
      _message.value = 'Nenhum diretório selecionado';
    }
  }

  void onPressDownload(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final savePath = pref.getString('savePath');
    if (savePath != null) {
      await downloadMedia(savePath: savePath, context: context);
    }
  }
}