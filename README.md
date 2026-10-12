# 🍜 Aplikasi "Kantin Bu Sari"
**Tugas Praktikum 2 - Desain Grafis & Multimedia**  
**Nama**: Muhammad Alif Ramsya  
**NPM**: 065124075  
**Kelas**: C  

---

## 📌 Deskripsi Proyek
Aplikasi **"Kantin Bu Sari"** adalah aplikasi pemesanan makanan dan minuman kantin kampus berbasis Flutter yang dirancang secara profesional, proporsional, realistis, dan siap guna (*production-ready*). Aplikasi ini mengintegrasikan seluruh alur pemesanan mulai dari eksplorasi menu, kustomisasi pesanan (level pedas & topping), keranjang belanja, checkout meja/takeaway, struk digital, hingga pelacakan status masak pesanan secara *real-time*.

---

## 📋 Pemenuhan Ketentuan Pengerjaan Soal

### ✅ Ketentuan 1: Eksplorasi dan Penggunaan Widget (>5 Widget Bervariasi Per Halaman)

| Halaman | Widget Interaktif yang Diimplementasikan | Fungsi Interaktivitas |
|---|---|---|
| **1. Beranda (Home / Menu)** | 1. `AppBar` & `CircleAvatar`<br>2. `Card` & `LinearGradient`<br>3. `FilledButton` / `ElevatedButton`<br>4. `TextField` (Live Search Bar)<br>5. `ChoiceChip` (Kategori Menu)<br>6. `GridView.builder`<br>7. `IconButton` (Favorit)<br>8. `Badge`<br>9. `FloatingActionButton.extended` | Pencarian real-time, filter kategori, klaim voucher instan, toggle favorit, akses cepat ke keranjang dengan indikator total. |
| **2. Detail Menu** | 1. `SliverAppBar` (Collapsible Banner)<br>2. `Slider` (Tingkat Kepedasan 0-5)<br>3. `CheckboxListTile` (Pilihan Topping Tambahan)<br>4. `TextField` (Catatan Khusus untuk Dapur)<br>5. Quantity Counter Control (`IconButton.filledTonal`)<br>6. `BottomAppBar` & `FilledButton.icon`<br>7. `SnackBar` Notifikasi | Kustomisasi pesanan interaktif (slider pedas dinamis, kalkulasi harga otomatis saat topping dipilih, input catatan khusus, dan feedback snackbar). |
| **3. Keranjang & Checkout** | 1. `ListView` Pesanan & Counter Tambah/Kurang<br>2. `SegmentedButton` (Makan di Tempat / Bungkus)<br>3. `DropdownButtonFormField` (Pilihan Nomor Meja)<br>4. `RadioListTile` (KantinPay, QRIS, Tunai)<br>5. `TextField` Kupon Promo Diskon<br>6. `Chip` Status Kupon Aktif<br>7. `FilledButton` Konfirmasi Pembayaran<br>8. `AlertDialog` Struk & Nomor Antrean | Pemilihan tipe makan, pemilihan meja pemesanan, verifikasi saldo dompet mahasiswa vs total belanja, klaim kupon diskon (kode: `MHSHEMAT`), dan popup struk digital otomatis. |
| **4. Riwayat & Pelacakan Pesanan** | 1. `TabBar` & `TabBarView` (Pesanan Aktif vs Selesai)<br>2. `LinearProgressIndicator` (Proses Masak)<br>3. Step Dot Status Indicator (Diterima, Dimasak, Siap, Selesai)<br>4. `TextButton.icon` (Simulasi Maju Status Real-time)<br>5. `OutlinedButton` (Lihat Struk Digital)<br>6. `showModalBottomSheet` (Rincian Transaksi)<br>7. `AlertDialog` Bintang Rating Interaktif | Melacak status pesanan secara visual, simulasi pergerakan pesanan dapur untuk demonstrasi presentasi dosen, cetak/lihat struk, serta dialog rating bintang 1-5. |
| **5. Profil & Pengaturan** | 1. `CircleAvatar` & Profil Siswa<br>2. `Card` Saldo KantinPay<br>3. `ElevatedButton.icon` (Top Up Saldo Modal)<br>4. `ChoiceChip` Nominal Isi Saldo (10k, 20k, 50k, 100k)<br>5. `SwitchListTile` (Toggle Notifikasi Makanan)<br>6. `SwitchListTile` (Toggle Dark Mode / Tema Gelap)<br>7. `ExpansionTile` (Informasi Jam Buka & Lokasi Stand)<br>8. `ExpansionTile` (Dokumentasi Widget Praktikum) | Personalisasi mahasiswa, pengisian saldo instan, penggantian tema gelap/terang secara live, serta info operasional kantin. |

---

### ✅ Ketentuan 2: Desain Antarmuka (UI) Profesional & Proporsional
- **Palet Warna Harmonis**: Menggunakan warna selera makan modern (Warm Ember `#E65100` dipadukan dengan aksen Fresh Mint `#2E7D32` dan Slate Modern `#1E293B`).
- **Material 3 Design**: Menggunakan radius membulat yang konsisten (16-24px), visual card berbayang lembut (*soft elevation*), serta tipografi hierarkis yang jelas.
- **Dukungan Dark Mode & Light Mode**: Tampilan aplikasi responsif dan nyaman digunakan di kondisi pencahayaan apapun.
- **Struktur Realistis**: Mengakomodasi skenario kantin kampus nyata (menu beragam, harga mahasiswa, nomor meja, opsi take-away, metode QRIS/KantinPay, dan nomor antrean).

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan berada di direktori `tugasp2`, kemudian jalankan salah satu perintah berikut:

### 1. Menjalankan di Windows Desktop
```bash
flutter run -d windows
```

### 2. Menjalankan di Browser (Chrome / Edge)
```bash
flutter run -d chrome
```

---

## 🧪 Pengujian Unit & Widget
Aplikasi telah lolos pengujian tanpa error/warning:
```bash
flutter analyze
flutter test
```
Hasil: **`No issues found!`** & **`All tests passed!`**
