-- Retrieve the names of all physicians who specialize
-- in dermatology and have worked more than 22 hours.
SELECT PhysicianName
FROM PHYSICIAN, TIMECARD
WHERE SPECIALTY = 'Dermatology'
GROUP BY PhysicianName
HAVING SUM(WORKHOURS) > 22;

-- Find the names of all nurses who are directly supervised by Chris Summa.
-- Note: You must use the name. Do not hardcode the nurse ID.
SELECT NURSENAME
FROM NURSE
WHERE SUPERVISORID IN (SELECT NURSEID
                       FROM NURSE
                       WHERE NURSENAME = 'Chris Summa');

-- For each physician specialty, list the specialty, the number of physicians
-- that have that specialty, and the total number of hours worked by those physicians.
SELECT SPECIALTY, COUNT(DISTINCT PHYSICIANNAME) AS NumberOfPhysicians, SUM(TIMECARD.WORKHOURS) AS TotalWorkHours
FROM PHYSICIAN INNER JOIN TIMECARD
ON PHYSICIAN.PHYSICIANID = TIMECARD.PHYSICIANID
GROUP BY SPECIALTY;

-- Retrieve the names of all nurses who monitor at least one bed. Make sure to remove duplicates.
SELECT NURSENAME
FROM NURSE INNER JOIN BED
ON NURSE.NURSEID = BED.NURSEID
GROUP BY NURSENAME;

-- Retrieve the names of all nurses who do not monitor any beds.
SELECT NURSENAME
FROM NURSE NATURAL LEFT OUTER JOIN BED
WHERE BEDNUMBER IS NULL
GROUP BY NURSENAME; -- or use distinct to remove duplicates

-- Retrieve the names of all nurses whose supervisor's supervisor has N01 for their ID.
SELECT NURSENAME
FROM NURSE
WHERE NURSE.SUPERVISORID IN (SELECT NURSEID
                             FROM NURSE
                             WHERE SUPERVISORID = 'N01');

-- For each physician specialty, find the total number of patients whose physician has that specialty.
SELECT SPECIALTY, COUNT(PATIENTNUMBER) AS NUMBER_OF_PATIENTS
FROM PHYSICIAN, PATIENT
WHERE PHYSICIAN.PHYSICIANID = PATIENT.PHYSICIANID
GROUP BY SPECIALTY;

-- Find the average salary for all nurses who monitor at least 2 beds.
SELECT SUM(AVG(SALARY)) / COUNT(NURSE.NURSEID) AS Average_Salary
FROM NURSE INNER JOIN BED
ON NURSE.NURSEID = BED.NURSEID
WHERE NURSE.NURSEID IN (SELECT BED.NURSEID
                  FROM BED
                  GROUP BY NURSEID
                  HAVING COUNT(BED.NURSEID) >= 2)
GROUP BY NURSE.NURSEID;

-- Find the patient assigned to a bed that is monitored by the nurse with the lowest salary.
SELECT PATIENTNAME
FROM PATIENT, BED, NURSE
WHERE PATIENT.PATIENTNUMBER = BED.PATIENTNUMBER AND NURSE.NURSEID = BED.NURSEID
    AND SALARY IN (SELECT MIN(SALARY)
                   FROM NURSE);

-- Retrieve the average age of patients that are assigned to a bed.
SELECT ROUND(AVG(AGE), 2) AS Average_Age
FROM PATIENT, BED
WHERE PATIENT.PATIENTNUMBER = BED.PATIENTNUMBER;

-- Find physicians whose specialty consists of exactly 2 words.
-- For example, the query should return records for "General Practice", but not "Oncology".
-- Also, the specialty should be properly capitalized (both first and last word start with
-- an upper-case letter and rest of the word is lower-case).
-- For example, the query should return results for "General Practice” but not "general Practice".
SELECT SPECIALTY
FROM PHYSICIAN
WHERE REGEXP_LIKE(SPECIALTY, '^[A-Z][a-z]*\s[A-Z][a-z]*$');

-- Find all beds that have a room number that end in an odd number (e.g., return 101, but not 102).
SELECT *
FROM BED
WHERE REGEXP_LIKE(BED.ROOMNUMBER, '^[0-9]*[13579]$');