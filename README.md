# Submission 2: Bank Marketing Deposit Prediction — MLOps End-to-End

**Nama:** Ivan Rahadian
**Username Dicoding:** rahadianivan09

---

## Deskripsi

| | |
|---|---|
| **Dataset** | [Bank Marketing Dataset](https://www.kaggle.com/datasets/janiobachmann/bank-marketing-dataset) — UCI Bank Marketing, 11.162 baris, 16 fitur |
| **Masalah** | Bank ingin memprediksi apakah seorang nasabah akan berlangganan deposito berjangka (`deposit: yes/no`) berdasarkan data demografis dan riwayat kampanye marketing. |
| **Solusi Machine Learning** | Membangun pipeline ML end-to-end menggunakan **TFX (TensorFlow Extended)** untuk klasifikasi biner. Target proyek: pipeline berjalan otomatis dari data mentah sampai model ter-deploy dan termonitor di **cloud environment**. |
| **Metode Pengolahan** | Fitur kategorik diproses dengan **one-hot encoding** & vocabulary lookup. Fitur numerik dinormalisasi dengan **z-score normalization**, via komponen **Transform** TFX. |
| **Arsitektur Model** | Deep Neural Network (DNN) klasifikasi biner, arsitektur ditentukan otomatis oleh **Keras Tuner**. Output layer pakai aktivasi **sigmoid**. |
| **Metrik Evaluasi** | **BinaryAccuracy**, **AUC**, **Precision**, **Recall**, **ExampleCount** via TFMA. |
| **Performa Model** | Model lolos seluruh threshold evaluasi, status **BLESSED ✅** |

---

## Hasil Evaluasi

| Metrik | Threshold | Hasil |
|--------|-----------|-------|
| BinaryAccuracy | ≥ 0.50 | **0.6675** ✅ |
| AUC | ≥ 0.70 | **0.7419** ✅ |

---

## Komponen Pipeline (TFX + Apache Beam)

| Komponen | Deskripsi |
|---|---|
| ExampleGen | Membaca `bank.csv`, split train (80%) / eval (20%) |
| StatisticsGen | Statistik deskriptif seluruh fitur |
| SchemaGen | Infer schema otomatis sebagai kontrak validasi |
| ExampleValidator | Deteksi anomali data terhadap schema |
| Transform | One-hot encoding & normalisasi fitur |
| Tuner ✅ | Hyperparameter search otomatis (Keras Tuner) |
| Trainer | Training DNN dengan best hyperparameter |
| Resolver | Ambil model blessed terbaru sebagai baseline |
| Evaluator | Evaluasi TFMA, bless jika lolos threshold |
| Pusher | Deploy model ke `serving_model/` jika BLESSED |

---

## Deployment — Cloud Computing

Model di-deploy menggunakan **Docker container** yang menjalankan **TensorFlow Serving**, di-hosting di **Hugging Face Spaces** (alternatif dari Heroku, mendukung Docker native, gratis, stabil).

**🔗 Web App / Model Serving URL:**
```
https://rahadianivan09-bank-deposit-prediction.hf.space
```

**Endpoint:**
- Status: `GET /v1/models/bank-deposit-model`
- Prediksi: `POST /v1/models/bank-deposit-model:predict`

**Verifikasi:** Diuji lewat `rahadianivan09-testing.ipynb`, berhasil mengirim *prediction request* ke cloud dan menerima respons valid.

---

## Monitoring — Prometheus & Grafana

Sistem dipantau menggunakan **Prometheus**, melakukan *scraping* metrics dari endpoint TF Serving di Hugging Face (`/monitoring/prometheus/metrics`), dikonfigurasi via `monitoring_config.txt`.

**Hasil Monitoring:**
- Target `tfserving-bank-deposit` terdeteksi **UP** secara konsisten.
- Metrics yang dipantau: status ketersediaan model (`up`) serta metrics request/latency bawaan TF Serving.

**Dashboard:** Prometheus disinkronkan dengan **Grafana** untuk dashboard visual, menampilkan status `UP/DOWN` kedua target (`prometheus` self-monitoring & `tfserving-bank-deposit`) dalam grafik time-series.

Screenshot bukti:
- `rahadianivan09-monitoring.png` — dashboard Prometheus, target UP
- `rahadianivan09-grafanadashboard.png` — dashboard Grafana

---

## Testing — Prediction Request ke Cloud

`rahadianivan09-testing.ipynb` memverifikasi model di Hugging Face dapat diakses dan menghasilkan prediksi valid.

**Hasil pengujian (3 sampel nasabah):**

| Nasabah | Age | Job | Balance | Duration | Score | Prediksi |
|---|---|---|---|---|---|---|
| 1 | 58 | management | 2143 | 261s | 0.3749 | Tidak Deposit ❌ |
| 2 | 44 | technician | 29 | 151s | 0.2444 | Tidak Deposit ❌ |
| 3 | 33 | entrepreneur | 2956 | 199s | 0.5087 | Akan Deposit ✅ |

Model status saat pengujian:
```json
{
  "model_version_status": [
    {
      "version": "1782280316",
      "state": "AVAILABLE",
      "status": { "error_code": "OK", "error_message": "" }
    }
  ]
}
```

---

## Clean Code — Pylint

Modul pada `modules/` (`rahadianivan09_trainer.py`, `rahadianivan09_transform.py`) dievaluasi dengan **pylint**.

**Hasil:** `Your code has been rated at 9.81/10`

Screenshot bukti: `rahadianivan09-pylint.png`

---

## Penerapan Saran (Suggestions)

| # | Saran | Status | Bukti |
|---|---|---|---|
| 1 | Hyperparameter tuning otomatis (Tuner) | ✅ | Komponen `Tuner` pada pipeline |
| 2 | Clean code principle | ✅ | Pylint score 9.81/10 |
| 3 | Notebook testing/prediction request ke cloud | ✅ | `rahadianivan09-testing.ipynb` |
| 4 | Sinkronisasi Prometheus + Grafana | ✅ | `rahadianivan09-grafanadashboard.png` |

---

## Struktur Folder

```
rahadianivan09-mlpipeline2/
├── data/
│   └── bank.csv
├── modules/
│   ├── rahadianivan09_transform.py
│   └── rahadianivan09_trainer.py
├── rahadianivan09-pipeline/
│   ├── metadata/
│   │   └── metadata.db
│   └── serving_model/
│       └── 1782280316/
├── monitoring/
│   ├── Dockerfile
│   ├── prometheus.yml
│   └── prometheus.config
├── rahadianivan09-pipeline.ipynb
├── rahadianivan09-testing.ipynb
├── Dockerfile
├── monitoring_config.txt
├── requirements.txt
├── rahadianivan09-deployment.png
├── rahadianivan09-monitoring.png
├── rahadianivan09-pylint.png
├── rahadianivan09-grafanadashboard.png
└── README.md
```
