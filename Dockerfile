FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    supervisor \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create VNC password file (no password)
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create supervisor config
RUN mkdir -p /etc/supervisor/conf.d
RUN cat > /etc/supervisor/conf.d/firefox.conf << 'EOF'
[program:vnc]
command=vncserver :1 -geometry 1280x720 -depth 24 -localhost no -rfbport 5901
autostart=true
autorestart=true
startsecs=5
priority=100

[program:firefox]
command=dbus-launch firefox --new-window https://www.facebook.com
environment=DISPLAY=":1"
autostart=true
autorestart=true
startsecs=10
priority=200

[program:websockify]
command=websockify --web=/usr/share/novnc 8080 localhost:5901
autostart=true
autorestart=true
startsecs=5
priority=300
EOF

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
