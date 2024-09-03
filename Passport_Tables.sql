
#Normalisation#
    
Let’s normalize the passport application database step by step, from 1NF to 3NF.

1NF (First Normal Form)
To achieve 1NF, we must ensure the following for each table:

Every column must contain atomic (indivisible) values.
There should be no repeating groups or arrays.
Each table must have a unique primary key.
We already have a good starting point with your entities, but we'll review and adjust them to ensure they meet the criteria for 1NF.

Identified Issues:
Multiple contact numbers for emergency contacts.
Multiple addresses for applicants.
Possible multiple criminal proceedings for applicants.
Normalized Tables in 1NF:
Applicant Table:

Primary Key: ApplicantID
Attributes: GivenName, Surname, DateOfBirth, RaceOfBirth, Gender, MaritalStatus, Citizenship, PAN, VoterID, EmploymentType, OrganizationName, EducationalQualification, AadhaarNumber
All attributes are atomic, so no changes needed.

FamilyDetails Table:

Primary Key: FamilyID
Attributes: ApplicantID (Foreign Key), FatherName, MotherName, LegalGuardianName, SpouseName, FatherPassportNumber, MotherPassportNumber, FatherNationality, MotherNationality, MotherStatus
This is already in 1NF since each attribute contains atomic values.

EmergencyContact Table:

Primary Key: ContactID
Attributes: ApplicantID (Foreign Key), Name, ContactAddress, MobileNumber, TelephoneNumber, EmailID
Since applicants can have multiple emergency contacts, this structure supports a one-to-many relationship and complies with 1NF.

Address Table:

Primary Key: AddressID
Attributes: ApplicantID (Foreign Key), AddressType, HouseNoStreetName, City, District, State, PIN, PoliceStation, MobileNumber, TelephoneNumber, EmailID
Each applicant can have multiple addresses (e.g., permanent, temporary), and this table supports that with a one-to-many relationship.

CriminalProceedings Table:

Primary Key: ProceedingID
Attributes: ApplicantID (Foreign Key), OffenceDescription, Pending, CourtDetails, WarrantDetails, ArrestDetails, DepartureProhibition
Since there could be multiple criminal proceedings for one applicant, this structure is already in 1NF.

Passport Table:

Primary Key: PassportID
Attributes: ApplicantID (Foreign Key), PassportNumber, TypeOfApplication, TypeOfBooklet, ValidityRequired, DateOfIssue, DateOfExpiry, ReissueReason, PersonalParticularsChronology
This table contains atomic values and complies with 1NF.

FeeDetails Table:

Primary Key: FeeID
Attributes: ApplicantID (Foreign Key), FeeAmount, DDNumber, DDIssueDate, BankName, BranchName
Fee details are atomic, so no changes needed.

    
2NF (Second Normal Form)
To achieve 2NF, the following must be ensured:

The table is already in 1NF.
All non-key attributes are fully dependent on the entire primary key (no partial dependencies).
Issues Identified:
Some non-key attributes are dependent only on a part of the primary key (such as in cases where composite keys are used).
Steps for 2NF:
Applicant Table:

The Applicant table is in 2NF since all attributes depend on the primary key ApplicantID.
FamilyDetails Table:

All attributes depend on FamilyID, and the table is in 2NF.
EmergencyContact Table:

No partial dependencies; ContactID uniquely identifies each emergency contact, so the table is in 2NF.
Address Table:

Each address is uniquely identified by AddressID, and all attributes are dependent on it. Therefore, this table is also in 2NF.
CriminalProceedings Table:

All attributes depend on ProceedingID, and the table is in 2NF.
Passport Table:

No partial dependencies exist, so the Passport table is in 2NF.
FeeDetails Table:

Each attribute is fully dependent on FeeID, and the table is in 2NF.

    
3NF (Third Normal Form)
To achieve 3NF, we need to ensure:

The table is already in 2NF.
There are no transitive dependencies (i.e., non-key attributes should not depend on other non-key attributes).
Issues Identified:
There may be transitive dependencies in the FamilyDetails and FeeDetails tables.
Steps for 3NF:
Applicant Table:

The Applicant table does not have transitive dependencies, so it is in 3NF.
FamilyDetails Table:

