@echo off
setlocal EnableExtensions
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

call :run finalize_part_numbers.CATScript "Fix internal CATIA part numbers"
if errorlevel 1 exit /b 1
call :run repair_pedal_exact.CATScript "Repair pedal body to reference-equivalent geometry"
if errorlevel 1 exit /b 1
call :run assemble05.CATScript "Build Presentation 05 assembly"
if errorlevel 1 exit /b 1
call :run assemble06.CATScript "Build Presentation 06 final assembly"
if errorlevel 1 exit /b 1
call :run validate_project.CATScript "Run structural validation"
if errorlevel 1 exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -File "%REVIEW%\package_submission.ps1" -Root "%ROOT%"
if errorlevel 1 (
 echo WARNING: assembly completed but submission ZIP packaging failed.
 exit /b 1
)

echo.
echo =====================================================
echo COMPLETION SEQUENCE FINISHED
echo =====================================================
echo Final assembly: %ROOT%\Brake_Pedal_Assembly.CATProduct
echo Presentation 05: %ROOT%\Brake_Pedal_Assembly_05.CATProduct
echo Submission ZIP: %ROOT%\Brake_Pedal_Assembly_Submission.zip
echo Reports are in: %REVIEW%
echo.
echo Open Brake_Pedal_Assembly.CATProduct in CATIA and perform a final visual/clash check.
pause
exit /b 0

:run
set "MACRO=%~1"
set "LABEL=%~2"
echo.
echo --- %LABEL% ---
"%CSCRIPT%" //Nologo "%RUNNER%" "%MACRO%"
if errorlevel 1 (
 echo ERROR while running %MACRO%
 exit /b 1
)
exit /b 0
