#!/bin/sh

# Set a custom UUID or generate a random one if not provided
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}

# Generate a proper Caddyfile with the UUID substituted
sed "s/\${UUID}/$UUID/g" /etc/caddy/Caddyfile > /etc/caddy/Caddyfile.tmp
mv /etc/caddy/Caddyfile.tmp /etc/caddy/Caddyfile

# Generate Xray config with UUID substituted
sed "s/\${UUID}/$UUID/g" /config.json > /config.json.tmp
mv /config.json.tmp /config.json

# Create a decoy web directory
mkdir -p /usr/share/caddy
cat > /usr/share/caddy/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><title>Welcome</title></head>
<body>
<h1>Service Running</h1>
<p>This server is running normally.</p>
</body>
</html>
HTML

# Port 443 is provided by Railway via $PORT env variable
echo "Starting Xray with UUID: $UUID"
echo "Starting Caddy on port $PORT"

# Start Xray in background
/xray -config /config.json &

# Start Caddy (uses $PORT from Railway environment, forwarded to 443)
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
