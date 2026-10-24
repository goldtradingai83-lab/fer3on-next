@echo off
setlocal EnableExtensions

rem FER3ON Next: one-command Windows launcher, no PowerShell activation required.
set "ROOT=%~dp0"
set "PROJECT=%ROOT%fer3on_next"
set "PY=%PROJECT%\.venv\Scripts\python.exe"
set "REPORTS=%PROJECT%\reports"
set "LEDGER=%REPORTS%\live_demo_ledger.jsonl"
set "HISTORY_DB=%REPORTS%\mt5_closed_trades.sqlite3"

if not exist "%PROJECT%\run_demo.py" (
    echo ERROR: Project not found: "%PROJECT%"
    exit /b 1
)

if not exist "%PY%" (
    echo Creating the project virtual environment...
    where py >nul 2>&1
    if not errorlevel 1 py -3 -m venv "%PROJECT%\.venv"
    if not exist "%PY%" python -m venv "%PROJECT%\.venv"
)

if not exist "%PY%" (
    echo ERROR: Could not create the project virtual environment.
    exit /b 1
)

if not exist "%REPORTS%" mkdir "%REPORTS%"

rem Install/update only the local project and MT5 package; no activation is needed.
"%PY%" -m pip install -e "%PROJECT%" --disable-pip-version-check >nul 2>&1
"%PY%" -c "import MetaTrader5" >nul 2>&1
if errorlevel 1 "%PY%" -m pip install MetaTrader5

set "FER3ON_MODE=DEMO"
set "FER3ON_DEMO_CONFIRM=YES"
set "FER3ON_MT5_JOURNAL=%LEDGER%"
set "FER3ON_DEMO_JOURNAL=%LEDGER%"
set "FER3ON_POST_ANALYSIS_ENABLED=YES"
set "FER3ON_POST_ANALYSIS_BARS=20"

cd /d "%PROJECT%"
echo.
echo FER3ON Next - DEMO ONLY
echo Project: %PROJECT%
echo Python:  %PY%
echo Ledger:  %LEDGER%
echo History: %HISTORY_DB%
echo.

rem Read-only MT5 history sync. It never evaluates strategies or sends orders.
echo Synchronizing closed MT5 trade history...
"%PY%" "%PROJECT%\main.py" --mode history --history-db "%HISTORY_DB%" --history-lookback-days 30
if errorlevel 1 echo WARNING: History sync failed; continuing with the Demo strategy loop.
echo.

if "%~1"=="" (
    "%PY%" "%PROJECT%\run_demo.py" --mode DEMO --strategies all --interval 60
) else (
    "%PY%" "%PROJECT%\run_demo.py" --mode DEMO --strategies all %*
)
set "EXIT_CODE=%ERRORLEVEL%"
echo.
echo FER3ON stopped with code %EXIT_CODE%.
exit /b %EXIT_CODE%
