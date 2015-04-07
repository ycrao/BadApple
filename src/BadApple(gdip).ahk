/*
脚本名称：	BadApple(gdip)
脚本编码：	UTF-8(with BOM)
脚本说明：	BadApple字符动画演示（gdip版），写这个代码是看到网上有C语言版BadApple，于是是用AHK+GDIP写了这个。
            [C语言版BadApple下载链接]
            https://code.google.com/p/c-programming-language/downloads/detail?name=BadAppleV2.0(%E9%99%84%E6%BA%90%E7%A0%81).zip&can=2&q=
            [C语言版BadApple介绍链接]
            http://tieba.baidu.com/f?ct=335675392&tn=baiduPostBrowser&sc=22245995159&z=1743226954
脚本版本：	1.0
脚本作者：	飞扬网络工作室 (fysoft)
作者官网：	http://raoyc.com/fysoft/
交流Q群：	260655062
运行环境：	作者在编码或测试此脚本时所使用的运行环境为 Windows XP SP3 + AutoHotkey(L) v1.1.09.03，其它相异于此运行环境的，请自行测试脚本兼容性问题
版权申明：	非商业使用，仅供学习与演示
备注信息：	本源码使用到 Tic所写的gdip库（gdip.ahk)，并参考了Tic所提供的样例程序。
            [gdip库及样例来源于Autohotkey英文官网]
            http://www.autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/
*/
#SingleInstance, Force
#NoEnv
SendMode Input 
SetWorkingDir %A_ScriptDir% 
SetBatchLines, -1
#Include, Gdip.ahk
If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
OnExit, Exit

Width := 1100, Height := 748
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()
Font = Courier New
If !Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
mp3file = %A_ScriptDir%/BadApple.mp3
SoundPlay, %mp3file%
n := 0
SetTimer, Update, 8
Return
WM_LBUTTONDOWN()
{
   PostMessage, 0xA1, 2
}

Exit:
Gdip_Shutdown(pToken)
ExitApp
Return

Update:
n++
if(n<=6480)
{
   hbm := CreateDIBSection(Width, Height)
   hdc := CreateCompatibleDC()
   obm := SelectObject(hdc, hbm)
   G := Gdip_GraphicsFromHDC(hdc)
   Gdip_SetSmoothingMode(G, 4)
   pBrush := Gdip_BrushCreateSolid(0xff000000)
   Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 20)
   Gdip_DeleteBrush(pBrush)
   OnMessage(0x201, "WM_LBUTTONDOWN")
   Options = x5p y5p w1000p Neart cffff0000 r4 s10
   framespath = %A_ScriptDir%/frames
   FileRead, pic_, %framespath%/frames_%n%.txt
   Gdip_TextToGraphics(G, pic_, Options, Font, Width, Height)
   UpdateLayeredWindow(hwnd1, hdc, (A_ScreenWidth-Width)//2, (A_ScreenHeight-Height)//2, Width, Height)
   SelectObject(hdc, obm)
   DeleteObject(hbm)
   DeleteDC(hdc)
   Gdip_DeleteGraphics(G)
}