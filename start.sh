#!/bin/sh

UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}

echo "========================================="
echo "  UUID: $UUID"
echo "  Railway will assign domain & TLS"
echo "  Caddy listens on PORT: $PORT"
echo "========================================="

# Substitute UUID into configs
sed -i "s/\${UUID}/$UUID/g" /config.json
sed -i "s/\${UUID}/$UUID/g" /etc/caddy/Caddyfile

# Create decoy web directory
mkdir -p /usr/share/caddy
cat > /usr/share/caddy/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Service</title></head>
<body><h1>Service Running</h1><p>This server is running normally.</p></body>
</html>
EOF

# Start Xray in background
/xray -config /config.json &

# Start Caddy — Railway injects $PORT (8080 default)
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
