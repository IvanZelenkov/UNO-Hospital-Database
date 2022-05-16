-- Trigger #3 (30 points). Write a trigger that fires when the nurse ID for a bed record is changed
-- (i.e., an UPDATE). This trigger will update the Nurse.BedsMonitored for both the previous Nurse
-- and the new Nurse using their respective ID’s. If the existing Nurse.BedsMonitored value for the
-- new Nurse in the update is equal to 2, then the nurse is too busy so your trigger will cancel
-- the UPDATE and display an error message stating that the Nurse is too busy (similar to the first trigger).
CREATE OR REPLACE TRIGGER UpdateBed
    BEFORE UPDATE ON BED
    FOR EACH ROW
DECLARE
    bedsMonitoredNew NURSE.BEDSMONITORED%type;
BEGIN
    SELECT BEDSMONITORED
    INTO bedsMonitoredNew
    FROM NURSE
    WHERE NURSEID = :new.NURSEID;

    IF bedsMonitoredNew = 2 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Error');
    ELSE
        UPDATE NURSE
        SET BEDSMONITORED = BEDSMONITORED - 1
        WHERE NURSEID = :old.NURSEID;

        UPDATE NURSE
        SET BEDSMONITORED = BEDSMONITORED + 1
        WHERE NURSEID = :new.NURSEID;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('bed is not monitored by a nurse');
END;
/
