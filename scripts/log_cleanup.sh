LOG_DIRS=("/var/log" "/home/centos/app/logs")
DAYS=7
DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/cleanup_report.log"

for dir in "${LOG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    find "$dir" -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;
    echo "[$DATE] Cleaned logs in: $dir" >> "$LOGFILE"
  else
    echo "[$DATE] Directory not found: $dir" >> "$LOGFILE"
  fi
done

echo "[$DATE] Cleanup complete." >> "$LOGFILE"
