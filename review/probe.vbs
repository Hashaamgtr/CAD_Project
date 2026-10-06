On Error Resume Next
Set cat = GetObject(, "CATIA.Application")
WScript.Echo "GetObject " & Err.Number & " " & Err.Description
Err.Clear
WScript.Echo "Name " & cat.Name
WScript.Echo "Name error " & Err.Number & " " & Err.Description
Err.Clear
Set docs = cat.Documents
WScript.Echo "Documents error " & Err.Number & " " & Err.Description
Err.Clear
WScript.Echo "Count " & docs.Count
WScript.Echo "Count error " & Err.Number & " " & Err.Description
