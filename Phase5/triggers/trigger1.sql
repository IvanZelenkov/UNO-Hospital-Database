-- Trigger #1 (15 points). Write a trigger that will fire when you INSERT a row into the Bed table.
-- This trigger will check the value of BedsMonitored for the corresponding Nurse’s ID.
-- If Nurse.BedsMonitored is less than 2, then a nurse can monitor more beds.
-- If Nurse.BedsMonitored is equal to 2, then the nurse is too busy so your trigger
-- will cancel the INSERT and display a custom error message stating that the Nurse is too busy.
-- Also, be sure to handle the inserts for bed where the NurseID is NULL.
CREATE OR REPLACE TRIGGER AddBed
    BEFORE INSERT ON BED
    FOR EACH ROW
DECLARE
    bedsMonitored NURSE.BEDSMONITORED%type;
BEGIN
    SELECT BEDSMONITORED
    INTO bedsMonitored
    FROM NURSE
    WHERE NURSEID = :new.NURSEID;

    IF bedsMonitored >= 0 AND bedsMonitored < 2 THEN
        UPDATE NURSE
        SET BEDSMONITORED = BEDSMONITORED + 1
        WHERE NURSEID = :new.NURSEID;
        DBMS_OUTPUT.PUT_LINE('nurse can monitor more beds');
    ELSIF bedsMonitored = 2 THEN
        RAISE_APPLICATION_ERROR(-20101, 'nurse is too busy');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('bed is not monitored by a nurse');
END;
/