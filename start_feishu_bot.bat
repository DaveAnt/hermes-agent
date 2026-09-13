@echo off
title FeishuBot (Feishu bot)
rem =======================================================
rem   FeishuBot - Feishu bot (WebSocket long connection)
rem   Chain: Feishu -> this bot -> gateway (8642) -> LLM
rem   Credentials from feishu.env; falls back to env vars
rem   NOTE: keep this file pure ASCII; non-ASCII breaks cmd parsing
rem =======================================================
set "ROOT=%~dp0"

rem -- Defaults (overridable by feishu.env) --
set "FEISHU_APP_ID=cli_aae67216a4789bdf"
set "FEISHU_SECRET_FROM_ENV="
set "FEISHU_DOMAIN=feishu"
set "FEISHU_CONNECTION_MODE=websocket"
set "HERMES_API_BASE=http://localhost:8642"
set "HERMES_API_KEY=feishu-gw-K9mQ7xL4vB8nR1tZ"

rem -- Load feishu.env if present --
if exist "%ROOT%feishu.env" (
    echo [bot] Loading Feishu credentials from feishu.env...
    for /f "usebackq tokens=1,* delims==" %%a in ("%ROOT%feishu.env") do (
        if /i "%%a"=="FEISHU_APP_ID" set FEISHU_APP_ID=%%b
        if /i "%%a"=="FEISHU_APP_SECRET" set FEISHU_APP_SECRET=%%b
        if /i "%%a"=="HERMES_API_BASE" set HERMES_API_BASE=%%b
        if /i "%%a"=="HERMES_API_KEY" set HERMES_API_KEY=%%b
    )
) else (
    echo [bot] feishu.env not found, using env var FEISHU_APP_SECRET
)

if "%FEISHU_APP_SECRET%"=="" (
    echo [error] FEISHU_APP_SECRET is not set. Fill it in %ROOT%feishu.env or run: set FEISHU_APP_SECRET=...
    pause
    exit /b 1
)

echo [bot] App ID: %FEISHU_APP_ID%
echo [bot] Hermes API: %HERMES_API_BASE%   mode: %FEISHU_CONNECTION_MODE%

rem -- Start FeishuBot (package in OmniTeam\OmniBot\FeishuBot, run with -m from parent dir) --
cd /d "%ROOT%..\..\OmniBot"
python -m FeishuBot
