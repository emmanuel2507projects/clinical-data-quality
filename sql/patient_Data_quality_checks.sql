/*
Clinical Data Quality Checks
Purpose:
- Identify missing critical fields
- Detect duplicate patient records
- Validate basic data integrity rules
*/

-- 1. Check for missing critical patient identifiers
SELECT
    patient_id,
    date_of_birth,
    sex
FROM patients
WHERE patient_id IS NULL
   OR date_of_birth IS NULL
   OR sex IS NULL;

-- 2. Detect duplicate patient records
SELECT
    patient_id,
    COUNT(*) AS record_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- 3. Validate age range (e.g. paediatric focus)
SELECT
    patient_id,
    date_of_birth
FROM patients
WHERE date_of_birth > CURRENT_DATE
   OR date_of_birth < DATE '1900-01-01';

-- 4. Check referential integrity with encounters table
SELECT
    e.encounter_id,
    e.patient_id
FROM encounters e
LEFT JOIN patients p
    ON e.patient_id = p.patient_id
WHERE p.patient_id IS NULL;
