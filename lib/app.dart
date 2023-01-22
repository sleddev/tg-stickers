import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tgstickers/pages/home/home.dart';
import 'package:tgstickers/providers/add_provider.dart';
import 'package:tgstickers/providers/clipboard_provider.dart';
import 'package:tgstickers/providers/config_provider.dart';
import 'package:tgstickers/providers/sticker_provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';
import 'package:tgstickers/providers/toast_provider.dart';
import 'package:tgstickers/providers/window_provider.dart';

import 'providers/download_provider.dart';

class App extends StatelessWidget {
  final StickerProvider stickers;
  final ConfigProvider configProvider;

  const App({required this.configProvider, required this.stickers, super.key});

  @override
  Widget build(BuildContext context) {
    final ToastProvider toastProvider = ToastProvider();
    final ClipboardProvider clipboardProvider = ClipboardProvider(toastProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigProvider>(create: (_) => configProvider),
        ChangeNotifierProvider<StickerProvider>(create: (_) => stickers),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<ToastProvider>(create: (_) => toastProvider),
        ChangeNotifierProvider<AddProvider>(create: (_) => AddProvider()),
        ChangeNotifierProvider<DownloadProvider>(create: (_) => DownloadProvider(config: configProvider, stickers: stickers)),
        Provider<WindowProvider>(create: (_) => WindowProvider(stickers: stickers)),
        Provider<ClipboardProvider>(create: (_) => clipboardProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TG Stickers',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: const Scaffold(
          backgroundColor: Color(0xFF333333),
          body: HomePage(),
        ),
      ),
    );
  }
}