import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_downloader/app/controller/home_page.controller.dart';
import 'package:youtube_downloader/app/utils/enum/type.enum.dart';
import 'package:youtube_downloader/app/utils/show_widget_preference.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final TextEditingController _urlController = TextEditingController();
  final HomePageController controller = HomePageController();
  
  String savePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _body()
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Row(
        children: [
          Icon(FontAwesomeIcons.youtube),
          SizedBox(width: 10),
          Text('YouTube Downloader'),
        ],
      ),
      elevation: 1,
      actions: [
        _buildSettingIcon(),
      ],
    );
  }

  Widget _body() {
    return ValueListenableBuilder(
      valueListenable: controller.message,
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _columLine(),
          _height,
          _listFormat(),
          _height,
          _title(),
          _height,
          _downloadBtn(),
          _height,
          _message()
        ],
      ),
    );
  }

  Widget get _height => const SizedBox(height: 20.0);

  Widget _columLine(){
    return Row(
      children: [
        Expanded(child: _fieldUrl()),
        _unionWidgetPasteClean()
      ],
    );
  }

  Widget _buildSettingIcon() {
    return IconButton(
      onPressed: () => controller.navigatePageSetting(context),
      icon: const Icon(Icons.settings)
    );
  }

  InputDecoration inputDecoration({required String label, String? errorText}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), // Borda arredondada
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Cor quando não está focado
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), // Cor e espessura ao focar
      ),
      errorText: errorText
    );
  }

  Widget _fieldUrl() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: _urlController,
        decoration: inputDecoration(label: 'Insira a URL do vídeo do YouTube'),
        onChanged: (value) => controller.getVideoInfo(
          url: _urlController.text,
          context: context,
        ),
      ),
    );
  }

  Widget _listFormat(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Escolha o forma da mídia: '),
          _format()
        ],
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

  Widget _title(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ValueListenableBuilder(
        valueListenable: controller.titleTextController,
        builder: (context, value, child) => TextField(
          controller: controller.titleTextController,
          decoration: inputDecoration(
            label: 'Título do vídeo',
            errorText: controller.errorText.value,
          ),
          onChanged: (value) => controller.validateInput(value)
        ),
      ),
    );
  }

  Widget _unionWidgetPasteClean() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cleanUlr(),
          const SizedBox(width: 15.0),
          _pasteUrl(),
        ]
      ),
    );
  }

  Widget _pasteUrl () {
    return ShowWidgetPreference(
      keyPreference: 'pasteButtonEnabled',
      child: ElevatedButton.icon(
        onPressed: () async => controller.getVideoInfo(url: _urlController.text = await FlutterClipboard.paste(), context: context),
        icon: const Icon(FontAwesomeIcons.paste),
        label: const Text('Colar'),
      ),
    );
  }

  Widget _cleanUlr () {
    return ShowWidgetPreference(
      keyPreference: 'clearButtonEnabled',
      child: ElevatedButton.icon(
        onPressed: () => _urlController.text = '',
        icon: const Icon(FontAwesomeIcons.broom),
        label: const Text('Limpar'),
      ),
    );
  }

  Widget _downloadBtn(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildChooseLocationAndDownloadButton(),
        const SizedBox(width: 15),
        _buildDownloadButton(),
      ],
    );
  }

  Widget _buildChooseLocationAndDownloadButton() {
    return ElevatedButton(
      onPressed: () => controller.onPressChooseLocationAndDownload(context),
      child: const Text('Escolher Local e Baixar'),
    );
  }

  Widget _buildDownloadButton() {
    return ShowWidgetPreference(
      keyPreference: 'utilizeSavePathButtonEnabled',
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () => controller.onPressDownload(context),
        child: const Text(
          'Baixar',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
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
