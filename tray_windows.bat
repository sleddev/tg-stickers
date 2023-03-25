taskkill /f /fi "windowtitle eq TGStickers tray"
mkdir tray\windows\temp
mkdir build\windows\runner\Debug
mkdir build\windows\runner\Release
windres tray\windows\icon.rc tray\windows\temp\icon.o
g++ -static tray\windows\systemtray.cpp tray\windows\temp\icon.o -o build\windows\runner\Debug\tgs-tray.exe -lgdi32 -mwindows
copy build\windows\runner\Debug\tgs-tray.exe build\windows\runner\Release\tgs-tray.exe
copy tray\windows\vcruntime140_1.dll build\windows\runner\Debug\vcruntime140_1.dll
copy build\windows\runner\Debug\vcruntime140_1.dll build\windows\runner\Release\vcruntime140_1.dll

@ECHO =============================
@ECHO   systemtray build finished
@ECHO =============================
