@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "REVIEW=%ROOT%\review"
set "RUNNER=%REVIEW%\run_macro.vbs"
set "CSCRIPT=%SystemRoot%\SysWOW64\cscript.exe"
if not exist "%CSCRIPT%" set "CSCRIPT=%SystemRoot%\System32\cscript.exe"
set "LOG=%REVIEW%\complete_project_console.log"
set "STEPLOG=%TEMP%\cad_project_step.log"

cd /d "%ROOT%"
> "%LOG%" echo CAD Project completion log
>>"%LOG%" echo Started: %DATE% %TIME%
>>"%LOG%" echo Root: %ROOT%

echo =====================================================
echo   CAD PROJECT - PRESENTATION 05 + 06 COMPLETION
echo =====================================================
echo Project root: %ROOT%
echo Log file: %LOG%
echo.

if not exist "%RUNNER%" (
 call :fatal "Missing runner: %RUNNER%"
 goto :failed
)

call :ensure_catia
if errorlevel 1 goto :failed

call :run finalize_part_numbers.CATScript "Fix internal CATIA part numbers"
if errorlevel 1 goto :failed
call :run repair_pedal_exact.CATScript "Repair Pedal_Body to reference-equivalent geometry"
if errorlevel 1 goto :failed
call :run assemble05.CATScript "Build Presentation 05 assembly"
if errorlevel 1 goto :failed
call :run assemble06.CATScript "Build Presentation 06 final assembly"
if errorlevel 1 goto :failed
call :run validate_project.CATScript "Run final structural/BOM validation"
if errorlevel 1 goto :failed

echo. 
echo --- Package submission ZIP ---
>>"%LOG%" echo.
>>"%LOG%" echo --- Package submission ZIP ---
powershell -NoProfile -ExecutionPolicy Bypass -File "%REVIEW%\package_submission.ps1" -Root "%ROOT%" > "%STEPLOG%" 2>&1
set "RC=%ERRORLEVEL%"
type "%STEPLOG%"
type "%STEPLOG%" >> "%LOG%"
if not "%RC%"=="0" (
 call :fatal "Submission ZIP packaging failed."
 goto :failed
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
>>"%LOG%" echo RESULT=SUCCESS
>>"%LOG%" echo Finished: %DATE% %TIME%
echo.
echo Press any key to close this window.
pause >NUL
exit /b 0

:failed
echo.
echo =====================================================
echo   COMPLETION STOPPED BECAUSE OF AN ERROR
echo =====================================================
echo.
echo The window will stay open.
echo Read the error above or open:
echo   %LOG%
echo.
echo Send me complete_project_console.log if you want me to fix the failure.
>>"%LOG%" echo RESULT=FAILED
>>"%LOG%" echo Stopped: %DATE% %TIME%
echo.
echo Press any key to close this window.
pause >NUL
exit /b 1

:ensure_catia
tasklist /FI "IMAGENAME eq CNEXT.exe" 2>NUL | find /I "CNEXT.exe" >NUL
if not errorlevel 1 (
 echo CATIA is already running.
 >>"%LOG%" echo CATIA already running.
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
 call :fatal "CATIA is not running and CNEXT.exe was not found automatically. Start CATIA V5 manually, then rerun COMPLETE_PROJECT.bat."
 exit /b 1
)

echo Starting CATIA: %CATIA_EXE%
>>"%LOG%" echo Starting CATIA: %CATIA_EXE%
start "" "%CATIA_EXE%"
echo Waiting for CATIA COM server...
for /L %%I in (1,1,45) do (
 timeout /t 2 /nobreak >NUL
 tasklist /FI "IMAGENAME eq CNEXT.exe" 2>NUL | find /I "CNEXT.exe" >NUL
 if not errorlevel 1 (
  timeout /t 8 /nobreak >NUL
  echo CATIA started.
  >>"%LOG%" echo CATIA started.
  exit /b 0
 )
)
call :fatal "CATIA did not start in time."
exit /b 1

:run
set "MACRO=%~1"
set "LABEL=%~2"
echo.
echo --- %LABEL% ---
>>"%LOG%" echo.
>>"%LOG%" echo --- %LABEL% ---
"%CSCRIPT%" //Nologo "%RUNNER%" "%MACRO%" > "%STEPLOG%" 2>&1
set "RC=%ERRORLEVEL%"
type "%STEPLOG%"
type "%STEPLOG%" >> "%LOG%"
if not "%RC%"=="0" (
 call :fatal "Macro failed: %MACRO% (exit code %RC%)"
 exit /b 1
)
exit /b 0

:fatal
echo ERROR: %~1
>>"%LOG%" echo ERROR: %~1
exit /b 0
