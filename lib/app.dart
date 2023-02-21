import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/keyboard_provider.dart';

import 'pages/home/home.dart';
import 'pages/settings/settings.dart';

import 'providers/add_provider.dart';
import 'providers/clipboard_provider.dart';
import 'providers/config_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/sticker_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/toast_provider.dart';
import 'providers/window_provider.dart';
import 'providers/download_provider.dart';

//TODO: stickerpack update checker
//TODO: stickerpack folder not found message
//TODO: edit option in PackMenu

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
        ChangeNotifierProvider<WindowProvider>(create: (_) => WindowProvider(stickers: stickers)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(configProvider)),
        Provider<ClipboardProvider>(create: (_) => clipboardProvider),
        Provider<KeyboardProvider>(create: (_) => KeyboardProvider(stickers: stickers, clipboard: clipboardProvider)),
      ],
      builder: (context, child) {
        final window = Provider.of<WindowProvider>(context);
        final theme = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TG Stickers',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: theme.selectionColor
            )
          ),
          home: Scaffold(
            backgroundColor: const Color(0xFF333333),
            body: ValueListenableBuilder(
              valueListenable: window.settingsOpen,
              builder: (context, value, child) => value ? const SettingsPage() : const HomePage(),
            ),
          ),
        );
      }
    );
  }
}