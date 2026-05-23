param (
    [string]$Metric = "All"
)

# 1. УКАЖИТЕ ПРАВИЛЬНЫЙ ПУТЬ К ЛОГУ ВАШЕЙ ПРОГРАММЫ
$LogPath = "C:\Program Files\UPS_LM\UPS_LM_events.log"

# Если файла лога нет, выдаем 0, чтобы не ломать Zabbix
if (-not (Test-Path $LogPath)) {
    Write-Output "0"
    exit
}

# 2. Читаем последнюю строку, содержащую данные (с "In=")
# Берем последние 50 строк для надежности
$RawLog = Get-Content $LogPath -Tail 50 -ErrorAction SilentlyContinue
$LastLine = $RawLog | Where-Object { $_ -match "In=" } | Select-Object -Last 1

if ($null -eq $LastLine) {
    Write-Output "0"
    exit
}

# 3. Парсинг данных регулярными выражениями
$Data = @{}

# Входное напряжение
if ($LastLine -match "In=(\d+\.?\d*)") { $Data['In'] = [float]$Matches[1] } else { $Data['In'] = 0 }
# Частота
if ($LastLine -match "Freq=(\d+\.?\d*)") { $Data['Freq'] = [float]$Matches[1] } else { $Data['Freq'] = 0 }
# Выходное напряжение
if ($LastLine -match "Out=(\d+\.?\d*)") { $Data['Out'] = [float]$Matches[1] } else { $Data['Out'] = 0 }
# Нагрузка (Current)
if ($LastLine -match "Current=(\d+)") { $Data['Current'] = [int]$Matches[1] } else { $Data['Current'] = 0 }
# Температура
if ($LastLine -match "Temp=(\d+\.?\d*)") { $Data['Temp'] = [float]$Matches[1] } else { $Data['Temp'] = 0 }
# Напряжение батареи
if ($LastLine -match "Battery=(\d+\.?\d*)") { $Data['BattV'] = [float]$Matches[1] } else { $Data['BattV'] = 0 }
# Заряд батареи %
if ($LastLine -match "BattLevel=(\d+)") { $Data['BattLevel'] = [int]$Matches[1] } else { $Data['BattLevel'] = 0 }
# Статус батареи (1=от батареи)
if ($LastLine -match "Batt=(\d)") { $Data['Batt'] = [int]$Matches[1] } else { $Data['Batt'] = 0 }
# Низкий заряд (1=да)
if ($LastLine -match "Low=(\d)") { $Data['Low'] = [int]$Matches[1] } else { $Data['Low'] = 0 }
# AVR (1=активен)
if ($LastLine -match "AVR=(\d)") { $Data['AVR'] = [int]$Matches[1] } else { $Data['AVR'] = 0 }
# Ошибка (1=да)
if ($LastLine -match "Error=(\d)") { $Data['Error'] = [int]$Matches[1] } else { $Data['Error'] = 0 }

# 4. Возврат нужного значения в зависимости от запроса Zabbix
switch ($Metric) {
    "InputVoltage" { $Data['In'] }
    "Frequency" { $Data['Freq'] }
    "OutputVoltage" { $Data['Out'] }
    "LoadPercent" { $Data['Current'] }
    "Temperature" { $Data['Temp'] }
    "BatteryVoltage" { $Data['BattV'] }
    "BatteryLevel" { $Data['BattLevel'] }
    "OnBattery" { $Data['Batt'] }
    "LowBattery" { $Data['Low'] }
    "AVRActive" { $Data['AVR'] }
    "ErrorStatus" { $Data['Error'] }
    "Overload" { 0 } # (Если в логе нет отдельного флага, считаем перегрузку по нагрузке, но пока 0)
    "All" { 
        Write-Output "Input:$($Data['In']) Level:$($Data['BattLevel']) Temp:$($Data['Temp'])" 
    }
    default { 0 }
}