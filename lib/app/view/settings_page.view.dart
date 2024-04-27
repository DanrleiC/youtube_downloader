import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_downloader/app/controller/settings_page.controller.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});
  
  @override
  createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final controller = SettingsPageController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init () async {
    controller.prefs = await SharedPreferences.getInstance();
    await controller.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: _body(),
    );
  }

  Widget _body () {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildToggle(
              title: 'Ativar botão Limpar',
              value: controller.clearButtonEnabled,
              onChanged: (value) => controller.setClearButtonEnabled(value),
            ),
            _buildToggle(
              title: 'Ativar botão Colar',
              value: controller.pasteButtonEnabled,
              onChanged: (value) => controller.setPasteButtonEnabled(value),
            ),
            _buildToggle(
              title: 'Utilizar Local de salvamento',
              value: controller.utilizeSavePathButtonEnabled,
              onChanged: (value) => controller.setUtilizePickSaveLocationButtonEnabled(value, context),
            ),
            _handleSaveLocationButtonPress()
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({required String title, required ValueNotifier<bool> value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Text(title),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: value,
          builder: (context, value, child) {
            return Switch(
              value: value,
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }

  Widget _handleSaveLocationButtonPress() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async => controller.onClickSaveLocationButtonPress(context),
                child: const Text('Selecionar Local de Salvamento'),
              ),
              _cleanButtonSaveLocationButtonPress()
            ],
          ),
        ),
        ValueListenableBuilder<String>(
          valueListenable: controller.savePath,
          builder: (context, value, child) {
            return Text('Local de Salvamento: $value');
          },
        ),
      ],
    );
  }

  Widget _cleanButtonSaveLocationButtonPress () {
    return IconButton(
      icon: const Icon(Icons.delete_forever_rounded),
      isSelected: true,
      onPressed: () => controller.setClearSaveLocation(),
    );
  }
}