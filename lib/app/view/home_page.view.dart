// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_downloader/app/controller/home_page.controller.dart';
import 'package:youtube_downloader/app/enum/type.enum.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final TextEditingController _urlController = TextEditingController();
  final HomePageController controller = HomePageController();
  
  String savePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body()
    );
  }

  Widget _body(){
    return ValueListenableBuilder(
      valueListenable: controller.message,
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _fieldUrl(),
          _format(),
          const SizedBox(height: 20.0),
          _downloadBtn(),
          const SizedBox(height: 20.0),
          _message()
        ],
      ),
    );
  }

  Widget _fieldUrl(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: _urlController,
        decoration: const InputDecoration(
          labelText: 'Insira a URL do vídeo do YouTube',
        ),
      ),
    );
  }

  Widget _format(){
    return ValueListenableBuilder(
      valueListenable: controller.type,
      builder: (context, value, child) => SegmentedButton(
        segments: segments,
        selected: <DownloadType>{controller.type.value},
        onSelectionChanged: (Set newSelection) {
          controller.typex = newSelection.first;
        } 
      ),
    );
  }

  Widget _downloadBtn(){
    return ElevatedButton(
      onPressed: () async {
        savePath = await controller.pickSaveLocation();
        if (savePath.isNotEmpty) {
          controller.downloadMedia(url: _urlController.text,savePath: savePath);
        } else {
          controller.message.value = 'Nenhum diretório selecionado.';
        }
      },
      child: const Text('Escolher Local e Baixar'),
    );
  }

  Widget _message(){
    return Text(
      controller.message.value
    );
  }

  List<ButtonSegment<Enum>> get segments => const [
    ButtonSegment(
      value: DownloadType.audio,
      label: Text('Audio'),
      icon: Icon(FontAwesomeIcons.fileAudio)
    ),
    ButtonSegment(
      value: DownloadType.video,
      label: Text('Video'),
      icon: Icon(FontAwesomeIcons.fileVideo)
    ),
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
