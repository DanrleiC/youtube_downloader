// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/controller/home_page.controller.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final TextEditingController _urlController = TextEditingController();
  final HomePageController controller = HomePageController();
  
  String _savePath = '';

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

  Widget _downloadBtn(){
    return ElevatedButton(
      onPressed: () async {
        _savePath = await controller.pickSaveLocation();
        if (_savePath.isNotEmpty) {
          controller.downloadVideo(_urlController.text, _savePath);
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


  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
