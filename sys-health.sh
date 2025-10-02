#!/usr/bin/env bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
PROC_THRESHOLD=300

# Log file
LOGFILE="/var/log/system_health.log"

echo "=== System Health Check: $(date) ===" >> "$LOGFILE"

# CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "ALERT: High CPU usage: ${CPU_USAGE}%" | tee -a "$LOGFILE"
fi

# Memory usage
MEM_USAGE=$(free | awk '/Mem/{printf "%.0f", $3/$2 * 100}')
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "ALERT: High Memory usage: ${MEM_USAGE}%" | tee -a "$LOGFILE"
fi

# Disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: High Disk usage: ${DISK_USAGE}%" | tee -a "$LOGFILE"
fi

# Running processes
PROC_COUNT=$(ps aux | wc -l)
if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
    echo "ALERT: Too many processes: ${PROC_COUNT}" | tee -a "$LOGFILE"
fi

echo "System Health Check Completed." >> "$LOGFILE"
