# Submission 1: Bank Marketing Deposit Prediction Pipeline

**Nama:** Ivan Rahadian  
**Username Dicoding:** rahadianivan09

---

## Deskripsi

| | |
|---|---|
| **Dataset** | [Bank Marketing Dataset](https://www.kaggle.com/datasets/janiobachmann/bank-marketing-dataset) — UCI Bank Marketing, 11.162 baris, 16 fitur |
| **Masalah** | Bank ingin memprediksi apakah seorang nasabah akan berlangganan deposito berjangka (`deposit: yes/no`) berdasarkan data demografis dan riwayat kampanye marketing. Ketidakmampuan mengidentifikasi nasabah potensial menyebabkan biaya kampanye yang tidak efisien. |
| **Solusi Machine Learning** | Membangun pipeline ML end-to-end menggunakan **TFX (TensorFlow Extended)** untuk klasifikasi biner — memprediksi probabilitas nasabah melakukan deposit. Pipeline mencakup validasi data, transformasi fitur, hyperparameter tuning, evaluasi otomatis, hingga deployment model. |
| **Metode Pengolahan** | Fitur kategorik (job, marital, education, contact, month, poutcome, dll.) diproses menggunakan **one-hot encoding** dan vocabulary lookup. Fitur numerik (age, balance, duration, campaign, pdays, previous) dinormalisasi menggunakan **z-score normalization**. Seluruh preprocessing diimplementasikan via komponen **Transform** TFX agar konsisten antara training dan serving. |
| **Arsitektur Model** | Deep Neural Network (DNN) klasifikasi biner dengan arsitektur yang ditentukan secara otomatis oleh **Keras Tuner** (hyperparameter tuning pada jumlah unit per layer, learning rate, dan dropout rate). Output layer menggunakan aktivasi **sigmoid** untuk menghasilkan skor probabilitas deposit. |
| **Metrik Evaluasi** | **BinaryAccuracy** — proporsi prediksi yang benar dari total sampel. **AUC (Area Under Curve)** — kemampuan model membedakan kelas positif dan negatif. Selain itu dihitung juga **Precision**, **Recall**, dan **ExampleCount** via TFMA. |
| **Performa Model** | Model berhasil melewati seluruh threshold evaluasi dan mendapat status **BLESSED ✅** |

---

## Hasil Evaluasi

| Metrik | Threshold | Hasil |
|--------|-----------|-------|
| BinaryAccuracy | ≥ 0.50 | **0.6675** ✅ |
| AUC | ≥ 0.70 | **0.7419** ✅ |

---

## Komponen Pipeline

| Komponen | Deskripsi |
|---|---|
| ExampleGen | Membaca `bank.csv` dan membagi data menjadi train (80%) dan eval (20%) split |
| StatisticsGen | Menghitung statistik deskriptif seluruh fitur untuk analisis distribusi data |
| SchemaGen | Meng-infer schema dataset secara otomatis sebagai kontrak validasi data |
| ExampleValidator | Mendeteksi anomali data (missing values, domain violation) terhadap schema |
| Transform | Feature engineering: one-hot encoding fitur kategorik, normalisasi fitur numerik |
| Tuner ✅ | Hyperparameter search otomatis menggunakan Keras Tuner |
| Trainer | Melatih DNN klasifikasi biner menggunakan best hyperparameter dari Tuner |
| Resolver | Mengambil model blessed terbaru sebagai baseline perbandingan evaluasi |
| Evaluator | Evaluasi model dengan TFMA, model di-bless jika lolos threshold |
| Pusher | Men-deploy model ke `serving_model/` dalam format SavedModel jika BLESSED |

---

## Bonus

- ✅ **Tuner** — Hyperparameter tuning otomatis dengan Keras Tuner
- ✅ **Docker Serving** — Model di-serve menggunakan TensorFlow Serving via Docker
- ✅ **testing.ipynb** — Pengujian endpoint prediksi via REST API (`localhost:8501`)

---

## Struktur Folder

```
rahadianivan09-mlpipeline/
├── data/
│   └── bank.csv
├── modules/
│   ├── rahadianivan09_transform.py
│   └── rahadianivan09_trainer.py
├── rahadianivan09-pipeline/
│   ├── metadata/
│   │   └── metadata.db
│   └── serving_model/
├── rahadianivan09-pipeline.ipynb
└── rahadianivan09-testing.ipynb
```