#ifndef UNICODE
#define UNICODE
#endif 

#include <iostream>
#include <windows.h>
#include <shellapi.h>
#include <tchar.h>
#include <strsafe.h>
#include <commctrl.h>

#define WM_TRAYICON         (WM_USER + 1)
#define TRAY_OPEN_APP       1001
#define TRAY_EXIT           1002


void StartOrSetFocused() {
  HWND tgHandle = FindWindow(L"TG_Stickers", NULL);
  if (tgHandle != 0) {
    SetForegroundWindow(tgHandle);
    return;
  }
  printf("Opening...");

  // Create process information struct
  PROCESS_INFORMATION pi;
  ZeroMemory(&pi, sizeof(PROCESS_INFORMATION));

  // Create startup information struct
  STARTUPINFO si;
  ZeroMemory(&si, sizeof(STARTUPINFO));
  si.cb = sizeof(STARTUPINFO);

  // Launch the process
  if (!CreateProcess(L"tgstickers.exe", NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
  {
      printf("Failed to create process\n");
  }

  // Close process and thread handles (we don't need them)
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {

  switch (msg) {
    case WM_TRAYICON: {
      switch (lParam) {
        case WM_LBUTTONUP:
          StartOrSetFocused();
          break;
        case WM_RBUTTONUP: {
          HMENU hMenu = CreatePopupMenu();

          AppendMenu(hMenu, MFT_STRING, TRAY_OPEN_APP, L"Open");
          AppendMenu(hMenu, MFT_STRING, TRAY_EXIT, L"Exit");

          POINT pt;
          GetCursorPos(&pt);
          SetForegroundWindow(hwnd);
          TrackPopupMenu(hMenu, TPM_BOTTOMALIGN | TPM_LEFTALIGN, pt.x, pt.y, 0, hwnd, NULL);
          PostMessage(hwnd, WM_NULL, 0, 0);

          DestroyMenu(hMenu);
          break;
        }
      }
      break;
    }
    case WM_COMMAND: {
      switch (wParam) {
        case TRAY_OPEN_APP:
          StartOrSetFocused();
          break;
         case TRAY_EXIT:
          PostQuitMessage(0);
      }
      break;
    }
    case WM_DESTROY:
      PostQuitMessage(0);
      break;
    default:
      return DefWindowProc(hwnd, msg, wParam, lParam);
  }
  return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

  if (FindWindow(L"TG_Stickers_tray", NULL) != 0) return 0;

  RegisterHotKey(
    NULL,
    1,
    MOD_WIN | MOD_NOREPEAT,
    VK_OEM_MINUS);

  // create the window
  WNDCLASS wc = {};
  wc.lpfnWndProc = WndProc;
  wc.hInstance = hInstance;
  wc.lpszClassName = L"TG_Stickers_tray";
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(0, L"TG_Stickers_tray", L"TGStickers tray", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL);
  if (!hwnd) {
    return 0;
  }

  // create the system tray icon
  NOTIFYICONDATA nid = {};
  nid.cbSize = sizeof(nid);
  nid.hWnd = hwnd;
  nid.uID = 1;
  nid.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(950));
  nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
  wcscpy_s(nid.szTip, L"TGStickers tray");
  nid.uCallbackMessage = WM_TRAYICON;

  // add the system tray icon to the taskbar
  Shell_NotifyIcon(NIM_ADD, &nid);

  // message loop
  MSG msg = {};
  while (GetMessage(&msg, NULL, 0, 0)) {
    if (msg.message == WM_HOTKEY) {
      StartOrSetFocused();
    } else {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }

  // remove the system tray icon
  Shell_NotifyIcon(NIM_DELETE, &nid);

  return msg.wParam;
}

