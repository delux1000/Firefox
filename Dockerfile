FROM jlesage/firefox:latest

# No VNC password
ENV VNC_PASSWORD=

# Start Firefox automatically
ENV AUTOSTART=1

# Optional: Set homepage to Facebook
ENV KEEP_APP_RUNNING=1

EXPOSE 8080
