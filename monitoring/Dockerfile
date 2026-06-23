FROM prom/prometheus:latest

# Copy konfigurasi scrape target ke image Prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090

CMD ["--config.file=/etc/prometheus/prometheus.yml"]
