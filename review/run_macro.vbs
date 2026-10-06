Option Explicit
Dim fso,sh,reviewDir,root,tmp,cfg,ts,cat,macroName
Set fso=CreateObject("Scripting.FileSystemObject")
Set sh=CreateObject("WScript.Shell")
reviewDir=fso.GetParentFolderName(WScript.ScriptFullName)
root=fso.GetParentFolderName(reviewDir)
tmp=sh.ExpandEnvironmentStrings("%TEMP%")
cfg=tmp & "\CAD_Project_root.txt"
Set ts=fso.CreateTextFile(cfg,True)
ts.WriteLine root
ts.Close

If WScript.Arguments.Count<1 Then
 WScript.Echo "Usage: run_macro.vbs macro.CATScript"
 WScript.Quit 2
End If
macroName=WScript.Arguments(0)

On Error Resume Next
Set cat=GetObject(,"CATIA.Application")
If cat Is Nothing Then
 Err.Clear
 Set cat=CreateObject("CATIA.Application")
End If
If Err.Number<>0 Or cat Is Nothing Then
 WScript.Echo "ERROR: CATIA could not be started/attached: " & Err.Description
 WScript.Quit 3
End If
On Error GoTo 0
cat.Visible=True
cat.SystemService.ExecuteScript reviewDir,1,macroName,"CATMain",Array()
WScript.Echo "Macro completed: " & macroName
