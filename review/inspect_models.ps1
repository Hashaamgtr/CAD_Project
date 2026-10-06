$ErrorActionPreference = 'Stop'
$root = 'C:\Users\Hashaam\Documents\CAD_Project'
$cat = [Runtime.InteropServices.Marshal]::GetActiveObject('CATIA.Application')
function Read-Container($obj, $depth) {
    if ($depth -gt 8) { return }
    foreach ($collection in @('Bodies','HybridBodies','OrderedGeometricalSets','HybridShapes','Shapes','Sketches')) {
        try { $items = $obj.$collection; $count = $items.Count } catch { continue }
        for ($j=1; $j -le $count; $j++) {
            $item = $items.Item($j)
            ('  ' * $depth) + $collection + ': ' + $item.Name
            if ($collection -in @('Bodies','HybridBodies','OrderedGeometricalSets')) { Read-Container $item ($depth+1) }
            if ($item.Name -eq 'CenterPoint') {
                try { 'CENTERPOINT: ' + $item.X.Value + ', ' + $item.Y.Value + ', ' + $item.Z.Value } catch {}
            }
        }
    }
}
foreach ($file in Get-ChildItem -LiteralPath "$root\source_copies" -Filter '*.CATPart') {
    $doc = $cat.Documents.Open($file.FullName)
    $part = $doc.Part
    $report = @('FILE: ' + $file.Name, 'PART: ' + $part.Name)
    $report += Read-Container $part 0
    try { $report += 'UP_TO_DATE: ' + $part.IsUpToDate($part) } catch { $report += 'UPDATE_CHECK: ' + $_.Exception.Message }
    $report | Set-Content -LiteralPath "$root\review\$($file.BaseName)_tree.txt"
    $cat.ActiveWindow.ActiveViewer.Reframe()
    $cat.ActiveWindow.ActiveViewer.CaptureToFile(4, "$root\review\$($file.BaseName).bmp")
    $doc.Close()
    $report
}
