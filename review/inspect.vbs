Option Explicit
Dim cat, fso, root, folder, f, d, report, p, i
Set cat = GetObject(, "CATIA.Application")
Set fso = CreateObject("Scripting.FileSystemObject")
root = "C:\Users\Hashaam\Documents\CAD_Project"
For i = 1 To cat.Documents.Count
  WScript.Echo "OPEN: " & cat.Documents.Item(i).FullName
Next
Set folder = fso.GetFolder(root & "\source_copies")
For Each f In folder.Files
 If LCase(fso.GetExtensionName(f.Name)) = "catpart" Then
  Set d = cat.Documents.Open(f.Path)
  Set p = d.Part
  Set report = fso.CreateTextFile(root & "\review\" & fso.GetBaseName(f.Name) & "_tree.txt", True)
  report.WriteLine "FILE: " & f.Name
  report.WriteLine "PART: " & p.Name
  Walk p, 0
  On Error Resume Next
  report.WriteLine "UP_TO_DATE: " & p.IsUpToDate(p)
  cat.ActiveWindow.ActiveViewer.Reframe
  cat.ActiveWindow.ActiveViewer.CaptureToFile 4, root & "\review\" & fso.GetBaseName(f.Name) & ".bmp"
  On Error GoTo 0
  report.Close
  d.Close
  WScript.Echo "Inspected " & f.Name
 End If
Next
Sub Walk(obj, depth)
 Dim kinds, kind, col, child, j
 If depth > 8 Then Exit Sub
 kinds = Array("Bodies", "HybridBodies", "OrderedGeometricalSets", "HybridShapes", "Shapes", "Sketches")
 For Each kind In kinds
  Set col = Nothing
  On Error Resume Next
  Select Case kind
   Case "Bodies": Set col = obj.Bodies
   Case "HybridBodies": Set col = obj.HybridBodies
   Case "OrderedGeometricalSets": Set col = obj.OrderedGeometricalSets
   Case "HybridShapes": Set col = obj.HybridShapes
   Case "Shapes": Set col = obj.Shapes
   Case "Sketches": Set col = obj.Sketches
  End Select
  On Error GoTo 0
  If Not col Is Nothing Then
   For j = 1 To col.Count
    Set child = col.Item(j)
    report.WriteLine Space(depth * 2) & kind & ": " & child.Name & " [" & TypeName(child) & "]"
    If kind = "Bodies" Or kind = "HybridBodies" Or kind = "OrderedGeometricalSets" Then Walk child, depth + 1
    If child.Name = "CenterPoint" Then
      On Error Resume Next
      report.WriteLine "CENTERPOINT: " & child.X.Value & ", " & child.Y.Value & ", " & child.Z.Value
      On Error GoTo 0
    End If
   Next
  End If
 Next
End Sub
