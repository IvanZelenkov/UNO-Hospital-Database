-- Find all nurses (their names) with a salary grater than $85,000
SELECT NURSENAME
FROM NURSE
WHERE SALARY > 85000;

-- Find all the “surgery” (for the specialty) physicians and sort the query output by names (any direction).
SELECT *
FROM PHYSICIAN
WHERE SPECIALTY = 'Surgery'
ORDER BY PHYSICIANNAME;

-- Find all physicians with medicine in their specialty name (hint: remember the LIKE operator and case sensitivity)
SELECT *
FROM PHYSICIAN
WHERE LOWER(SPECIALTY) LIKE '%medicine%';

-- Find all nurses who do not have a supervisor
SELECT *
FROM NURSE
WHERE SUPERVISORID IS NULL;

-- Find the names of all nurses with a salary between $70,000 and $80,000 (inclusive)
SELECT NURSENAME
FROM NURSE
WHERE SALARY BETWEEN 70000 AND 80000;

-- Find the names of the physicians who have a specialty containing “ology”
SELECT PhysicianName
FROM Physician
WHERE Specialty LIKE '%ology%';

-- Find the minimum and maximum salaries amongst all nurses. Use only one query
SELECT MIN(SALARY), MAX(SALARY)
FROM NURSE;

-- Find the average salary for all nurses
SELECT AVG(SALARY)
FROM NURSE;

-- Find the name of the nurse that has the highest salary
SELECT NURSENAME
FROM NURSE
WHERE SALARY = (SELECT MAX(SALARY) FROM NURSE);

-- Find the nurses with a salary less than the average overall salary for all nurses + 20% (i.e., less than 1.2 * average salary)
-- Average salary (+20%) = 86300 * 1.2 = 103560
SELECT *
FROM NURSE
WHERE SALARY < (SELECT AVG(SALARY) * 1.2 FROM NURSE);