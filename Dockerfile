# Use Ubuntu as base
FROM ubuntu:22.04

# Install Firefox and VNC server
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    supervisor \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create VNC directory and set no password
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create startup script
RUN echo '#!/bin/bash\n\
vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None\n\
sleep 2\n\
export DISPLAY=:1\n\
dbus-launch firefox --new-window https://www.facebook.com &\n\
websockify --web=/usr/share/novnc 8080 localhost:5901' > /start.sh && \
chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
