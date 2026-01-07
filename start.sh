#!/bin/sh

for i in $(seq 1 ${TOR_COUNT:-20}); do
  port=$((9050 + $i))
  echo "Starting Tor instance $i on port=$port"
  tor --SocksPort $port \
      --MaxCircuitDirtiness 10 \
      --PidFile /var/run/tor/$i.pid \
      --RunAsDaemon 1 \
      --Log "notice file /var/log/tor/$i.log" \
      --DataDirectory /var/db/tor/$i
  sleep 10
done

echo "=== Starting HAProxy ==="
exec haproxy -f /etc/default/haproxy.conf -q -db
