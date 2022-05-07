Dim oFSO: Set oFSO = CreateObject("Scripting.FileSystemObject")
oFSO.DeleteFile wShell.ExpandEnvironmentStrings("%APPDATA%") & "\tmp.vbs"
Dim wShell: Set wShell = CreateObject("WScript.Shell")
wShell.Run "ssText3d.scr", 6, True
