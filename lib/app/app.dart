import 'package:flutter/material.dart';

import 'view/home_page.view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      home: const HomePageView(),
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}