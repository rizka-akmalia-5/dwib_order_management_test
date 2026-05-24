Langkah-Langkah pengerjaan Tugas :
1. Identifikasi Kebutuhan Bisnis :
   - Tentukan stakeholder terkait
   - Tentukan pertanyaan bisnis yang ingin dijawab
   - Tentukan metrics dan tabel yang akan digunakan
   - Tentukan tipe dan jenis data beserta ketentuannya
2. Membuat repository di github
   - Membuat repository project dan invite collaborator (atur publik atau privat)
   - Membuat branch masing-masing, jangan di cloning ke main dulu
   - Melakukan cloning ke komputer lokal (unduh proyek menggunakan git clone)
   - Masuk ke folder yang sudah diunduh
3. Membuat database sesuai domain yang dipilih :
   - Membuat file generator.py yang berisi ketentuan database dan jenis data yang diperlukan (data master)
   - Menentukan grain atau baris setiap data yang dihasilkan
   - Menghubungkan dengan faker dan script python agar memperoleh data sintesis
   - Membuat perancangan database dalam menangani perubahan data (SCD)
   - Jika sudah berhasil, maka akan ada tabel baru berbentuk csv di folder vscode
5. Implementasi pipeline Airflow
   - Download docker desktop dan nyalakan
   - Buat file docker-compose.yml lalu simpan
   - Buat folder dags dengan cara mkdir dags
   - Nyalakan mesin docker menggunakan docker-compose up -d
   - Jika sudah oke, buka browser lalu ketik localhost:8080
   - Jika masih belum oke, matikan dulu mesinnya docker-compose down lalu hidupkan lagi
   - Cek nyawa docker apakah mati atau hidup di docker ps
   - Jika sudah berhasil masuk localhost, login dengan password dan username airflow. Kalo tidak bisa ganti ini di terminal
     docker exec -it apache_airflow airflow users create --username admin --firstname Admin --lastname Admin --role Admin --email admin@example.com --password admin
   - Jika sudah berhasil masuk, buat pipeline di airflow/dags/order_management_pipeline.py (otomatis akan memasukkan file csv dari folder raw data ke database postgreSQL
   - Kembali ke browser localhost dan refresh, harusnya akan masuk file ETL database, kalo misalnya gagal, berati harus install librari dulu :
     docker exec -it --user root apache_airflow pip install pandas sqlalchemy psycopg2-binary
     docker exec -it --user root apache_airflow_scheduler pip install pandas sqlalchemy psycopg2-binary
   - Jika sudah berhasil di localhost, maka aktifkan tombol biru dan Trigger DAG, tunggu sampe hijau tua
6. Memulai dBT dan menyambungkan ke postgreSQL
   - Buka terminal baru di vscode lalu pip install dbt-postgres
   - Buat project dbt baru dbt init nama_proyek_mu
   - Atur file profiles.yml
   - Tes koneksi dengan dbt debug
   - Atur file dbt_project.yml
   - Isi yang ada di profiles.yml dan dbt_project harus sama
   - Cek port yang digunakan apakah bentrok atau tidak (aman pake 5433)
   - Tes koneksi sampe hasil dbt debug nya oke
   - Jika sudah, masuk ke folder dbt_project lalu lakukan dbt compile dan dbt run
   - Hapus model contoh bawaan dbt, lalu buat folder bertingkat di dalam models yang berisi staging, dimension, dan marts
   - Buat file baru yang formatnya .sql dari setiap tabel csv yang ada, lalu hubungan pada folder dimension dan folder marts.
   - Buat file src_raw.yml dulu untuk menghubungkan antar data raw
   - Cek tipe data, struktur tabel dan jenis data sebelum di save
   - Jika semua file sudah dibuat, maka pada terminal ketik dbt clean, compile dan dbt run
7. Membuat visualisasi data dengan kueri
   - Koneksikan akun metabase menggunakan docker-compose.yml
   - Menjalankan airflow docker-compose up -d
   - Membuka port 3000 di localhost
   - Jika berhasil masuk, lakukan registrasi, untuk host, dw password dll, sesuaikan dengan docker-compose.yml
   - Jika sudah berhasil masuk, maka buatlah beberapa pernyataan dengan menggunakan query
   - Lalu, pilih visualization dan save
   - Membuat dashboard dan menyusunnya berdasarkan businness question yg sudah dijawab
   - Tambahkan filter jika dibutuhkan
