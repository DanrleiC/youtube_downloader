import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/configs/theme/app_data.theme.dart';

import 'view/home_page.view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      home: const HomePageView(),
      themeMode: ThemeMode.system,
      darkTheme: AppDataTheme.dark,
     // theme: AppDataTheme.light,
      debugShowCheckedModeBanner: false,
    );
  }
}