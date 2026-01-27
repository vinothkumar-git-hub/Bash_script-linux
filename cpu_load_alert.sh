# Threshold for CPU load

THRESHOLD=70.00
ip_addr=$(hostname -I | awk '{print $1}')

LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')

# Compare load using bc (binary calculator)

if (( $(echo "$LOAD >= $THRESHOLD" | bc -l) )); then
    echo "CPU Load is Critical ($LOAD) on $ip_addr " | mail -s "CPU Mail Alert" laptop@example.com,labuser@example.com
fi
