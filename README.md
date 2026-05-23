# Zabbix Template for DEXP UPS 3000VA (Windows)

Полный шаблон мониторинга ИБП DEXP 3000VA для Zabbix 7.0 через PowerShell.

## 📋 Описание

Шаблон для мониторинга источников бесперебойного питания DEXP 3000VA через программное обеспечение UPS Lite Manager на Windows Server.

## ✨ Возможности

- 📊 Мониторинг входного/выходного напряжения
- 🔋 Контроль заряда батареи
- 🌡️ Отслеживание температуры ИБП
- ⚡ Мониторинг нагрузки
- 🔄 Статусы работы (AVR, батарея, ошибки, перегрузка)
- 🚨 10 триггеров для оповещения

## 📊 Параметры

| Параметр | Ключ | Единицы |
|----------|------|---------|
| Входное напряжение | ups.input.voltage | V |
| Выходное напряжение | ups.output.voltage | V |
| Частота сети | ups.frequency | Hz |
| Напряжение батареи | ups.battery.voltage | V |
| Заряд батареи | ups.battery.level | % |
| Температура | ups.temperature | °C |
| Нагрузка | ups.load.percent | % |
| Работа от батареи | ups.on.battery | 0/1 |
| Низкий заряд | ups.low.battery | 0/1 |
| AVR активен | ups.avr.active | 0/1 |
| Ошибка | ups.error.status | 0/1 |
| Перегрузка | ups.overload | 0/1 |

## 🔧 Требования

- Zabbix 7.0+
- Windows Server 2016+
- UPS Lite Manager
- PowerShell 5.1+
- Zabbix Agent 2

## 📥 Установка

### 1. Импортируйте шаблон

1. **Настройка → Шаблоны → Импорт**
2. Выберите файл `templates/DEXP_UPS_3000VA_Windows_Script.yaml`
3. Нажмите **Импорт**

### 2. Настройте Zabbix Agent 2

Добавьте в `zabbix_agent2.conf`:

```ini
UserParameter=ups.input.voltage,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "InputVoltage"
UserParameter=ups.output.voltage,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "OutputVoltage"
UserParameter=ups.frequency,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "Frequency"
UserParameter=ups.battery.voltage,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "BatteryVoltage"
UserParameter=ups.battery.level,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "BatteryLevel"
UserParameter=ups.temperature,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "Temperature"
UserParameter=ups.load.percent,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "LoadPercent"
UserParameter=ups.on.battery,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "OnBattery"
UserParameter=ups.low.battery,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "LowBattery"
UserParameter=ups.avr.active,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "AVRActive"
UserParameter=ups.error.status,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "ErrorStatus"
UserParameter=ups.overload,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\Get-UPSData.ps1" -Metric "Overload"