No transitive dependencies are present. Attributes like FatherName, MotherName, etc., are only dependent on FamilyID. The table is in 3NF.
EmergencyContact Table:

The EmergencyContact table does not have any transitive dependencies. It is in 3NF.
Address Table:

The Address table is free of transitive dependencies, so it is in 3NF.
CriminalProceedings Table:

No transitive dependencies exist here, so the table is in 3NF.
Passport Table:

The Passport table is already in 3NF as there are no transitive dependencies.
FeeDetails Table:

Attributes like BankName and BranchName depend directly on FeeID, and there are no transitive dependencies. Therefore, it is in 3NF.                   

    
The passport application database is fully normalized through 1NF, 2NF, and 3NF. It is ensured that each table is well-structured, ensuring data integrity, minimizing redundancy, and making the system scalable and easy to maintain.CREATE DATABASE PASSPORT;
use passport;

    

CREATE TABLE Applicant (
    ApplicantID CHAR(6) PRIMARY KEY,
    GivenName VARCHAR(25),
    Surname VARCHAR(20),
    DateOfBirth DATE,
    PlaceOfBirth VARCHAR(100),
    Gender VARCHAR(10),
    MaritalStatus VARCHAR(10),
    Citizenship VARCHAR(15),
    PAN VARCHAR(20),
    VoterID VARCHAR(20),
    EmploymentType VARCHAR(50),
    OrganizationName VARCHAR(50),
    EducationalQualification VARCHAR(50),
    AadhaarNumber VARCHAR(12)
);

