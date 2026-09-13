@echo off
chcp 65001 >nul
title Hermes Feishu 一键启动 (Gateway 8642 + FeishuBot)
rem =======================================================
rem   一键启动：1) Hermes Gateway (8642)  2) FeishuBot
rem   所有配置/数据均在 hermes-agent 根目录内
rem =======================================================
set ROOT=%~dp0

echo [0/2] 检查并释放 8642 端口 ...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8642 " ^| findstr "LISTENING"') do (
    echo      关闭占用 8642 端口的进程 PID=%%a
    taskkill /PID %%a /F >nul 2>&1
)
timeout /t 1 /nobreak >nul

echo [1/2] 启动 Hermes Gateway ...
start "Hermes Gateway" cmd /k "%ROOT%start_gateway.bat"
echo      等待 Gateway 初始化 (8 秒) ...
timeout /t 8 /nobreak >nul

echo [2/2] 启动 FeishuBot ...
start "FeishuBot" cmd /k "%ROOT%start_feishu_bot.bat"

echo.
echo =======================================================
echo   服务已启动 (关闭对应窗口即可停止):
echo   - Hermes Gateway 窗口: 8642 (hermes-home 配置)
echo   - FeishuBot 窗口:      飞书机器人 (WebSocket)
echo =======================================================
pause