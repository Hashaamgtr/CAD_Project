@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "REVIEW=%ROOT%\review"
set "RUNNER=%REVIEW%\run_macro.vbs"
set "CSCRIPT=%SystemRoot%\SysWOW64\cscript.exe"
if not exist "%CSCRIPT%" set "CSCRIPT=%SystemRoot%\System32\cscript.exe"

cd /d "%ROOT%"
echo =====================================================
echo   CAD PROJECT - PRESENTATION 05 + 06 COMPLETION
echo =====================================================
echo Project root: %ROOT%
echo.

if not exist "%RUNNER%" (
 echo ERROR: Missing %RUNNER%
 exit /b 2
)

call :ensure_catia
if errorlevel 1 exit /b 1

call :run finalize_part_numbers.CATScript "Fix internal CATIA part numbers"
if errorlevel 1 exit /b 1
call :run repair_pedal_exact.CATScript "Repair Pedal_Body to reference-equivalent geometry"
if errorlevel 1 exit /b 1
call :run assemble05.CATScript "Build Presentation 05 assembly"
if errorlevel 1 exit /b 1
call :run assemble06.CATScript "Build Presentation 06 final assembly"
if errorlevel 1 exit /b 1
call :run validate_project.CATScript "Run final structural/BOM validation"
if errorlevel 1 exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -File "%REVIEW%\package_submission.ps1" -Root "%ROOT%"
if errorlevel 1 (
 echo ERROR: assemblies were built but submission ZIP packaging failed.
 exit /b 1
)

echo.
echo =====================================================
echo   AUTOMATED COMPLETION FINISHED
echo =====================================================
echo Presentation 05:
echo   %ROOT%\Brake_Pedal_Assembly_05.CATProduct
echo Presentation 06:
echo   %ROOT%\Brake_Pedal_Assembly.CATProduct
echo Submission:
echo   %ROOT%\Brake_Pedal_Assembly_Submission.zip
echo Validation:
echo   %REVIEW%\final_validation_report.txt
echo.
echo CATIA has generated the native deliverables.
echo Inspect Task05_Assembly.bmp and Task06_Assembly.bmp plus the final
echo assembly once before submitting, especially for visual interference.
echo.
pause
exit /b 0

:ensure_catia
tasklist /FI "IMAGENAME eq CNEXT.exe" 2>NUL | find /I "CNEXT.exe" >NUL
if not errorlevel 1 (
 echo CATIA is already running.
 exit /b 0
)

set "CATIA_EXE="
for %%P in (
 "C:\Program Files (x86)\Dassault Systemes\B21\intel_a\code\bin\CNEXT.exe"
 "C:\Program Files\Dassault Systemes\B21\win_b64\code\bin\CNEXT.exe"
 "C:\Program Files\Dassault Systemes\B22\win_b64\code\bin\CNEXT.exe"
 "C:\Program Files\Dassault Systemes\B23\win_b64\code\bin\CNEXT.exe"
) do (
 if exist "%%~P" if not defined CATIA_EXE set "CATIA_EXE=%%~P"
)

if not defined CATIA_EXE (
 echo ERROR: CATIA is not running and CNEXT.exe was not found automatically.
 echo Start CATIA V5 manually, then run this file again.
 exit /b 1
)

echo Starting CATIA: %CATIA_EXE%
start "" "%CATIA_EXE%"
echo Waiting for CATIA COM server...
for /L %%I in (1,1,45) do (
 timeout /t 2 /nobreak >NUL
 tasklist /FI "IMAGENAME eq CNEXT.exe" 2>NUL | find /I "CNEXT.exe" >NUL
 if not errorlevel 1 (
  timeout /t 8 /nobreak >NUL
  echo CATIA started.
  exit /b 0
 )
)
echo ERROR: CATIA did not start in time.
exit /b 1

:run
set "MACRO=%~1"
set "LABEL=%~2"
echo.
echo --- %LABEL% ---
"%CSCRIPT%" //Nologo "%RUNNER%" "%MACRO%"
if errorlevel 1 (
 echo ERROR while running %MACRO%
 echo Check the corresponding report in %REVIEW%.
 exit /b 1
)
exit /b 0
