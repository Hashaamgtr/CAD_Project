Set cat = GetObject(, "CATIA.Application")
cat.SystemService.ExecuteScript "C:\Users\Hashaam\Documents\CAD_Project\review", 1, "inspect.CATScript", "CATMain", Array()
WScript.Echo "Macro completed"
