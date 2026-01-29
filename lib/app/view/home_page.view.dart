
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/components/my_app_bar.component.dart';
import 'package:youtube_downloader/app/controller/home_page.controller.dart';
import 'package:youtube_downloader/app/utils/enum/download_type.enum.dart';
import 'package:youtube_downloader/app/utils/extension/type_enum_extension.dart';
import 'package:youtube_downloader/app/utils/show_widget_preference.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageController controller = HomePageController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _body()
    );
  }

  PreferredSizeWidget appBar() {
    return MyAppBarComponent(
      title: 'Youtube Downloader',
      onSettingsPressed: () => controller.navigatePageSetting(context),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ValueListenableBuilder(
        valueListenable: controller.message,
        builder: (context, value, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 40,
          children: [
            _fieldUrl(),
            _formatSelector(),
            _titleField(),
            _downloadButton(),
            _statusMessage(),
          ],
        ),
      ),
    );
  }

  /// Campo de URL
  Widget _fieldUrl() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('URL do Vídeo'),
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            hintText: "Insira a URL do vídeo...",
          ),
          onChanged: (value) => controller.getVideoInfo(
            url: _urlController.text,
            context: context,
          ),
        ),
        _buttonsPasteClean(),
      ],
    );
  }

  /// Botões colar e limpar
  Widget _buttonsPasteClean() {
    return Row(
      spacing: 16,
      children: [
        ShowWidgetPreference(
          keyPreference: 'clearButtonEnabled',
          child: ElevatedButton(
            onPressed: () => _urlController.clear(),
            child: const Text("Limpar"),
          ),
        ),
        ShowWidgetPreference(
          keyPreference: 'pasteButtonEnabled',
          child: ElevatedButton(
            onPressed: () async {
              _urlController.text = await FlutterClipboard.paste();
              controller.getVideoInfo(
                url: _urlController.text,
                context: context,
              );
            },
            child: const Text("Colar"),
          ),
        ),
      ].map((e) => Expanded(child: e)).toList(growable: false)
    );
  }

  /// Escolha de formato (Áudio ou Vídeo)
  Widget _formatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const Text("Escolha o formato da mídia"),
        ValueListenableBuilder<DownloadTypeEnum>(
          valueListenable: controller.type,
          builder: (context, value, child) => Row(
            spacing: 15,
            children: DownloadTypeEnum.values.map((e) {
              return Expanded(
                child: ElevatedButton(
                  style: ButtonStyle().copyWith(
                    foregroundColor: WidgetStatePropertyAll(value == e ? Colors.black : null),
                    backgroundColor: WidgetStatePropertyAll(value == e ? Colors.white : null)
                  ),
                  onPressed: () => controller.type.value = e,
                  child: Text(e.title),
                ),
              );
            }).toList()
          ),
        )
      ],
    );
  }

  /// Campo de título do arquivo
  Widget _titleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('Título do arquivo'),
        TextField(
          controller: controller.titleTextController,
          decoration: const InputDecoration(
            hintText: "Nome do arquivo",
          ),
          onChanged: (value) => controller.validateInput(value),
        ),
      ],
    );
  }

  /// Botão de download
  Widget _downloadButton() {
    return ElevatedButton.icon(
      onPressed: () => controller.onPressChooseLocationAndDownload(context),
      icon: const Icon(Icons.download),
      label: const Text("Escolher Local e Baixar"),
    );
  }

  /// Mensagem de status
  Widget _statusMessage() {
    return ValueListenableBuilder(
      valueListenable: controller.message,
      builder: (context, value, child) => Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
