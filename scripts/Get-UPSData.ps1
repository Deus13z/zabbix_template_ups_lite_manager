param(
    [Parameter(Mandatory=$true)]
    [string]$Metric
)

$ErrorActionPreference = "SilentlyContinue"

$stateLogPath = "C:\Program Files\UPS_LM\UPS_LM_state.log"
$eventLogPath = "C:\Program Files\UPS_LM\UPS_LM_events.log"

# Получаем последние 20 строк state.log
$stateLines = if (Test-Path $stateLogPath) { Get-Content $stateLogPath -Tail 20 } else { @() }

# Ищем последнюю строку статуса в events.log (содержит In= или Freq=)
$eventLine = $null
if (Test-Path $eventLogPath) {
    $evLines = Get-Content $eventLogPath -Tail 20
    foreach ($l in $evLines) {
        if ($l -match 'In=\d+\.?\d*V') { $eventLine = $l; break }
    }
}

try {
    switch ($Metric) {
        # 🟢 Параметры из state.log (обновляются каждую секунду)
        "InputVoltage" {
            foreach ($line in $stateLines) { if ($line -match 'In=(\d+\.?\d*)V') { return [float]$matches[1] } }
        }
        "OutputVoltage" {
            foreach ($line in $stateLines) { if ($line -match 'Out=(\d+\.?\d*)V') { return [float]$matches[1] } }
        }
        "Temperature" {
            foreach ($line in $stateLines) { if ($line -match 'Temp=(\d+\.?\d*)') { return [float]$matches[1] } }
        }

        # 🔵 Параметры из events.log (полный снимок состояния)
        "Frequency" {
            if ($eventLine -match 'Freq=(\d+\.?\d*)Hz') { return [float]$matches[1] }
        }
        "BatteryVoltage" {
            if ($eventLine -match 'Battery=(\d+\.?\d*)V') { return [float]$matches[1] }
        }
        "BatteryLevel" {
            if ($eventLine -match 'BattLevel=(\d+)%') { return [float]$matches[1] }
        }
        "LoadPercent" {
            if ($eventLine -match 'Current=(\d+)%') { return [float]$matches[1] }
        }
        "AVRActive" {
            if ($eventLine -match 'AVR=(\d)') { return [int]$matches[1] }
        }
        "ErrorStatus" {
            if ($eventLine -match 'Error=(\d)') { return [int]$matches[1] }
        }
        "OnBattery" {
            # Off=1 означает работу от батареи, Off=0 от сети
            if ($eventLine -match 'Off=(\d)') { return [int]$matches[1] }
        }
        "LowBattery" {
            if ($eventLine -match 'Low=(\d)') { return [int]$matches[1] }
        }
        "Overload" {
            return 0 # В логах нет прямого флага перегрузки
        }
        default { return 0 }
    }
}
catch {
    return 0
}

return 0