# UPS Lite Manager Template (Windows)

Универсальный шаблон мониторинга ИБП для Zabbix 7.0 через PowerShell и UPS Lite Manager.

## 📋 Описание

Шаблон предназначен для мониторинга источников бесперебойного питания (ИБП/UPS) 
через программное обеспечение UPS Lite Manager на Windows Server. 

**Поддерживаемые бренды:**
- DEXP (все модели)
- Ippon
- Powercom
- Sven
- Mustek
- Voltronic
- FSP
- И другие ИБП на протоколе Megatec, поддерживаемые UPS Lite Manager

Данные считываются напрямую из лог-файлов программы, что обеспечивает высокую 
точность и частоту обновления графиков.

## ✨ Возможности

- 📊 Мониторинг входного/выходного напряжения
- 🔋 Контроль заряда и напряжения батареи
- 🌡️ Отслеживание температуры ИБП
- ⚡ Мониторинг нагрузки (при поддержке протокола)
- 🔄 Статусы работы (AVR, батарея, ошибки, перегрузка)
- 🚨 12 триггеров для оповещения

## 📊 Параметры

| Параметр | Ключ | Единицы | Источник данных |
|----------|------|---------|-----------------|
| Входное напряжение | `ups.input.voltage` | V | `UPS_LM_state.log` |
| Выходное напряжение | `ups.output.voltage` | V | `UPS_LM_state.log` |
| Частота сети | `ups.frequency` | Hz | `UPS_LM_events.log` |
| Напряжение батареи | `ups.battery.voltage` | V | `UPS_LM_events.log` |
| Заряд батареи | `ups.battery.level` | % | `UPS_LM_events.log` |
| Температура | `ups.temperature` | °C | `UPS_LM_state.log` |
| Нагрузка | `ups.load.percent` | % | `UPS_LM_events.log` |
| Работа от батареи | `ups.on.battery` | 0/1 | `UPS_LM_events.log` |
| Низкий заряд | `ups.low.battery` | 0/1 | `UPS_LM_events.log` |
| AVR активен | `ups.avr.active` | 0/1 | `UPS_LM_events.log` |
| Ошибка | `ups.error.status` | 0/1 | `UPS_LM_events.log` |
| Перегрузка | `ups.overload` | 0/1 | `UPS_LM_events.log` |

## 🔧 Требования

- Zabbix 7.0+
- Windows Server 2016+
- UPS Lite Manager v3.4.0+
- PowerShell 5.1+
- Zabbix Agent 2

## 📥 Установка

### 1. Импортируйте шаблон в Zabbix
1. Перейдите в **Настройка → Шаблоны → Импорт**
2. Выберите файл `templates/DEXP_UPS_3000VA_Windows_Script.yaml`
3. Нажмите **Импорт**

### 2. Настройте Zabbix Agent 2
Откройте конфигурационный файл `zabbix_agent2.conf` и добавьте следующие строки:

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
```
### 3. Скопируйте скрипт

Скопируйте файл Get-UPSData.ps1 в папку C:\Scripts\


### 4. Установите и Настройте UPS Lite Manager

> ⚠️ **Важно:** Шаблон работает только при включённом логировании в программе.

Откройте **UPS Lite Manager** → **Настройки** → вкладка **Логи**
Настройте **Лог важных событий**:
   - ✅ Включите: `Лог важных событий`
   - Путь: `C:\Program Files\UPS_LM\UPS_LM_events.log`

Настройте **Лог изменений состояния**:
   - ✅ Включите: `Лог изменений состояния`
   - Путь: `C:\Program Files\UPS_LM\UPS_LM_state.log`
   - ✅ **Отметьте все параметры:**
     - `In V` (входное напряжение)
     - `Freq` (частота)
     - `Out V` (выходное напряжение)
     - `Curr` (ток/нагрузка)
     - `Temp` (температура)
     - `Batt V` (напряжение батареи)
     - `BattLevel` (заряд батареи)
     - `Batt` (статус батареи)
     - `Low` (низкий заряд)
     - `AVR` (стабилизатор)
     - `Err` (ошибки)
     - `Test` (тест)
     - `Off` (выключен)
   - ✅ Включите: `Записывать только изменившийся параметр`
   - ✅ Включите: `Игнорировать небольшие изменения напряжения сети` → установите **2.0 V**

**Отключите** (не требуются):
   - ❌ `Лог опроса ИБП` (занимает ~20Мб/день)
   - ❌ `Лог терминала`


