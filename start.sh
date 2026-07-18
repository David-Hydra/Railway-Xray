#!/bin/sh

# Read UUID from environment, or generate one
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}

echo "========================================="
echo "  UUID: $UUID"
echo "  Server domain will be assigned by Railway"
echo "========================================="

# Substitute UUID into configs
sed -i "s/\${UUID}/$UUID/g" /config.json
sed -i "s/\${UUID}/$UUID/g" /etc/caddy/Caddyfile

# Create decoy web pages
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

# Start Caddy on Railway's port (maps to 443 externally)
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
