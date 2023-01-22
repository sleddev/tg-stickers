import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

import '../../../providers/config_provider.dart';
import '../../../providers/download_provider.dart';
import 'download_button.dart';
import 'input_box.dart';

class DownloadTab extends StatelessWidget {
  const DownloadTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final download = Provider.of<DownloadProvider>(context);
    final config = Provider.of<ConfigProvider>(context);

    final linkController = TextEditingController();
    final tokenController = TextEditingController();
    
    Future<void> getToken() async {
      tokenController.text = (await config.getConfig()).token;
    }
    getToken();

    Map<String, Widget> statusWidgets = {
      'info': Text('Getting pack info', style: TextStyle(
        color: theme.infoColor,
        fontSize: 20
      )),
      'download': Text('Downloading', style: TextStyle(
        color: theme.downloadColor,
        fontSize: 20
      )),
      'convert': Text('Converting', style: TextStyle(
        color: theme.convertColor,
        fontSize: 20
      )),
      'done': Text('Done!', style: TextStyle(
        color: theme.doneColor,
        fontWeight: FontWeight.w500,
        fontSize: 20
      )),
      'error': Text(download.error ?? 'Something went wrong', style: TextStyle(
        color: theme.errorColor,
        fontWeight: FontWeight.w500,
        fontSize: 20
      ))
    };

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'LINK TO STICKER PACK',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: InputBox(controller: linkController, hint: 'https://t.me/addstickers/hiostickerpack',),
          ),
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'TELEGRAM TOKEN',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: InputBox(controller: tokenController, hint: '1234567890:AsDFgHjklQweRtY...',),
          ),
          Expanded(
            child: Center(
              child: statusWidgets[download.status]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.bottomRight,
              child: DownloadButton(onTap: () async {
                download.downloadPack(linkController.text, tokenController.text);
              }),
            ),
          )
        ],
      ),
    );
  }
}