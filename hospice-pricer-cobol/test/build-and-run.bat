@echo off
REM ==========================================================================
REM build-and-run.bat - Build and Run Hospice Pricer using GnuCOBOL on Windows
REM
REM Usage: test\build-and-run.bat (from the project root)
REM ==========================================================================

setlocal enabledelayedexpansion

echo ==========================================
echo  Hospice Pricer - GnuCOBOL Build and Run
echo ==========================================
echo.

REM --- Set directories ---
set "PROJDIR=%~dp0.."
set "GCDIR=%PROJDIR%\tools\gnucobol32"
set "TESTDIR=%PROJDIR%\test"
set "BUILDDIR=%PROJDIR%\build"
set "RUNDIR=%PROJDIR%\run"
set "COPYDIR=%PROJDIR%\build\copy"

REM --- Setup GnuCOBOL environment ---
call "%GCDIR%\set_env.cmd"

REM --- Create directories ---
if not exist "%BUILDDIR%" mkdir "%BUILDDIR%"
if not exist "%RUNDIR%" mkdir "%RUNDIR%"
if not exist "%COPYDIR%" mkdir "%COPYDIR%"

echo.
echo [1/7] Preparing copybook HOSPRATE...
REM Strip 6-digit line numbers from HOSPRATE (replace with 6 spaces)
REM Using PowerShell for sed-like behavior on Windows
powershell -Command "(Get-Content '%PROJDIR%\HOSPRATE') | ForEach-Object { if ($_ -match '^\d{6}') { '      ' + $_.Substring(6) } else { $_ } } | Set-Content '%COPYDIR%\HOSPRATE.cpy' -Encoding ASCII"
echo   -^> %COPYDIR%\HOSPRATE.cpy

echo.
echo [2/7] Preparing source files (stripping line numbers)...
powershell -Command "(Get-Content '%PROJDIR%\HOSPR210') | ForEach-Object { if ($_ -match '^\d{6}') { '      ' + $_.Substring(6) } else { $_ } } | Set-Content '%BUILDDIR%\HOSPR210.cbl' -Encoding ASCII"
powershell -Command "(Get-Content '%PROJDIR%\HOSDR210') | ForEach-Object { if ($_ -match '^\d{6}') { '      ' + $_.Substring(6) } else { $_ } } | Set-Content '%BUILDDIR%\HOSDR210.cbl' -Encoding ASCII"

REM Fix COPY HOSPRATE statement to use .cpy extension
powershell -Command "(Get-Content '%BUILDDIR%\HOSPR210.cbl') -replace 'COPY HOSPRATE\.', 'COPY \"HOSPRATE.cpy\".' | Set-Content '%BUILDDIR%\HOSPR210.cbl' -Encoding ASCII"

echo   -^> %BUILDDIR%\HOSPR210.cbl
echo   -^> %BUILDDIR%\HOSDR210.cbl

echo.
echo [3/7] Compiling HOSPR210 (Pricer module)...
cobc -fixed -std=ibm -m -I "%COPYDIR%" -o "%BUILDDIR%\HOSPR210.dll" "%BUILDDIR%\HOSPR210.cbl"
if errorlevel 1 (
    echo ERROR: Failed to compile HOSPR210
    goto :error
)
echo   -^> %BUILDDIR%\HOSPR210.dll

echo.
echo [4/7] Compiling HOSDR210 (Driver module)...
cobc -fixed -std=ibm -m -I "%COPYDIR%" -o "%BUILDDIR%\HOSDR210.dll" "%BUILDDIR%\HOSDR210.cbl"
if errorlevel 1 (
    echo ERROR: Failed to compile HOSDR210
    goto :error
)
echo   -^> %BUILDDIR%\HOSDR210.dll

echo.
echo [5/7] Compiling GENDATA (test data generator)...
cobc -fixed -x -o "%BUILDDIR%\GENDATA.exe" "%TESTDIR%\GENDATA.cbl"
if errorlevel 1 (
    echo ERROR: Failed to compile GENDATA
    goto :error
)
echo   -^> %BUILDDIR%\GENDATA.exe

echo.
echo [6/7] Compiling HOSOP210 (batch test driver)...
cobc -fixed -x -o "%BUILDDIR%\HOSOP210.exe" "%TESTDIR%\HOSOP210.cbl"
if errorlevel 1 (
    echo ERROR: Failed to compile HOSOP210
    goto :error
)
echo   -^> %BUILDDIR%\HOSOP210.exe

echo.
echo ==========================================
echo  Build Complete! Now running tests...
echo ==========================================
echo.

REM --- Switch to run directory ---
cd /d "%RUNDIR%"

REM --- Set runtime library path so HOSOP210 can find HOSDR210/HOSPR210 ---
set "COB_LIBRARY_PATH=%BUILDDIR%"

echo [7a] Generating test data...
"%BUILDDIR%\GENDATA.exe"
if errorlevel 1 (
    echo ERROR: GENDATA failed
    goto :error
)

REM --- Copy CBSA data file ---
echo.
echo [7b] Preparing CBSA data file...
copy /Y "%PROJDIR%\CBSA2021" "%RUNDIR%\CBSAFILE" >nul
echo   CBSA data copied.

echo.
echo [7c] Running Hospice Pricer...
echo ------------------------------------------
"%BUILDDIR%\HOSOP210.exe"
echo ------------------------------------------

echo.
echo [7d] Results from RATEFILE:
echo.
if exist "%RUNDIR%\RATEFILE" (
    echo  Bill#  Provider  FromDate  RTC  PayTotal
    echo  -----  --------  --------  ---  --------
    setlocal enabledelayedexpansion
    set /a linenum=0
    for /f "usebackq delims=" %%L in ("%RUNDIR%\RATEFILE") do (
        set /a linenum+=1
        set "line=%%L"
        REM Extract fields from 315-byte record:
        REM ProvNo at pos 11-16, FromDate at pos 17-24, PayTotal at pos 243-250, RTC at pos 251-252
        echo   !linenum!. %%L
    )
    endlocal
) else (
    echo   No RATEFILE generated.
)

echo.
echo ==========================================
echo  Test Run Complete!
echo ==========================================

goto :end

:error
echo.
echo *** BUILD OR RUN FAILED ***
echo.
exit /b 1

:end
endlocal
