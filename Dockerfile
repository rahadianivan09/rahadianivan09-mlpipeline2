FROM tensorflow/serving:latest

# Copy serving model hasil Pusher ke dalam container
COPY rahadianivan09-pipeline/serving_model /models/bank-deposit-model

# Copy konfigurasi monitoring (mengaktifkan endpoint /monitoring/prometheus/metrics)
COPY monitoring_config.txt /models/monitoring_config.txt

# Set environment variable nama model
ENV MODEL_NAME=bank-deposit-model

# HuggingFace Spaces WAJIB pakai port 7860
EXPOSE 7860

# Jalankan TF Serving:
# - port 8500 -> gRPC (internal)
# - rest_api_port 7860 -> REST API (wajib port ini di HF Spaces)
# - monitoring_config_file -> mengaktifkan metrics buat di-scrape Prometheus
CMD ["tensorflow_model_server", \
     "--port=8500", \
     "--rest_api_port=7860", \
     "--model_name=bank-deposit-model", \
     "--model_base_path=/models/bank-deposit-model", \
     "--monitoring_config_file=/models/monitoring_config.txt"]
