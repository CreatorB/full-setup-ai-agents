# infra-monitor

## Purpose

Monitor network infrastructure, CCTV, and power status. Send instant alerts on failures and daily health summaries.

## LLM Required

No. Pure cron + ping + SSH/API checks. Does not consume VRAM.

## Trigger

- Cron: every 3 minutes (critical device checks)
- Cron: daily at 20:00 (summary report)

## Monitored Devices

| Category | Devices | Check Method |
|---|---|---|
| Router | MikroTik RouterOS | SSH commands or REST API (RouterOS 7.x) |
| Switch | UniFi, Aruba | SNMP or ping |
| Telephony | PABX systems | Ping or SIP check |
| CCTV | Xiaomi 360 smarthome, IP cameras | Ping local IP or RTSP stream check |
| IoT | Arduino/Raspberry Pi devices | Ping or HTTP health endpoint |
| Power | UPS (if available) | NUT, apcupsd, or SNMP |

## MikroTik Checks

```
/system resource print          -> CPU, memory, uptime
/interface print where running  -> Interface status
/ip dhcp-server lease print     -> Active DHCP leases
/ip hotspot active print        -> Hotspot users (if applicable)
```

## Power Outage Detection

Three detection methods:

1. **Multiple device offline:** If 70%+ of all monitored devices go offline simultaneously, it is likely a power outage (not individual device failure)
2. **UPS status:** If a UPS with network monitoring (NUT/apcupsd/SNMP) reports "on battery", power has failed
3. **Recovery detection:** When devices come back online after an outage, send recovery alert with outage duration

## Alerts (to Telegram)

| Event | Alert |
|---|---|
| Device unreachable | Instant alert with device name and location |
| Power outage detected | Instant alert with timestamp and offline device count |
| Power restored | Recovery alert with outage duration |
| CPU > 80% | Warning with current load |
| UPS on battery | Alert with battery level and estimated runtime |
| UPS battery < 20% | Critical alert |

## Config (.env)

```env
# MikroTik
MIKROTIK_HOST=192.168.1.1
MIKROTIK_USER=monitor
MIKROTIK_SSH_KEY=~/.ssh/mikrotik_monitor

# CCTV Xiaomi 360
XIAOMI_CAMERA_IPS=192.168.1.50,192.168.1.51

# UPS (optional)
UPS_ENABLED=false
UPS_HOST=192.168.1.2

# Additional devices (comma-separated IP list)
# UNIFI_SWITCH_IPS=192.168.1.10
# ARUBA_SWITCH_IPS=192.168.1.11
# PABX_HOST=192.168.1.20
```

## Data

- Metrics stored locally (JSON or SQLite)
- Power outage history available for daily-planner aggregation
- Never sent to cloud
