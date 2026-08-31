# Base image: kuhaon ang xray gikan sa teddysun/xray
FROM teddysun/xray:latest AS xray-bin

# Main image: Envoy — ang mag-proxy sa 8080
FROM envoyproxy/envoy:v1.31.10

# Kopyaha ang Xray gikan sa una nga image
COPY --from=xray-bin /usr/bin/xray /usr/local/bin/

# Kopyaha ang atong mga config files
COPY config.json /etc/xray.json
COPY envoy.yaml /etc/envoy/envoy.yaml

# Siguroha nga naa'y executable permissions
RUN chmod +x /usr/local/bin/xray && \
    chmod 644 /etc/xray.json /etc/envoy/envoy.yaml

# I-expose ang port 8080 — gikinahanglan sa Cloud Run
EXPOSE 8080

# Sugdi ang duha: Xray una, unya Envoy
CMD ["/bin/sh", "-c", "xray run -c /etc/xray.json & sleep 2 && exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
