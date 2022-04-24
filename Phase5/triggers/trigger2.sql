-- Trigger #2 (15 points). Write a trigger that will fire when a user attempts to DELETE one
-- or more rows from BED. This trigger will update the Nurse.BedsMonitored for the corresponding
-- Nurse’s ID by decreasing the value by one each time a row is removed from BED.
CREATE OR REPLACE TRIGGER DeleteBed
    AFTER DELETE ON BED
    FOR EACH ROW
BEGIN
    UPDATE NURSE
    SET BEDSMONITORED = BEDSMONITORED - 1
    WHERE NURSEID = :old.NURSEID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('bed is not monitored by a nurse');
END;
/