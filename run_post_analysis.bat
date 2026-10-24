@echo off
setlocal EnableExtensions

rem FER3ON Next - closed-trade post-analysis (read-only)
set "ROOT=%~dp0"
set "PROJECT=%ROOT%fer3on_next"
set "PY=%PROJECT%\.venv\Scripts\python.exe"

if "%~1"=="" (
  echo Usage: run_post_analysis.bat ^<trades.csv^> ^<candles.csv^> [post_exit_bars]
  echo Example: run_post_analysis.bat "reports\mt5_closed_trades.csv" "data\xauusd_kaggle\normalized\xauusd_15m.csv" 20
  exit /b 2
)
if "%~2"=="" (
  echo ERROR: candles CSV is required.
  exit /b 2
)
if not exist "%PY%" (
  echo ERROR: project virtual environment not found.
  echo Run start_demo.bat once first, or create .venv under "%PROJECT%".
  exit /b 1
)
if not exist "%~1" (
  echo ERROR: trades file not found: "%~1"
  exit /b 1
)
if not exist "%~2" (
  echo ERROR: candles file not found: "%~2"
  exit /b 1
)
set "BARS=%~3"
if "%BARS%"=="" set "BARS=20"
set "OUT=%PROJECT%\reports\post_analysis_%RANDOM%"

cd /d "%PROJECT%"
"%PY%" tools\trade_post_analysis.py --trades "%~1" --candles "%~2" --out "%OUT%" --post-exit-bars %BARS%
set "EXIT_CODE=%ERRORLEVEL%"
echo.
echo Post-analysis output: %OUT%
exit /b %EXIT_CODE%
