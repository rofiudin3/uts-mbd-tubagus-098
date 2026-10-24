-- ============================================================
-- PROYEK 1 MBD - SOAL 3: SKEMA SALAM & TABEL MAHASISWAS
-- Nama : Tubagus Rofiudin (Akhiran NIM: 098)
-- ============================================================

-- 1. Buat Skema SALAM
CREATE SCHEMA IF NOT EXISTS SALAM;

-- 2. Buat Tabel mahasiswas di dalam skema SALAM
CREATE TABLE IF NOT EXISTS SALAM.mahasiswas (
    nim VARCHAR(15) NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    angkatan INT NOT NULL,
    semester INT NOT NULL,
    ipk NUMERIC(3, 2) NOT NULL DEFAULT 0.00,
    sks_tempuh INT NOT NULL DEFAULT 0,
    status_akademik VARCHAR(15) NOT NULL DEFAULT 'AKTIF',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- a. PRIMARY KEY CONSTRAINT
    CONSTRAINT pk_mahasiswas_nim PRIMARY KEY (nim),

    -- b. UNIQUE CONSTRAINT (Email tidak boleh sama antar mahasiswa)
    CONSTRAINT uq_mahasiswas_email UNIQUE (email),

    -- c. CHECK CONSTRAINTS (Aturan validasi nilai)
    CONSTRAINT chk_mahasiswas_ipk_range CHECK (ipk >= 0.00 AND ipk <= 4.00),
    CONSTRAINT chk_mahasiswas_semester_valid CHECK (semester BETWEEN 1 AND 14),
    CONSTRAINT chk_mahasiswas_status CHECK (status_akademik IN ('AKTIF', 'CUTI', 'LULUS', 'NONAKTIF')),

    -- d. FITUR PEMBEDA: Check Constraint format domain email kampus & SKS tidak negatif
    CONSTRAINT chk_mahasiswas_email_domain CHECK (email LIKE '%@salam.ac.id'),
    CONSTRAINT chk_mahasiswas_sks_positif CHECK (sks_tempuh >= 0 AND sks_tempuh <= 160)
);

-- 3. FITUR PEMBEDA: Buat View untuk rekap predikat mahasiswa
CREATE OR REPLACE VIEW SALAM.vw_predikat_mahasiswa AS
SELECT
    nim,
    nama_lengkap,
    email,
    semester,
    ipk,
    sks_tempuh,
    status_akademik,
    CASE
        WHEN ipk >= 3.51 THEN 'Dengan Pujian (Cumlaude)'
        WHEN ipk >= 3.01 THEN 'Sangat Memuaskan'
        WHEN ipk >= 2.76 THEN 'Memuaskan'
        ELSE 'Cukup'
    END AS predikat_akademik
FROM SALAM.mahasiswas;

-- ============================================================
-- 4. INSERT DATA AWAL YANG VALID
-- ============================================================
INSERT INTO SALAM.mahasiswas (nim, nama_lengkap, email, angkatan, semester, ipk, sks_tempuh, status_akademik)
VALUES
    ('1237050098', 'Tubagus Rofiudin', 'tubagus.098@salam.ac.id', 2024, 5, 3.85, 88, 'AKTIF'),
    ('1237050001', 'Ahmad Fauzan', 'ahmad.fauzan@salam.ac.id', 2024, 5, 3.40, 86, 'AKTIF'),
    ('1237050002', 'Siti Nurhaliza', 'siti.nurhaliza@salam.ac.id', 2023, 7, 3.65, 124, 'AKTIF');

SELECT * FROM SALAM.mahasiswas;
SELECT * FROM SALAM.vw_predikat_mahasiswa;

-- ============================================================
-- 5. SKENARIO PENGUJIAN CONSTRAINT (SENGAJA DIBUAT ERROR UNTUK BUKTI)
-- Jalankan satu per satu secara terpisah saat pengujian
-- ============================================================

-- Uji 1: Pelanggaran Primary Key (NIM 1237050098 sudah ada)
-- INSERT INTO SALAM.mahasiswas (nim, nama_lengkap, email, angkatan, semester, ipk, sks_tempuh, status_akademik)
-- VALUES ('1237050098', 'Mahasiswa Duplikat NIM', 'duplikat.nim@salam.ac.id', 2024, 5, 3.20, 80, 'AKTIF');

-- Uji 2: Pelanggaran Unique Constraint (Email tubagus.098@salam.ac.id sudah dipakai)
-- INSERT INTO SALAM.mahasiswas (nim, nama_lengkap, email, angkatan, semester, ipk, sks_tempuh, status_akademik)
-- VALUES ('1237050099', 'Mahasiswa Duplikat Email', 'tubagus.098@salam.ac.id', 2024, 5, 3.10, 80, 'AKTIF');