param([Parameter(Mandatory=$true)][string]$Root)
$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path $Root).Path
$stage = Join-Path $Root 'submission'
$zip = Join-Path $Root 'Brake_Pedal_Assembly_Submission.zip'
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage | Out-Null
New-Item -ItemType Directory -Path (Join-Path $stage 'final_parts') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $stage 'parts') | Out-Null

$required = @(
 'Brake_Pedal_Assembly.CATProduct',
 'Brake_Pedal_Assembly_05.CATProduct'
)
foreach ($name in $required) {
 $src=Join-Path $Root $name
 if (!(Test-Path $src)) { throw "Missing required output: $src" }
 Copy-Item $src $stage
}
Copy-Item (Join-Path $Root 'final_parts\*.CATPart') (Join-Path $stage 'final_parts')
Copy-Item (Join-Path $Root 'parts\*.CATPart') (Join-Path $stage 'parts')
Copy-Item (Join-Path $Root 'parts\*.CATProduct') (Join-Path $stage 'parts')

@'
Brake Pedal Assembly submission package

Main final assembly: Brake_Pedal_Assembly.CATProduct
Presentation 05 checkpoint: Brake_Pedal_Assembly_05.CATProduct
Live parts: final_parts\
Imported/dead/native dependencies: parts\

The full project repository retains source STEP files, automation, reports and backups.
'@ | Set-Content -Encoding UTF8 (Join-Path $stage 'README_SUBMISSION.txt')

if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -CompressionLevel Optimal
Write-Host "Created $zip"
