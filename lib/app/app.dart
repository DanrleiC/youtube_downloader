import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/configs/theme/app_theme.dart';

import 'view/home_page.view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      home: const HomePageView(),
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    );
  }
}