CREATE TABLE Passport (
    PassportID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    PassportNumber VARCHAR(20),
    TypeOfApplication VARCHAR(20),
    TypeOfBooklet VARCHAR(20),
    ValidityRequired VARCHAR(20),
    DateOfIssue DATE,
    DateOfExpiry DATE,
    PlaceOfIssue VARCHAR(25),
    ReissueReason VARCHAR(100),
    PersonalParticularChangeReason VARCHAR(100),
    PreviousPassportNumber VARCHAR(20),
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

CREATE TABLE FamilyDetails (
    FamilyID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    FatherName VARCHAR(25),
    MotherName VARCHAR(25),
    LegalGuardianName VARCHAR(25),
    SpouseName VARCHAR(25),
    FatherPassportNumber VARCHAR(20),
    MotherPassportNumber VARCHAR(20),
    FatherNationality VARCHAR(20),
    MotherNationality VARCHAR(20),
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

CREATE TABLE Address (
    AddressID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    AddressType VARCHAR(20),
    HouseNoStreetName VARCHAR(100),
    City VARCHAR(20),
    District VARCHAR(20),
    StateUT VARCHAR(20),
    PIN CHAR(6),
    PoliceStation VARCHAR(100),
    MobileNumber CHAR(10),
    TelephoneNumber CHAR(11),
    EmailID VARCHAR(50),
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

CREATE TABLE EmergencyContact (
    ContactID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    Name VARCHAR(25),
    ContactAddress VARCHAR(50),
    MobileNumber CHAR(10),
    TelephoneNumber CHAR(11),
    EmailID VARCHAR(50),
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

CREATE TABLE CriminalProceedings (
    ProceedingID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    OffenceDescription TEXT,
    Pending BOOLEAN,
    CourtDetails TEXT,
    WarrantDetails TEXT,
    ArrestDetails TEXT,
    DepartureProhibition BOOLEAN,
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

CREATE TABLE FeeDetails (
    FeeID CHAR(6) PRIMARY KEY,
    ApplicantID CHAR(6),
    FeeAmount DECIMAL(10, 2),
    DDNumber VARCHAR(20),
    DDIssueDate DATE,
    DDExpiryDate DATE,
    BankName VARCHAR(25),
    BranchName VARCHAR(25),
    FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID)
);

INSERT INTO Applicant (GivenName, Surname, DateOfBirth, PlaceOfBirth, Gender, MaritalStatus, Citizenship, PAN, VoterID, EmploymentType, OrganizationName, EducationalQualification, AadhaarNumber)
VALUES 
('Rishab', 'Kalra', '1995-08-25', 'New Delhi', 'Male', 'Single', 'Indian', 'ABCPG1234L', 'DL/06/123456', 'Employed', 'ABC Corp', 'MBA', '123456789012'),
('Animesh', 'Sharma', '1988-11-15', 'Mumbai', 'Female', 'Married', 'Indian', 'BCDPG5678L', 'MH/01/654321', 'Self-Employed', 'XYZ Pvt Ltd', 'B.Tech', '987654321098'),
('Amit', 'Patel', '1990-05-10', 'Ahmedabad', 'Male', 'Married', 'Indian', 'CDPQH7890L', 'GJ/02/789654', 'Unemployed', NULL, 'B.Com', '654321098765');

INSERT INTO Passport (ApplicantID, PassportNumber, TypeOfApplication, TypeOfBooklet, ValidityRequired, DateOfIssue, DateOfExpiry, PlaceOfIssue, ReissueReason, PersonalParticularChangeReason, PreviousPassportNumber)
VALUES
(1, 'Z1234567', 'New', '36 Pages', '10 Years', '2024-01-01', '2034-01-01', 'New Delhi', NULL, NULL, NULL),
(2, 'Y9876543', 'Reissue', '60 Pages', '5 Years', '2022-12-01', '2027-12-01', 'Mumbai', 'Lost Passport', NULL, 'X5678901'),
(3, 'X4567890', 'New', '36 Pages', '10 Years', '2023-05-10', '2033-05-10', 'Ahmedabad', NULL, NULL, NULL);

INSERT INTO Address (ApplicantID, AddressType, HouseNoStreetName, City, District, StateUT, PIN, PoliceStation, MobileNumber, TelephoneNumber, EmailID)
VALUES
(1, 'Present', 'A-123, Sector-10', 'New Delhi', 'New Delhi', 'Delhi', '110010', 'Chanakyapuri', '9876543210', '011-2345678', 'rishi.goswami@email.com'),
(1, 'Permanent', 'B-456, Sector-15', 'Gurgaon', 'Gurgaon', 'Haryana', '122001', 'DLF Phase 1', '9876543211', '0124-5678901', 'rishi.goswami@email.com'),
(2, 'Present', 'C-789, Powai', 'Mumbai', 'Mumbai', 'Maharashtra', '400076', 'Powai Police Station', '9988776655', NULL, 'anjali.sharma@email.com'),
(2, 'Permanent', 'D-101, Andheri', 'Mumbai', 'Mumbai', 'Maharashtra', '400058', 'Andheri Police Station', '9988776656', '022-3456789', 'anjali.sharma@email.com'),
(3, 'Present', 'E-234, Navrangpura', 'Ahmedabad', 'Ahmedabad', 'Gujarat', '380009', 'Navrangpura PS', '9876541234', NULL, 'amit.patel@email.com');

INSERT INTO EmergencyContact (ApplicantID, Name, ContactAddress, MobileNumber, TelephoneNumber, EmailID)
VALUES
(1, 'Rajesh Goswami', 'B-456, Sector-15, Gurgaon, Haryana, 122001', '9876543211', '0124-5678901', 'rajesh.goswami@email.com'),
(2, 'Ravi Sharma', 'D-101, Andheri, Mumbai, Maharashtra, 400058', '9988776656', '022-3456789', 'ravi.sharma@email.com'),
(3, 'Neha Patel', 'E-234, Navrangpura, Ahmedabad, Gujarat, 380009', '9876541235', NULL, 'neha.patel@email.com');

INSERT INTO CriminalProceedings (ApplicantID, OffenceDescription, Pending, CourtDetails, WarrantDetails, ArrestDetails, DepartureProhibition)
VALUES
(1, NULL, 0, NULL, NULL, NULL, 0),
(2, 'Traffic Violation', 1, 'Mumbai High Court', 'Warrant No. 123', 'Arrested on 2022-06-10', 0),
(3, NULL, 0, NULL, NULL, NULL, 0);

INSERT INTO FeeDetails (ApplicantID, FeeAmount, DDNumber, DDIssueDate, DDExpiryDate, BankName, BranchName)
VALUES
(1, 1500.00, 'DD123456', '2024-01-10', '2024-07-10', 'State Bank of India', 'Chanakyapuri'),
(2, 2000.00, 'DD654321', '2022-12-05', '2023-06-05', 'ICICI Bank', 'Powai'),
(3, 1500.00, 'DD789012', '2023-05-15', '2023-11-15', 'HDFC Bank', 'Navrangpura');


