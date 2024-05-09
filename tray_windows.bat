taskkill /f /fi "windowtitle eq TGStickers tray"
mkdir tray\windows\temp
mkdir build\windows\x64\runner\Debug
mkdir build\windows\x64\runner\Release
windres tray\windows\icon.rc tray\windows\temp\icon.o
g++ -static tray\windows\systemtray.cpp tray\windows\temp\icon.o -o build\windows\x64\runner\Debug\tgs-tray.exe -lgdi32 -mwindows
copy build\windows\x64\runner\Debug\tgs-tray.exe build\windows\x64\runner\Release\tgs-tray.exe
copy tray\windows\vcruntime140_1.dll build\windows\x64\runner\Debug\vcruntime140_1.dll
copy build\windows\runner\Debug\vcruntime140_1.dll build\windows\x64\runner\Release\vcruntime140_1.dll

@ECHO =============================
@ECHO   systemtray build finished
@ECHO =============================
