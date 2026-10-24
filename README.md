# Proyek 1 / UTS Manajemen Basis Data
- **Nama:** Tubagus Rofiudin
- **Akhiran NIM:** 098
- **Mata Kuliah:** Manajemen Basis Data (20100470501024)
- **Dosen Pengampu:** Wildan Budiawan Z, S.T., M.Kom

## Konfigurasi Kontainer
- **PostgreSQL 15 Alpine:** Kontainer `postgres_TubagusRofiudin` (Port Eksternal: `22098` -> `5432`)
- **pgAdmin 4:** Kontainer `pgadmin_TubagusRofiudin` (Port Eksternal: `44098` -> `80`)

## Highlight Fitur & Aktivitas Pembeda
1. **Container Healthcheck & Dependency Condition:** Kontainer `pgadmin_TubagusRofiudin` menggunakan `depends_on: condition: service_healthy` dengan pengecekan `pg_isready` pada PostgreSQL.
2. **Custom Bridge Network & Named Volumes:** Menggunakan jaringan terisolasi `salam_net_098` dan *persistent volume* `pgdata_tubagus_098` serta `pgadmin_tubagus_098`.
3. **Custom Check Constraint Domain & SKS:** Validasi email wajib berdomain `@salam.ac.id` (`chk_mahasiswas_email_domain`) dan validasi batas SKS tempuh (`0 - 160` SKS).
4. **View Akademik Otomatis (`SALAM.vw_predikat_mahasiswa`):** Menghitung predikat kelulusan (*Cumlaude*, *Sangat Memuaskan*, *Memuaskan*, *Cukup*) secara otomatis dari IPK dan digunakan untuk pengujian akses baca `bi_dev`.