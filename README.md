---
title: Bank Deposit Prediction
emoji: 🏦
colorFrom: blue
colorTo: green
sdk: docker
app_port: 7860
pinned: false
---

# Bank Deposit Prediction — MLOps Pipeline

Model machine learning untuk memprediksi apakah nasabah akan membuka deposito berjangka, dibangun menggunakan TensorFlow Extended (TFX) dan dideploy menggunakan TensorFlow Serving di Hugging Face Spaces.

## Endpoint
- REST API: `POST /v1/models/bank-deposit-model:predict`
- Monitoring metrics: `/monitoring/prometheus/metrics`
