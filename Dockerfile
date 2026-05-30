# Use Ubuntu as base
FROM ubuntu:22.04

# Install Firefox, VNC, noVNC, and dependencies
RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create startup script
RUN echo '#!/bin/bash\n\
# Start VNC server (no password)\n\
vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None\n\
\n\
# Wait for VNC to start\n\
sleep 3\n\
\n\
# Start Firefox\n\
export DISPLAY=:1\n\
dbus-launch firefox --new-window https://www.facebook.com &\n\
\n\
# Start noVNC web server\n\
websockify --web=/usr/share/novnc 8080 localhost:5901\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
