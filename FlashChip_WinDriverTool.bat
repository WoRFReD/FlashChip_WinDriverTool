@echo off
title Lanzador Actualizador de Controladores Universal
:: Verificar permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Este script requiere permisos de Administrador.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "FlashChip_WinDriverTool.ps1"

pause