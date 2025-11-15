# Insectpedia – Aplikasi Klasifikasi Serangga Berbahaya


---

## Nama Kelompok dan Anggota

**Kelompok B3'23**  

**Anggota:**  
1. Muhammad Arif Septian (2309106046)  
2. Muhammad Iqbal Fadiatama (2309106077)   
3. Muhammad Rizky Haritama Putra (2309106083)
4. Ari Fullah (2309106085)

---

Insectpedia adalah aplikasi klasifikasi serangga berbahaya berbasis kecerdasan buatan yang mengidentifikasi berbagai spesies serangga melalui foto. Aplikasi ini memberikan informasi singkat tentang karakteristik setiap serangga yang terdeteksi, tingkat bahaya, dan metode penanganannya. Insectpedia membantu pengguna mengenali potensi ancaman sejak dini dan meningkatkan kesadaran tentang serangga yang dapat merusak tanaman atau memengaruhi kesehatan manusia.

---

## Cara Menggunakan Aplikasi

### 1. Buka Aplikasi Insectpedia  
Saat pertama kali dibuka, pengguna akan melihat **3 halaman onboarding**.
<p align="center">
  <img src="https://github.com/user-attachments/assets/99622c1c-d729-4bd6-be5e-7a14bc616ed0" width="300">
  <img src="https://github.com/user-attachments/assets/ef7fe7bf-584a-42d0-a845-7b6ef9ea17eb" width="300">
  <img src="https://github.com/user-attachments/assets/d0d2106d-6558-4d9f-96e1-2fedec8cf4f8" width="300">
</p>


---

### 2. Registrasi Akun  
Jika belum memiliki akun, masuk ke halaman **Register**, lalu isi avatar, email, username, password, dan konfirmasi password.</br>

<img src="https://github.com/user-attachments/assets/d15a12d5-7b7f-4072-8b8c-bfdd84d33fc3" width="300">

---

### 3. Login ke Aplikasi  
Pada halaman Login, masukkan email dan password untuk masuk.</br>

<img src="https://github.com/user-attachments/assets/c6b7f2cf-df59-437f-8db2-1513fdd02185" width="300">



---

### 4. Masuk ke Home Screen  
Setelah login, pengguna diarahkan ke Home Screen sebagai pusat navigasi aplikasi.</br>

<img src="https://github.com/user-attachments/assets/6c135bd0-f05e-4727-b46c-d96dbd8717e6" width="300">


---

### 5. Melakukan Klasifikasi Serangga (Scan)

#### a. Pilih menu **Scan**

<img src="https://github.com/user-attachments/assets/8dd7a0af-5ca3-415f-b507-dbd8489f2021" width="300">


#### b. Ambil foto lewat kamera atau unggah dari galeri

<img src="https://github.com/user-attachments/assets/6d89459f-9c5f-4633-94eb-0323244858ad" width="300">

#### c. Lihat hasil klasifikasi  
Aplikasi menampilkan:
- Nama serangga  
- Tingkat bahaya
- Tingkat Percaya diri dari model 
- Karakteristik  
- Penanganan  

<img src="https://github.com/user-attachments/assets/cdbf2988-2acf-4504-bcca-de19355b1037" width="300">


---

### 6. Melihat Informasi Aplikasi (About)  
Pengguna dapat membaca tentang aplikasi dan tim pengembang.

<img src="https://github.com/user-attachments/assets/5935c44a-1e81-4942-a4ab-56987a61da52" width="300">


---

### 7. Mengelola Akun di Menu Profile  
Pengguna dapat:
- Mengganti username  
- Mengubah avatar  
- Logout  

<img src="https://github.com/user-attachments/assets/58d80a4b-b646-432b-ab33-725cf2858f73" width="300">

---

### 8. Edit Profile & Hapus Akun  
Pengguna dapat melakukan:
- **Edit Profile**: mengubah username atau avatar  
- **Hapus Akun**: menghapus akun secara permanen  

<img src="https://github.com/user-attachments/assets/13edbfbd-e32c-4e17-831f-8b331612c1f2" width="300">

---

## Fitur Utama

- Klasifikasi serangga berbahaya menggunakan AI  
- Upload gambar (kamera/galeri)  
- Informasi lengkap serangga + tingkat bahaya + penanganan  
- Onboarding  
- Autentikasi (Register & Login)  
- Edit Profile
- Mode tema lime dan amber
- Menu About
- Hapus Akun

---

## Cara Menjalankan Server/API 
### 1. Aktifkan environment
```bash
conda activate pakbmobile
```

### 2. Jalankan Server Django
```bash
python manage.py runserver
```

### 3. Ekspos Server dengan LocalTunnel
```bash
lt --port 8000 --subdomain insectpedia
```

---


### Link Google Drive

Link google Drive: https://drive.google.com/drive/folders/1FK4io247zbQIeL0uBsyy_OU95lzipElW?usp=sharing
