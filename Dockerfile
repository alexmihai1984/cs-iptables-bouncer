FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update \
 && apt-get install -y curl iptables ipset ca-certificates 

# Download and install bouncer
RUN curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash \
 && apt-get install -y crowdsec-firewall-bouncer-iptables

 # Clean-up
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create non-root user (optional, bouncer runs as root for iptables)
RUN mkdir -p /etc/crowdsec/bouncers /var/log/crowdsec
COPY config.yaml /etc/crowdsec/bouncers/

CMD ["crowdsec-firewall-bouncer", "-c", "/etc/crowdsec/bouncers/crowdsec-cloudflare-bouncer.yaml"]
