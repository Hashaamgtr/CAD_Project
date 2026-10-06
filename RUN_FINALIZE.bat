@echo off
setlocal
set ROOT=C:\Users\Hashaam\Documents\CAD_Project
set RUNNER=%ROOT%\review\run_macro.vbs
set CSCRIPT=C:\Windows\SysWOW64\cscript.exe

echo.
echo CAD Project finalization helper
echo ===============================
echo CATIA V5 must already be running.
echo.

if not exist "%RUNNER%" (
  echo ERROR: runner not found: %RUNNER%
  exit /b 1
)

echo [1/3] Fixing internal part numbers...
"%CSCRIPT%" //Nologo "%RUNNER%" finalize_part_numbers.CATScript
if errorlevel 1 exit /b %errorlevel%

echo [2/3] Building Presentation 05 assembly...
"%CSCRIPT%" //Nologo "%RUNNER%" assemble05.CATScript
if errorlevel 1 exit /b %errorlevel%

echo [3/3] Running structural validation...
"%CSCRIPT%" //Nologo "%RUNNER%" validate_project.CATScript
if errorlevel 1 exit /b %errorlevel%

echo.
echo Finished automated steps.
echo Review:
echo   review\part_number_finalize_report.txt
echo   review\task05_report.txt
echo   review\final_validation_report.txt
echo.
echo IMPORTANT: Presentation 06 still requires CATIA-native geometric correction of
echo Pedal_Body and final placement/interference validation before submission.
endlocal
