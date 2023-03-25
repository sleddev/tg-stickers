## TG Stickers Everywhere

Use Telegram stickers in other applications (for example Discord, Messenger, Twitter DMs, Instagram DMs).

![WIP Screenshot](https://i.imgur.com/99B0axW.png)

*This project is WIP, and provided as is. 
I'm developing on Windows, so it's only actively tested on Windows. Might or might not work well on linux. Never tested on masOS (maybe works, probably not)*

### Installing
Extract the [latest release](https://github.com/CroatianHusky/tg-stickers/releases/latest) zip, and run `tgstickers.exe`. You can create a shortcut for easy access.

### Getting started
![add button screenshot](https://i.imgur.com/Zj6PifX.png)

After first launch, click the add button to add your first sticker pack.

To add a local sticker pack, enter a title (will be displayed on the main page), a name (the last segment of the sticker pack link, for example: `hiostickerpack` for `https://t.me/addstickers/hiostickerpack`), locate the sticker pack folder, and choose a cover photo.

To download a sticker pack from Telegram, enter the link or name of the pack and your Telegram bot token.

Getting a bot token:
1) Find [@BotFather](https://t.me/BotFather) on Telegram
2) Send the message `/newbot`
3) Enter a name (whatever you want)
4) Enter a username (anything you want, as long as it isn't taken)
5) You will receive a token, looks something like `1234567890:AsdFGhJklQwERtzUioPYxCVbnM...` 
**don't share this with anyone**

### Usage
Click a sticker pack to select it, and then click on a sticker to copy it.

Right click on a sticker to bring up a bigger preview, then either click on the sticker to copy, or right click again to hide the preview.

Right click on a sticker pack logo to open a Pack Menu, where you can reorder or delete the packs.

Press `Windows` + `-` to open the application if the background service is running (started automatically when you launch the app, and can be closed from system tray icons. The background service consumes around 1MB or memory, and should have no impact on performance).

You can change between sticker packs using the `PageUp`, `PageDown`, `Home`, and `End` buttons

### Building from source
Prerequisites:
- [Flutter](https://docs.flutter.dev/get-started/install)
- [Rust](https://www.rust-lang.org/tools/install)
- (on Windows) [MinGW-w64](https://github.com/skeeto/w64devkit)

Steps:
1) clone the repo using `git clone https://github.com/CroatianHusky/tg-stickers.git`
2) Run `flutter pub get`

#### Windows
3) Command Prompt: `flutter build windows && .\tray_windows.bat` <br/> 
or PowerShell: `flutter build windows | .\tray_windows.bat`

#### Linux
3) Run `flutter build linux`


<hr/>

Please note: this is my first Flutter project, and it is in no way an example of the Flutter best practices.