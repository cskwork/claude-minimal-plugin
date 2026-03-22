@echo off
setlocal enabledelayedexpansion
:: auto-sync.bat — skill-library 자동 동기화 설정 (Windows)
:: 사용법: auto-sync.bat [--uninstall] [--run]

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "LIBRARY_DIR=%%~fI"
set "TASK_NAME=SkillLibraryAutoSync"
set "SYNC_INTERVAL_MINUTES=60"

:: --run: 실제 동기화만 수행 (Task Scheduler에서 호출)
if "%~1"=="--run" goto :do_sync

:: --uninstall: 제거
if "%~1"=="--uninstall" goto :uninstall

:: ── 메인 대화형 설정 ─────────────────────────────────
echo.
echo ========================================
echo   Skill Library Auto-Sync Setup
echo ========================================
echo.
echo   Library: %LIBRARY_DIR%
echo.
echo   이 스크립트는 skill-library를 주기적으로
echo   git pull하고 모든 에이전트에 symlink를 갱신합니다.
echo.
echo   동기화 대상:
echo     %%USERPROFILE%%\.claude\skills\skill-library
echo     %%USERPROFILE%%\.codex\skills\skill-library
echo     %%USERPROFILE%%\.gemini\skills\skill-library
echo     %%USERPROFILE%%\.gsd\agent\skills\skill-library
echo.

set /p "ANSWER=자동 동기화를 설정하시겠습니까? (y/N): "
if /i not "%ANSWER%"=="y" (
    echo [skip] 자동 동기화 설정을 건너뜁니다.
    echo.
    set /p "ONCE=지금 한 번만 동기화할까요? (y/N): "
    if /i "!ONCE!"=="y" call :do_sync
    goto :eof
)

echo.
set /p "INTERVAL_INPUT=동기화 간격 (분, 기본 60): "
if defined INTERVAL_INPUT (
    echo !INTERVAL_INPUT!| findstr /r "^[0-9][0-9]*$" >nul 2>&1
    if errorlevel 1 (
        echo [error] Invalid interval. Must be a number.
        goto :eof
    )
    set "SYNC_INTERVAL_MINUTES=!INTERVAL_INPUT!"
)

:: 즉시 1회 동기화
call :do_sync

:: Task Scheduler 등록
echo.
echo [setup] Windows Task Scheduler에 등록 중...
schtasks /create /tn "%TASK_NAME%" /tr "cmd /c \"%~f0\" --run" /sc minute /mo %SYNC_INTERVAL_MINUTES% /f >nul 2>&1
if errorlevel 1 (
    echo [error] Task Scheduler 등록 실패. 관리자 권한으로 다시 시도하세요.
    goto :eof
)

echo [done] Task Scheduler 등록 완료.
echo [info] Sync runs every %SYNC_INTERVAL_MINUTES% minutes.
echo.
echo Setup complete!
echo 제거: %~f0 --uninstall
echo.
goto :eof

:: ── 동기화 로직 ──────────────────────────────────────
:do_sync
where git >nul 2>&1 || (echo [error] git not found. Please install git first. & goto :eof)
echo [sync] git pull in %LIBRARY_DIR%...
pushd "%LIBRARY_DIR%"
git pull --rebase --autostash 2>nul || git pull
popd

echo [sync] Updating symlinks...

:: 디렉토리 생성
if not exist "%USERPROFILE%\.claude\skills" mkdir "%USERPROFILE%\.claude\skills"
if not exist "%USERPROFILE%\.codex\skills" mkdir "%USERPROFILE%\.codex\skills"
if not exist "%USERPROFILE%\.gemini\skills" mkdir "%USERPROFILE%\.gemini\skills"
if not exist "%USERPROFILE%\.gsd\agent\skills" mkdir "%USERPROFILE%\.gsd\agent\skills"

:: 기존 symlink/junction 제거 후 재생성
:: Windows는 mklink /J (junction)으로 디렉토리 링크 생성
for %%D in (
    "%USERPROFILE%\.claude\skills\skill-library"
    "%USERPROFILE%\.codex\skills\skill-library"
    "%USERPROFILE%\.gemini\skills\skill-library"
    "%USERPROFILE%\.gsd\agent\skills\skill-library"
) do (
    if exist %%D rmdir %%D 2>nul
    mklink /J %%D "%LIBRARY_DIR%" >nul 2>&1
    if errorlevel 1 (
        echo [warn] Junction 생성 실패: %%D — 관리자 권한이 필요할 수 있습니다.
    )
)

echo [done] Sync complete at %date% %time%
goto :eof

:: ── 제거 ─────────────────────────────────────────────
:uninstall
echo [uninstall] Removing auto-sync schedule...
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1
if errorlevel 1 (
    echo [skip] Task not found or already removed.
) else (
    echo [done] Task Scheduler entry removed.
)
goto :eof
