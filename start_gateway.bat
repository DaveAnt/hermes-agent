@echo off
title Hermes Gateway (FeishuBot) - 8642
rem =======================================================
rem   Hermes Gateway API Server (FeishuBot gateway)
rem   Chain: FeishuBot -> this gateway (8642) -> LLM (127.0.0.1:18080/v1)
rem   All config/data stays inside the hermes-agent directory
rem   NOTE: keep this file pure ASCII; non-ASCII breaks cmd parsing
rem =======================================================
set "ROOT=%~dp0"

rem -- Gateway HERMES_HOME (config.yaml / state.db / skills) --
set "HERMES_HOME=%ROOT%hermes-home"

rem -- API Server platform (key >= 16 chars; port 8642) --
set "API_SERVER_KEY=feishu-gw-K9mQ7xL4vB8nR1tZ"
set "API_SERVER_PORT=8642"

rem -- Unattended: tool execution without approval (no interactive channel in bot mode) --
set "HERMES_YOLO_MODE=1"

rem -- Working / temp directories (inside hermes-agent) --
set "TERMINAL_CWD=%ROOT%workspace"
set "OMNIAGENT_DEPLOY_DIR=%ROOT%workspace"
set "OMNIAGENT_WORKSPACE_DIR=%ROOT%workspace"
set "OMNIAGENT_TEMP_DIR=%ROOT%temp"
set "TMP=%ROOT%temp"
set "TEMP=%ROOT%temp"

rem -- Free port 8642 if occupied --
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8642 " ^| findstr "LISTENING"') do (
    echo   [gateway] Killing process holding port 8642, PID=%%a
    taskkill /PID %%a /F >nul 2>&1
)
%SystemRoot%\System32\timeout.exe /t 1 /nobreak >nul

echo [gateway] Starting Hermes Gateway API Server (port 8642)...
cd /d "%ROOT%"
".venv\Scripts\python.exe" cli.py --gateway
