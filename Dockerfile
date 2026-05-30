FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash\n\
vncserver -kill :1 2>/dev/null\n\
rm -rf /tmp/.X1*\n\
vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None\n\
sleep 3\n\
export DISPLAY=:1\n\
dbus-launch firefox --new-window https://www.facebook.com &\n\
websockify --web=/usr/share/novnc 8080 localhost:5901\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
