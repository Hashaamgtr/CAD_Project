Set cat = GetObject(, "CATIA.Application")
cat.SystemService.ExecuteScript "C:\Users\Hashaam\Documents\CAD_Project\review", 1, WScript.Arguments(0), "CATMain", Array()
WScript.Echo "Macro completed: " & WScript.Arguments(0)
