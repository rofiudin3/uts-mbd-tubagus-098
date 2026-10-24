-- ============================================================
-- PROYEK 1 MBD - SOAL 4: MANAJEMEN USER & ROLE PRIVILEGE
-- Nama : Tubagus Rofiudin (Akhiran NIM: 098)
-- ============================================================

-- Pastikan kembali ke superuser postgres terlebih dahulu
RESET ROLE;

-- 1. Buat 3 User Baru (dengan password)
DROP ROLE IF EXISTS backend_dev, bi_dev, data_engineer;
CREATE USER backend_dev WITH PASSWORD 'backend_098';
CREATE USER bi_dev WITH PASSWORD 'bi_098';
CREATE USER data_engineer WITH PASSWORD 'dataeng_098';

-- 2. Atur Hak Akses backend_dev (CRUD semua tabel di skema SALAM)
GRANT USAGE ON SCHEMA SALAM TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;

-- 3. Atur Hak Akses bi_dev (Hanya READ / SELECT semua tabel & view di skema SALAM)
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- 4. Atur Hak Akses data_engineer (CREATE, MODIFY/ALTER, DROP semua objek + CRUD semua tabel)
GRANT ALL PRIVILEGES ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
ALTER SCHEMA SALAM OWNER TO data_engineer;
ALTER TABLE SALAM.mahasiswas OWNER TO data_engineer;
ALTER VIEW SALAM.vw_predikat_mahasiswa OWNER TO data_engineer;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA SALAM GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- ============================================================
-- 5. SKENARIO PENGUJIAN HAK AKSES (ROLE PRIVILEGE)
-- ============================================================

-- A. Pengujian User bi_dev (Berhasil SELECT, Ditolak INSERT)
SET ROLE bi_dev;
SELECT current_user AS user_aktif, * FROM SALAM.vw_predikat_mahasiswa;
-- INSERT INTO SALAM.mahasiswas (nim, nama_lengkap, email, angkatan, semester, ipk, sks_tempuh, status_akademik)
-- VALUES ('1237050055', 'Coba Insert dari BI', 'coba.bi@salam.ac.id', 2024, 5, 3.50, 80, 'AKTIF');

-- B. Pengujian User backend_dev (Berhasil CRUD, Ditolak CREATE TABLE)
SET ROLE backend_dev;
INSERT INTO SALAM.mahasiswas (nim, nama_lengkap, email, angkatan, semester, ipk, sks_tempuh, status_akademik)
VALUES ('1237050088', 'Rizky Pratama', 'rizky.088@salam.ac.id', 2024, 5, 3.30, 84, 'AKTIF');
UPDATE SALAM.mahasiswas SET ipk = 3.75 WHERE nim = '1237050088';
DELETE FROM SALAM.mahasiswas WHERE nim = '1237050002';
SELECT current_user AS user_aktif, * FROM SALAM.mahasiswas;
-- CREATE TABLE SALAM.tabel_ilegal (id INT PRIMARY KEY);

-- C. Pengujian User data_engineer (Berhasil CREATE, ALTER/MODIFY, CRUD, dan DROP)
SET ROLE data_engineer;
CREATE TABLE SALAM.matakuliahs_098 (
    kode_mk VARCHAR(10) PRIMARY KEY,
    nama_mk VARCHAR(100) NOT NULL
);
ALTER TABLE SALAM.matakuliahs_098 ADD COLUMN sks INT NOT NULL DEFAULT 3;
INSERT INTO SALAM.matakuliahs_098 (kode_mk, nama_mk, sks)
VALUES ('IF201004', 'Manajemen Basis Data', 3);
SELECT current_user AS user_aktif, * FROM SALAM.matakuliahs_098;
DROP TABLE SALAM.matakuliahs_098;

-- Kembalikan role ke postgres
RESET ROLE;