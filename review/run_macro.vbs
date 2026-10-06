Option Explicit
Dim fso, here, root, tempPath, cfg, ts, cat, macroName
Set fso = CreateObject("Scripting.FileSystemObject")
here = fso.GetParentFolderName(WScript.ScriptFullName)
root = fso.GetParentFolderName(here)
tempPath = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%")
cfg = tempPath & "\CAD_Project_root.txt"
Set ts = fso.CreateTextFile(cfg, True)
ts.WriteLine root
ts.Close

If WScript.Arguments.Count < 1 Then
  WScript.Echo "Usage: run_macro.vbs macro.CATScript"
  WScript.Quit 2
End If
macroName = WScript.Arguments(0)

On Error Resume Next
Set cat = GetObject(, "CATIA.Application")
If Err.Number <> 0 Then
  WScript.Echo "ERROR: CATIA is not running. Start CATIA V5 and retry."
  WScript.Quit 3
End If
On Error GoTo 0

cat.SystemService.ExecuteScript here, 1, macroName, "CATMain", Array()
WScript.Echo "Macro completed: " & macroName
