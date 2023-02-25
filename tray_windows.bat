mkdir tray\windows\temp
mkdir build\windows\runner\Debug
mkdir build\windows\runner\Release
windres tray\windows\icon.rc tray\windows\temp\icon.o
g++ tray\windows\systemtray.cpp tray\windows\temp\icon.o -o build\windows\runner\Debug\tgs-tray.exe -lgdi32 -mwindows
copy build\windows\runner\Debug\tgs-tray.exe build\windows\runner\Release\tgs-tray.exe

@ECHO =============================
@ECHO   systemtray build finished
@ECHO =============================
