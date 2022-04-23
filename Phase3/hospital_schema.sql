DROP TABLE TimeCard;
DROP TABLE Bed;
DROP TABLE Nurse;
DROP TABLE Patient;
DROP TABLE Physician;

CREATE TABLE Physician (
    PhysicianID VARCHAR2(4),
    PhysicianName VARCHAR2(30),
    Specialty VARCHAR2(40),
    CONSTRAINT PhysicianPK PRIMARY KEY (PhysicianID)
);

CREATE TABLE TimeCard (
    PhysicianID VARCHAR2(4),
    CardDate DATE,
    WorkHours Number,
    CONSTRAINT TimeCardPK PRIMARY KEY (PhysicianID, CardDate),
    CONSTRAINT PhysicianFK_TimeCardTable FOREIGN KEY (PhysicianID) REFERENCES Physician(PhysicianID)
);

CREATE TABLE Patient (
    PatientNumber VARCHAR2(4),
    PatientName VARCHAR2(30),
    Age NUMBER,
    PhysicianID VARCHAR2(4),
    CONSTRAINT PatientPK PRIMARY KEY (PatientNumber),
    CONSTRAINT PhysicianFK_PatientTable FOREIGN KEY (PhysicianID) REFERENCES Physician(PhysicianID)
);

CREATE TABLE Nurse (
    NurseID VARCHAR2(4),
    NurseName VARCHAR2(30),
    Salary NUMBER,
    SupervisorID VARCHAR2(4),
    CONSTRAINT NursePK PRIMARY KEY (NurseID),
    CONSTRAINT NurseFK FOREIGN KEY (SupervisorID) REFERENCES Nurse(NurseID)
);

CREATE TABLE Bed (
    BedNumber VARCHAR2(4),
    RoomNumber Number,
    Unit VARCHAR2(30),
    PatientNumber VARCHAR2(4),
    NurseID VARCHAR2(4),
    CONSTRAINT BedPK PRIMARY KEY (BedNumber),
    CONSTRAINT PatientFK FOREIGN KEY (PatientNumber) REFERENCES Patient(PatientNumber),
    CONSTRAINT NurseFK_BedTable FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID)
);