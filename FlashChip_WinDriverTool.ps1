# Script universal de automatizacion e instalacion de controladores faltantes v1.14
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "                FLASHCHIP WIN DRIVER TOOL v1.14            " -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# Funcion auxiliar para obtener dispositivos no reconocidos
function Get-Faltantes {
    return Get-CimInstance Win32_PNPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
}

# 1. Escanear dispositivos no reconocidos
Write-Host "[1/5] Analizando el Administrador de Dispositivos..." -ForegroundColor Yellow
$dispositivosFaltantes = Get-Faltantes

if (-not $dispositivosFaltantes) {
    Write-Host " -> Perfecto: No se detectaron dispositivos con errores o sin controlador." -ForegroundColor Green
    Write-Host ""
    Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "by WoRFReD" -ForegroundColor Gray
    Write-Host "Canal: FlashChip (https://youtube.com/@flashchiped)" -ForegroundColor Gray
    Write-Host ""
    Read-Host -Prompt "Presione Enter para salir y visitar el canal FlashChip"
    Start-Process "https://youtube.com/@flashchiped"
    exit
}

Write-Host " -> Se han encontrado $($dispositivosFaltantes.Count) dispositivos sin controlador:`n" -ForegroundColor Red

foreach ($dev in $dispositivosFaltantes) {
    $hwId = if ($dev.HardwareID) { $dev.HardwareID[0] } else { "Desconocido" }
    Write-Host "  [!] $($dev.Name)" -ForegroundColor Yellow
    Write-Host "      ID Hardware: $hwId" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[2/5] Configurando Windows para permitir la busqueda automatica de drivers..." -ForegroundColor Yellow

Start-Process "reg.exe" -ArgumentList 'add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d 0 /f' -NoNewWindow -Wait
Start-Process "reg.exe" -ArgumentList 'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d 1 /f' -NoNewWindow -Wait

Write-Host ""
Write-Host "[3/5] Forzando reescaneo del Administrador de Dispositivos..." -ForegroundColor Yellow
pnputil /scan-devices | Out-Null

Write-Host ""
Write-Host "[4/5] Capa 1: Buscando e instalando controladores desde Microsoft Update..." -ForegroundColor Yellow

try {
    Write-Host " -> Iniciando busqueda nativa en Windows Update Catalog..." -ForegroundColor Cyan
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $searcher.ServerSelection = 2
    
    $searchResult = $searcher.Search("IsInstalled=0 and Type='Driver'")
    
    if ($searchResult.Updates.Count -gt 0) {
        Write-Host " -> Se han encontrado $($searchResult.Updates.Count) controladores disponibles. Descargando..." -ForegroundColor Green
        
        $downloader = $session.CreateUpdateDownloader()
        $downloader.Updates = $searchResult.Updates
        $downloader.Download()

        Write-Host " -> Instalando controladores descargados..." -ForegroundColor Green
        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $searchResult.Updates
        $installResult = $installer.Install()

        Write-Host " -> Instalacion de Microsoft Update finalizada (Codigo: $($installResult.ResultCode))." -ForegroundColor Green
    } else {
        Write-Host " -> No se encontraron nuevos drivers directos en el catalogo de Microsoft Update." -ForegroundColor Yellow
    }
} catch {
    Write-Host " -> Error al interactuar con el servicio de Windows Update: $_" -ForegroundColor Red
}

# Reevaluar estado tras Capa 1
pnputil /scan-devices | Out-Null
$dispositivosRestantes = Get-Faltantes

Write-Host ""
Write-Host "[5/5] Capa 2: Analisis de contingencia e informe de Hardware ID..." -ForegroundColor Yellow

if ($dispositivosRestantes) {
    Write-Host " -> Quedan $($dispositivosRestantes.Count) dispositivos sin controlador resoluble automaticamente." -ForegroundColor Red
    Write-Host " -> Enlaces directos para descarga manual filtrados por ID Hardware:`n" -ForegroundColor Yellow
    
    foreach ($dev in $dispositivosRestantes) {
        $hwId = if ($dev.HardwareID) { $dev.HardwareID[0] } else { "Desconocido" }
        $encodedHwId = [System.Uri]::EscapeDataString($hwId)
        $catalogUrl = "https://www.catalog.update.microsoft.com/Search.aspx?q=$encodedHwId"
        
        Write-Host "  [!] Dispositivo: $($dev.Name)" -ForegroundColor Yellow
        Write-Host "      ID Hardware: $hwId" -ForegroundColor Gray
        Write-Host "      Catalogo MS: $catalogUrl`n" -ForegroundColor Cyan
    }
} else {
    Write-Host " -> Capa 2 omitida: Todos los dispositivos requeridos han sido resueltos correctamente." -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Proceso finalizado. Reinicia el PC para aplicar cambios. " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "by WoRFReD"
Write-Host "Canal: FlashChip (https://youtube.com/@flashchiped)"
Write-Host ""

Read-Host -Prompt "Presione Enter para salir y visitar el canal FlashChip"
Start-Process "https://youtube.com/@flashchiped"