USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE HEALTHCARE_HOL_WH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE;

CREATE OR REPLACE DATABASE HEALTHCARE_HOL_DB;
CREATE OR REPLACE SCHEMA HEALTHCARE_HOL_DB.CLINICAL;
CREATE OR REPLACE SCHEMA HEALTHCARE_HOL_DB.OPERATIONS;

CREATE OR REPLACE ROLE HEALTHCARE_HOL_ROLE;
GRANT USAGE ON WAREHOUSE HEALTHCARE_HOL_WH TO ROLE HEALTHCARE_HOL_ROLE;
GRANT ALL ON DATABASE HEALTHCARE_HOL_DB TO ROLE HEALTHCARE_HOL_ROLE;
GRANT ALL ON ALL SCHEMAS IN DATABASE HEALTHCARE_HOL_DB TO ROLE HEALTHCARE_HOL_ROLE;
GRANT ROLE HEALTHCARE_HOL_ROLE TO ROLE ACCOUNTADMIN;

USE DATABASE HEALTHCARE_HOL_DB;
USE SCHEMA CLINICAL;
USE WAREHOUSE HEALTHCARE_HOL_WH;

CREATE OR REPLACE STAGE HEALTHCARE_HOL_DB.CLINICAL.PDF_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE STAGE HEALTHCARE_HOL_DB.CLINICAL.SEMANTIC_MODELS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.DEPARTMENTS (
  DEPARTMENT_ID INTEGER,
  DEPARTMENT_NAME VARCHAR(100),
  FLOOR INTEGER,
  BED_COUNT INTEGER,
  MANAGER_NAME VARCHAR(100)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.DEPARTMENTS VALUES
(1, 'Emergency', 1, 20, 'Dr. Sarah Mitchell'),
(2, 'ICU', 2, 12, 'Dr. James Chen'),
(3, 'Cardiology', 3, 16, 'Dr. Maria Santos'),
(4, 'Orthopedics', 3, 14, 'Dr. Robert Kim'),
(5, 'Neurology', 4, 10, 'Dr. Lisa Park'),
(6, 'Oncology', 4, 12, 'Dr. David Brown'),
(7, 'Pediatrics', 5, 18, 'Dr. Emily Watson'),
(8, 'General Medicine', 2, 24, 'Dr. Michael Torres');

CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.PROVIDERS (
  PROVIDER_ID INTEGER,
  FIRST_NAME VARCHAR(50),
  LAST_NAME VARCHAR(50),
  SPECIALTY VARCHAR(100),
  DEPARTMENT_ID INTEGER,
  LICENSE_NUMBER VARCHAR(20),
  HIRE_DATE DATE,
  STATUS VARCHAR(20)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.PROVIDERS VALUES
(1, 'Sarah', 'Mitchell', 'Emergency Medicine', 1, 'MD-10234', '2015-03-12', 'Active'),
(2, 'James', 'Chen', 'Critical Care', 2, 'MD-10456', '2012-07-01', 'Active'),
(3, 'Maria', 'Santos', 'Cardiology', 3, 'MD-10789', '2018-01-15', 'Active'),
(4, 'Robert', 'Kim', 'Orthopedic Surgery', 4, 'MD-11023', '2016-09-20', 'Active'),
(5, 'Lisa', 'Park', 'Neurology', 5, 'MD-11345', '2019-04-10', 'Active'),
(6, 'David', 'Brown', 'Oncology', 6, 'MD-11567', '2014-11-30', 'Active'),
(7, 'Emily', 'Watson', 'Pediatrics', 7, 'MD-11890', '2020-06-01', 'Active'),
(8, 'Michael', 'Torres', 'Internal Medicine', 8, 'MD-12123', '2013-02-28', 'Active'),
(9, 'Jennifer', 'Adams', 'Emergency Medicine', 1, 'MD-12456', '2017-08-15', 'Active'),
(10, 'William', 'Lee', 'Cardiology', 3, 'MD-12789', '2021-01-10', 'Active'),
(11, 'Amanda', 'Johnson', 'Critical Care', 2, 'MD-13012', '2016-05-22', 'Active'),
(12, 'Daniel', 'Garcia', 'Neurology', 5, 'MD-13345', '2019-12-01', 'Active'),
(13, 'Rachel', 'Thompson', 'Oncology', 6, 'MD-13567', '2015-07-14', 'Active'),
(14, 'Christopher', 'White', 'Orthopedic Surgery', 4, 'MD-13890', '2018-10-05', 'Active'),
(15, 'Stephanie', 'Davis', 'Pediatrics', 7, 'MD-14123', '2022-03-20', 'Active'),
(16, 'Andrew', 'Wilson', 'Internal Medicine', 8, 'MD-14456', '2014-06-18', 'Active'),
(17, 'Nicole', 'Martinez', 'Emergency Medicine', 1, 'MD-14789', '2020-09-01', 'Active'),
(18, 'Kevin', 'Anderson', 'Cardiology', 3, 'MD-15012', '2017-11-11', 'On Leave'),
(19, 'Laura', 'Taylor', 'General Surgery', 8, 'MD-15345', '2016-01-25', 'Active'),
(20, 'Brian', 'Jackson', 'Critical Care', 2, 'MD-15678', '2021-07-01', 'Active'),
(21, 'Michelle', 'Harris', 'Pediatrics', 7, 'MD-15901', '2019-05-15', 'Active'),
(22, 'Thomas', 'Clark', 'Neurology', 5, 'MD-16234', '2015-12-10', 'Active'),
(23, 'Jessica', 'Lewis', 'Internal Medicine', 8, 'MD-16567', '2023-01-08', 'Active'),
(24, 'Ryan', 'Robinson', 'Orthopedic Surgery', 4, 'MD-16890', '2018-04-20', 'Active'),
(25, 'Megan', 'Walker', 'Oncology', 6, 'MD-17123', '2020-02-14', 'Active');

CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.PATIENTS (
  PATIENT_ID INTEGER,
  FIRST_NAME VARCHAR(50),
  LAST_NAME VARCHAR(50),
  DOB DATE,
  GENDER VARCHAR(10),
  INSURANCE_TYPE VARCHAR(30),
  PRIMARY_DIAGNOSIS VARCHAR(200),
  ADMISSION_DATE DATE,
  DISCHARGE_DATE DATE,
  STATUS VARCHAR(20)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.PATIENTS
SELECT 1, 'John', 'Smith', '1958-03-15', 'Male', 'Medicare', 'Acute myocardial infarction', DATEADD(DAY, -107, CURRENT_DATE()), DATEADD(DAY, -100, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 2, 'Mary', 'Johnson', '1945-07-22', 'Female', 'Medicare', 'Congestive heart failure', DATEADD(DAY, -104, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 3, 'Robert', 'Williams', '1972-11-30', 'Male', 'Commercial', 'Type 2 diabetes with complications', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -98, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 4, 'Patricia', 'Brown', '1965-04-18', 'Female', 'Commercial', 'Pneumonia', DATEADD(DAY, -100, CURRENT_DATE()), DATEADD(DAY, -94, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 5, 'Michael', 'Jones', '1980-09-05', 'Male', 'Medicaid', 'Appendicitis', DATEADD(DAY, -97, CURRENT_DATE()), DATEADD(DAY, -95, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 6, 'Linda', 'Davis', '1953-01-28', 'Female', 'Medicare', 'Hip fracture', DATEADD(DAY, -94, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 7, 'James', 'Miller', '1990-06-12', 'Male', 'Commercial', 'Concussion', DATEADD(DAY, -92, CURRENT_DATE()), DATEADD(DAY, -90, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 8, 'Barbara', 'Wilson', '1948-12-03', 'Female', 'Medicare', 'Stroke', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 9, 'David', 'Moore', '1975-08-20', 'Male', 'Commercial', 'Knee replacement', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 10, 'Susan', 'Taylor', '1960-02-14', 'Female', 'Medicare', 'Breast cancer', DATEADD(DAY, -84, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 11, 'Richard', 'Anderson', '1942-05-09', 'Male', 'Medicare', 'COPD exacerbation', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 12, 'Jessica', 'Thomas', '1988-10-25', 'Female', 'Commercial', 'Pregnancy complications', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 13, 'Charles', 'Jackson', '1970-07-17', 'Male', 'Medicaid', 'Sepsis', DATEADD(DAY, -76, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 14, 'Karen', 'White', '1955-03-30', 'Female', 'Medicare', 'Atrial fibrillation', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 15, 'Daniel', 'Harris', '1985-12-08', 'Male', 'Commercial', 'Back surgery', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 16, 'Nancy', 'Martin', '1950-09-22', 'Female', 'Medicare', 'Lung cancer', DATEADD(DAY, -69, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 17, 'Paul', 'Garcia', '1978-04-05', 'Male', 'Self-Pay', 'Traumatic brain injury', DATEADD(DAY, -66, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 18, 'Betty', 'Martinez', '1962-11-18', 'Female', 'Medicaid', 'Diabetic ketoacidosis', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 19, 'Mark', 'Robinson', '1995-01-30', 'Male', 'Commercial', 'Sports injury - ACL tear', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 20, 'Dorothy', 'Clark', '1940-06-14', 'Female', 'Medicare', 'Urinary tract infection', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 21, 'George', 'Rodriguez', '1968-08-07', 'Male', 'Commercial', 'Acute pancreatitis', DATEADD(DAY, -56, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 22, 'Helen', 'Lewis', '1957-02-19', 'Female', 'Medicare', 'Coronary artery disease', DATEADD(DAY, -53, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 23, 'Kenneth', 'Lee', '1983-05-11', 'Male', 'Commercial', 'Gallbladder removal', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 24, 'Sandra', 'Walker', '1947-10-26', 'Female', 'Medicare', 'Chronic kidney disease', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 25, 'Steven', 'Hall', '1973-03-08', 'Male', 'Medicaid', 'Severe asthma attack', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 26, 'Donna', 'Allen', '1961-07-21', 'Female', 'Commercial', 'Thyroid surgery', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 27, 'Edward', 'Young', '1952-12-15', 'Male', 'Medicare', 'Prostate cancer', DATEADD(DAY, -43, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 28, 'Carol', 'Hernandez', '1976-09-03', 'Female', 'Commercial', 'Endometriosis', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 29, 'Ronald', 'King', '1944-04-27', 'Male', 'Medicare', 'Heart valve replacement', DATEADD(DAY, -39, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 30, 'Ruth', 'Wright', '1969-01-10', 'Female', 'Medicaid', 'Depression with suicidal ideation', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 31, 'Anthony', 'Lopez', '1987-06-25', 'Male', 'Commercial', 'Motorcycle accident injuries', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 32, 'Sharon', 'Hill', '1954-11-08', 'Female', 'Medicare', 'Pulmonary embolism', DATEADD(DAY, -33, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 33, 'Kevin', 'Scott', '1991-08-14', 'Male', 'Commercial', 'Tonsillectomy', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 34, 'Deborah', 'Green', '1946-03-01', 'Female', 'Medicare', 'Alzheimer disease', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 35, 'Jason', 'Adams', '1982-10-19', 'Male', 'Self-Pay', 'Hernia repair', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 36, 'Shirley', 'Baker', '1959-05-06', 'Female', 'Medicare', 'Rheumatoid arthritis flare', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 37, 'Larry', 'Gonzalez', '1974-02-22', 'Male', 'Commercial', 'Kidney stones', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 38, 'Amy', 'Nelson', '1966-08-30', 'Female', 'Medicaid', 'Ovarian cancer', DATEADD(DAY, -21, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 39, 'Frank', 'Carter', '1949-07-13', 'Male', 'Medicare', 'Aortic aneurysm', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 40, 'Angela', 'Mitchell', '1993-12-05', 'Female', 'Commercial', 'Severe allergic reaction', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 41, 'Raymond', 'Perez', '1956-04-17', 'Male', 'Medicare', 'Colon cancer', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 42, 'Brenda', 'Roberts', '1981-09-28', 'Female', 'Commercial', 'Cesarean section', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 43, 'Jack', 'Turner', '1963-01-03', 'Male', 'Medicaid', 'Liver cirrhosis', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 44, 'Pamela', 'Phillips', '1971-06-20', 'Female', 'Commercial', 'Spinal fusion', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 45, 'Dennis', 'Campbell', '1938-11-25', 'Male', 'Medicare', 'Fall with hip fracture', DATEADD(DAY, -8, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 46, 'Teresa', 'Parker', '1984-03-16', 'Female', 'Commercial', 'Migraine with complications', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 47, 'Jerry', 'Evans', '1967-08-09', 'Male', 'Self-Pay', 'Acute kidney injury', DATEADD(DAY, -6, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 48, 'Carolyn', 'Edwards', '1951-10-31', 'Female', 'Medicare', 'Pneumonia', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 'Admitted'
UNION ALL SELECT 49, 'Gregory', 'Collins', '1979-05-24', 'Male', 'Commercial', 'Appendicitis', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 'Discharged'
UNION ALL SELECT 50, 'Marie', 'Stewart', '1943-02-07', 'Female', 'Medicare', 'Congestive heart failure', DATEADD(DAY, -3, CURRENT_DATE()), NULL, 'Admitted';


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.ENCOUNTERS (
  ENCOUNTER_ID INTEGER,
  PATIENT_ID INTEGER,
  PROVIDER_ID INTEGER,
  DEPARTMENT_ID INTEGER,
  ENCOUNTER_TYPE VARCHAR(20),
  ADMISSION_DATE DATE,
  DISCHARGE_DATE DATE,
  LENGTH_OF_STAY INTEGER,
  PRIMARY_DIAGNOSIS VARCHAR(200),
  STATUS VARCHAR(20)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.ENCOUNTERS
SELECT 1001, 1, 3, 3, 'Inpatient', DATEADD(DAY, -107, CURRENT_DATE()), DATEADD(DAY, -100, CURRENT_DATE()), 7, 'Acute myocardial infarction', 'Completed'
UNION ALL SELECT 1002, 2, 10, 3, 'Inpatient', DATEADD(DAY, -104, CURRENT_DATE()), NULL, 105, 'Congestive heart failure', 'Active'
UNION ALL SELECT 1003, 3, 8, 8, 'Inpatient', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -98, CURRENT_DATE()), 4, 'Type 2 diabetes with complications', 'Completed'
UNION ALL SELECT 1004, 4, 16, 8, 'Inpatient', DATEADD(DAY, -100, CURRENT_DATE()), DATEADD(DAY, -94, CURRENT_DATE()), 6, 'Pneumonia', 'Completed'
UNION ALL SELECT 1005, 5, 1, 1, 'Emergency', DATEADD(DAY, -97, CURRENT_DATE()), DATEADD(DAY, -95, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 1006, 6, 4, 4, 'Inpatient', DATEADD(DAY, -94, CURRENT_DATE()), NULL, 95, 'Hip fracture', 'Active'
UNION ALL SELECT 1007, 7, 9, 1, 'Emergency', DATEADD(DAY, -92, CURRENT_DATE()), DATEADD(DAY, -90, CURRENT_DATE()), 2, 'Concussion', 'Completed'
UNION ALL SELECT 1008, 8, 5, 5, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 91, 'Stroke', 'Active'
UNION ALL SELECT 1009, 9, 14, 4, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 5, 'Knee replacement', 'Completed'
UNION ALL SELECT 1010, 10, 6, 6, 'Inpatient', DATEADD(DAY, -84, CURRENT_DATE()), NULL, 85, 'Breast cancer', 'Active'
UNION ALL SELECT 1011, 11, 8, 8, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 7, 'COPD exacerbation', 'Completed'
UNION ALL SELECT 1012, 12, 7, 7, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 3, 'Pregnancy complications', 'Completed'
UNION ALL SELECT 1013, 13, 2, 2, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), NULL, 77, 'Sepsis', 'Active'
UNION ALL SELECT 1014, 14, 3, 3, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 6, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 1015, 15, 24, 4, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 5, 'Back surgery', 'Completed'
UNION ALL SELECT 1016, 16, 13, 6, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), NULL, 70, 'Lung cancer', 'Active'
UNION ALL SELECT 1017, 17, 12, 5, 'Emergency', DATEADD(DAY, -66, CURRENT_DATE()), NULL, 67, 'Traumatic brain injury', 'Active'
UNION ALL SELECT 1018, 18, 16, 8, 'Emergency', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 6, 'Diabetic ketoacidosis', 'Completed'
UNION ALL SELECT 1019, 19, 4, 4, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 3, 'Sports injury - ACL tear', 'Completed'
UNION ALL SELECT 1020, 20, 23, 8, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 4, 'Urinary tract infection', 'Completed'
UNION ALL SELECT 1021, 21, 19, 8, 'Emergency', DATEADD(DAY, -56, CURRENT_DATE()), NULL, 57, 'Acute pancreatitis', 'Active'
UNION ALL SELECT 1022, 22, 10, 3, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), NULL, 54, 'Coronary artery disease', 'Active'
UNION ALL SELECT 1023, 23, 19, 8, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 2, 'Gallbladder removal', 'Completed'
UNION ALL SELECT 1024, 24, 8, 8, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 51, 'Chronic kidney disease', 'Active'
UNION ALL SELECT 1025, 25, 17, 1, 'Emergency', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 4, 'Severe asthma attack', 'Completed'
UNION ALL SELECT 1026, 26, 19, 8, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Thyroid surgery', 'Completed'
UNION ALL SELECT 1027, 27, 6, 6, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), NULL, 44, 'Prostate cancer', 'Active'
UNION ALL SELECT 1028, 28, 7, 7, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 3, 'Endometriosis', 'Completed'
UNION ALL SELECT 1029, 29, 3, 3, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), NULL, 40, 'Heart valve replacement', 'Active'
UNION ALL SELECT 1030, 30, 22, 5, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 7, 'Depression with suicidal ideation', 'Completed'
UNION ALL SELECT 1031, 31, 1, 1, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 7, 'Motorcycle accident injuries', 'Completed'
UNION ALL SELECT 1032, 32, 11, 2, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), NULL, 34, 'Pulmonary embolism', 'Active'
UNION ALL SELECT 1033, 33, 7, 7, 'Outpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 1, 'Tonsillectomy', 'Completed'
UNION ALL SELECT 1034, 34, 12, 5, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 30, 'Alzheimer disease', 'Active'
UNION ALL SELECT 1035, 35, 19, 8, 'Outpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 2, 'Hernia repair', 'Completed'
UNION ALL SELECT 1036, 36, 4, 4, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 5, 'Rheumatoid arthritis flare', 'Completed'
UNION ALL SELECT 1037, 37, 23, 8, 'Emergency', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 2, 'Kidney stones', 'Completed'
UNION ALL SELECT 1038, 38, 25, 6, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), NULL, 22, 'Ovarian cancer', 'Active'
UNION ALL SELECT 1039, 39, 3, 3, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 20, 'Aortic aneurysm', 'Active'
UNION ALL SELECT 1040, 40, 9, 1, 'Emergency', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 2, 'Severe allergic reaction', 'Completed'
UNION ALL SELECT 1041, 41, 13, 6, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 16, 'Colon cancer', 'Active'
UNION ALL SELECT 1042, 42, 21, 7, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 4, 'Cesarean section', 'Completed'
UNION ALL SELECT 1043, 43, 8, 8, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 13, 'Liver cirrhosis', 'Active'
UNION ALL SELECT 1044, 44, 14, 4, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 7, 'Spinal fusion', 'Completed'
UNION ALL SELECT 1045, 45, 4, 4, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), NULL, 9, 'Fall with hip fracture', 'Active'
UNION ALL SELECT 1046, 46, 5, 5, 'Outpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 2, 'Migraine with complications', 'Completed'
UNION ALL SELECT 1047, 47, 2, 2, 'Emergency', DATEADD(DAY, -6, CURRENT_DATE()), NULL, 7, 'Acute kidney injury', 'Active'
UNION ALL SELECT 1048, 48, 16, 8, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 6, 'Pneumonia', 'Active'
UNION ALL SELECT 1049, 49, 9, 1, 'Emergency', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 1050, 50, 10, 3, 'Inpatient', DATEADD(DAY, -3, CURRENT_DATE()), NULL, 4, 'Congestive heart failure', 'Active'
UNION ALL SELECT 1051, 1, 10, 3, 'Outpatient', DATEADD(DAY, -153, CURRENT_DATE()), DATEADD(DAY, -153, CURRENT_DATE()), 0, 'Cardiac follow-up', 'Completed'
UNION ALL SELECT 1052, 2, 3, 3, 'Inpatient', DATEADD(DAY, -189, CURRENT_DATE()), DATEADD(DAY, -182, CURRENT_DATE()), 7, 'Heart failure exacerbation', 'Completed'
UNION ALL SELECT 1053, 11, 16, 8, 'Emergency', DATEADD(DAY, -133, CURRENT_DATE()), DATEADD(DAY, -128, CURRENT_DATE()), 5, 'COPD exacerbation', 'Completed'
UNION ALL SELECT 1054, 14, 10, 3, 'Outpatient', DATEADD(DAY, -229, CURRENT_DATE()), DATEADD(DAY, -229, CURRENT_DATE()), 0, 'AFib monitoring', 'Completed'
UNION ALL SELECT 1055, 20, 8, 8, 'Inpatient', DATEADD(DAY, -172, CURRENT_DATE()), DATEADD(DAY, -165, CURRENT_DATE()), 7, 'UTI with sepsis', 'Completed'
UNION ALL SELECT 1056, 1, 3, 3, 'Outpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 0, 'Post-MI follow-up', 'Completed'
UNION ALL SELECT 1057, 8, 12, 5, 'Emergency', DATEADD(DAY, -255, CURRENT_DATE()), DATEADD(DAY, -247, CURRENT_DATE()), 8, 'TIA', 'Completed'
UNION ALL SELECT 1058, 4, 8, 8, 'Outpatient', DATEADD(DAY, -123, CURRENT_DATE()), DATEADD(DAY, -123, CURRENT_DATE()), 0, 'Post-pneumonia follow-up', 'Completed'
UNION ALL SELECT 1059, 13, 16, 8, 'Emergency', DATEADD(DAY, -158, CURRENT_DATE()), DATEADD(DAY, -151, CURRENT_DATE()), 7, 'Cellulitis with sepsis', 'Completed'
UNION ALL SELECT 1060, 30, 5, 5, 'Outpatient', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -102, CURRENT_DATE()), 0, 'Psychiatric evaluation', 'Completed';


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.DIAGNOSES (
  DIAGNOSIS_ID INTEGER,
  ENCOUNTER_ID INTEGER,
  ICD10_CODE VARCHAR(10),
  DESCRIPTION VARCHAR(200),
  DIAGNOSIS_TYPE VARCHAR(20),
  DIAGNOSED_DATE DATE
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.DIAGNOSES
SELECT 1, 1001, 'I21.0', 'ST elevation myocardial infarction of anterior wall', 'Primary', DATEADD(DAY, -107, CURRENT_DATE())
UNION ALL SELECT 2, 1001, 'I25.1', 'Atherosclerotic heart disease', 'Secondary', DATEADD(DAY, -107, CURRENT_DATE())
UNION ALL SELECT 3, 1001, 'E11.9', 'Type 2 diabetes without complications', 'Secondary', DATEADD(DAY, -106, CURRENT_DATE())
UNION ALL SELECT 4, 1002, 'I50.9', 'Heart failure unspecified', 'Primary', DATEADD(DAY, -104, CURRENT_DATE())
UNION ALL SELECT 5, 1002, 'I10', 'Essential hypertension', 'Secondary', DATEADD(DAY, -104, CURRENT_DATE())
UNION ALL SELECT 6, 1003, 'E11.65', 'Type 2 diabetes with hyperglycemia', 'Primary', DATEADD(DAY, -102, CURRENT_DATE())
UNION ALL SELECT 7, 1003, 'E11.40', 'Type 2 diabetes with diabetic neuropathy', 'Secondary', DATEADD(DAY, -101, CURRENT_DATE())
UNION ALL SELECT 8, 1004, 'J18.9', 'Pneumonia unspecified organism', 'Primary', DATEADD(DAY, -100, CURRENT_DATE())
UNION ALL SELECT 9, 1004, 'J96.0', 'Acute respiratory failure', 'Secondary', DATEADD(DAY, -99, CURRENT_DATE())
UNION ALL SELECT 10, 1005, 'K35.80', 'Unspecified acute appendicitis', 'Primary', DATEADD(DAY, -97, CURRENT_DATE())
UNION ALL SELECT 11, 1006, 'S72.001', 'Fracture of unspecified part of neck of femur', 'Primary', DATEADD(DAY, -94, CURRENT_DATE())
UNION ALL SELECT 12, 1006, 'W19', 'Unspecified fall', 'Secondary', DATEADD(DAY, -94, CURRENT_DATE())
UNION ALL SELECT 13, 1007, 'S06.0', 'Concussion', 'Primary', DATEADD(DAY, -92, CURRENT_DATE())
UNION ALL SELECT 14, 1008, 'I63.9', 'Cerebral infarction unspecified', 'Primary', DATEADD(DAY, -90, CURRENT_DATE())
UNION ALL SELECT 15, 1008, 'I10', 'Essential hypertension', 'Secondary', DATEADD(DAY, -90, CURRENT_DATE())
UNION ALL SELECT 16, 1009, 'M17.11', 'Primary osteoarthritis right knee', 'Primary', DATEADD(DAY, -87, CURRENT_DATE())
UNION ALL SELECT 17, 1010, 'C50.9', 'Malignant neoplasm of breast', 'Primary', DATEADD(DAY, -84, CURRENT_DATE())
UNION ALL SELECT 18, 1011, 'J44.1', 'COPD with acute exacerbation', 'Primary', DATEADD(DAY, -80, CURRENT_DATE())
UNION ALL SELECT 19, 1012, 'O99.89', 'Other specified diseases complicating pregnancy', 'Primary', DATEADD(DAY, -78, CURRENT_DATE())
UNION ALL SELECT 20, 1013, 'A41.9', 'Sepsis unspecified organism', 'Primary', DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 21, 1013, 'R65.20', 'Severe sepsis without septic shock', 'Secondary', DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 22, 1014, 'I48.91', 'Unspecified atrial fibrillation', 'Primary', DATEADD(DAY, -73, CURRENT_DATE())
UNION ALL SELECT 23, 1015, 'M54.5', 'Low back pain', 'Primary', DATEADD(DAY, -71, CURRENT_DATE())
UNION ALL SELECT 24, 1016, 'C34.9', 'Malignant neoplasm of lung', 'Primary', DATEADD(DAY, -69, CURRENT_DATE())
UNION ALL SELECT 25, 1017, 'S06.2', 'Diffuse traumatic brain injury', 'Primary', DATEADD(DAY, -66, CURRENT_DATE())
UNION ALL SELECT 26, 1018, 'E11.10', 'Type 2 diabetes with ketoacidosis', 'Primary', DATEADD(DAY, -63, CURRENT_DATE())
UNION ALL SELECT 27, 1019, 'S83.51', 'Sprain of anterior cruciate ligament', 'Primary', DATEADD(DAY, -61, CURRENT_DATE())
UNION ALL SELECT 28, 1020, 'N39.0', 'Urinary tract infection', 'Primary', DATEADD(DAY, -59, CURRENT_DATE())
UNION ALL SELECT 29, 1021, 'K85.9', 'Acute pancreatitis unspecified', 'Primary', DATEADD(DAY, -56, CURRENT_DATE())
UNION ALL SELECT 30, 1022, 'I25.10', 'Atherosclerotic heart disease of native coronary artery', 'Primary', DATEADD(DAY, -53, CURRENT_DATE())
UNION ALL SELECT 31, 1023, 'K80.00', 'Calculus of gallbladder with acute cholecystitis', 'Primary', DATEADD(DAY, -52, CURRENT_DATE())
UNION ALL SELECT 32, 1024, 'N18.4', 'Chronic kidney disease stage 4', 'Primary', DATEADD(DAY, -50, CURRENT_DATE())
UNION ALL SELECT 33, 1025, 'J45.41', 'Moderate persistent asthma with acute exacerbation', 'Primary', DATEADD(DAY, -48, CURRENT_DATE())
UNION ALL SELECT 34, 1026, 'E04.1', 'Nontoxic single thyroid nodule', 'Primary', DATEADD(DAY, -46, CURRENT_DATE())
UNION ALL SELECT 35, 1027, 'C61', 'Malignant neoplasm of prostate', 'Primary', DATEADD(DAY, -43, CURRENT_DATE())
UNION ALL SELECT 36, 1028, 'N80.0', 'Endometriosis of uterus', 'Primary', DATEADD(DAY, -41, CURRENT_DATE())
UNION ALL SELECT 37, 1029, 'I35.1', 'Nonrheumatic aortic valve insufficiency', 'Primary', DATEADD(DAY, -39, CURRENT_DATE())
UNION ALL SELECT 38, 1030, 'F32.2', 'Major depressive disorder severe without psychotic features', 'Primary', DATEADD(DAY, -37, CURRENT_DATE())
UNION ALL SELECT 39, 1031, 'T14.90', 'Injury unspecified', 'Primary', DATEADD(DAY, -35, CURRENT_DATE())
UNION ALL SELECT 40, 1031, 'S22.4', 'Multiple fractures of ribs', 'Secondary', DATEADD(DAY, -35, CURRENT_DATE())
UNION ALL SELECT 41, 1032, 'I26.99', 'Other pulmonary embolism without acute cor pulmonale', 'Primary', DATEADD(DAY, -33, CURRENT_DATE())
UNION ALL SELECT 42, 1033, 'J35.1', 'Hypertrophy of tonsils', 'Primary', DATEADD(DAY, -31, CURRENT_DATE())
UNION ALL SELECT 43, 1034, 'G30.9', 'Alzheimer disease unspecified', 'Primary', DATEADD(DAY, -29, CURRENT_DATE())
UNION ALL SELECT 44, 1035, 'K40.90', 'Unilateral inguinal hernia without obstruction', 'Primary', DATEADD(DAY, -27, CURRENT_DATE())
UNION ALL SELECT 45, 1036, 'M05.79', 'Rheumatoid arthritis with rheumatoid factor', 'Primary', DATEADD(DAY, -25, CURRENT_DATE())
UNION ALL SELECT 46, 1037, 'N20.0', 'Calculus of kidney', 'Primary', DATEADD(DAY, -23, CURRENT_DATE())
UNION ALL SELECT 47, 1038, 'C56.9', 'Malignant neoplasm of ovary', 'Primary', DATEADD(DAY, -21, CURRENT_DATE())
UNION ALL SELECT 48, 1039, 'I71.4', 'Abdominal aortic aneurysm without rupture', 'Primary', DATEADD(DAY, -19, CURRENT_DATE())
UNION ALL SELECT 49, 1040, 'T78.2', 'Anaphylactic shock unspecified', 'Primary', DATEADD(DAY, -17, CURRENT_DATE())
UNION ALL SELECT 50, 1041, 'C18.9', 'Malignant neoplasm of colon unspecified', 'Primary', DATEADD(DAY, -15, CURRENT_DATE())
UNION ALL SELECT 51, 1042, 'O82', 'Encounter for cesarean delivery', 'Primary', DATEADD(DAY, -13, CURRENT_DATE())
UNION ALL SELECT 52, 1043, 'K74.60', 'Unspecified cirrhosis of liver', 'Primary', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 53, 1044, 'M43.16', 'Spondylolisthesis lumbar region', 'Primary', DATEADD(DAY, -10, CURRENT_DATE())
UNION ALL SELECT 54, 1045, 'S72.001', 'Fracture of unspecified part of neck of femur', 'Primary', DATEADD(DAY, -8, CURRENT_DATE())
UNION ALL SELECT 55, 1046, 'G43.909', 'Migraine unspecified not intractable', 'Primary', DATEADD(DAY, -7, CURRENT_DATE())
UNION ALL SELECT 56, 1047, 'N17.9', 'Acute kidney failure unspecified', 'Primary', DATEADD(DAY, -6, CURRENT_DATE())
UNION ALL SELECT 57, 1048, 'J18.9', 'Pneumonia unspecified organism', 'Primary', DATEADD(DAY, -5, CURRENT_DATE())
UNION ALL SELECT 58, 1049, 'K35.80', 'Unspecified acute appendicitis', 'Primary', DATEADD(DAY, -4, CURRENT_DATE())
UNION ALL SELECT 59, 1050, 'I50.9', 'Heart failure unspecified', 'Primary', DATEADD(DAY, -3, CURRENT_DATE())
UNION ALL SELECT 60, 1052, 'I50.9', 'Heart failure unspecified', 'Primary', DATEADD(DAY, -189, CURRENT_DATE())
UNION ALL SELECT 61, 1053, 'J44.1', 'COPD with acute exacerbation', 'Primary', DATEADD(DAY, -133, CURRENT_DATE())
UNION ALL SELECT 62, 1055, 'N39.0', 'Urinary tract infection', 'Primary', DATEADD(DAY, -172, CURRENT_DATE())
UNION ALL SELECT 63, 1055, 'A41.9', 'Sepsis unspecified organism', 'Secondary', DATEADD(DAY, -170, CURRENT_DATE())
UNION ALL SELECT 64, 1057, 'G45.9', 'Transient cerebral ischemic attack', 'Primary', DATEADD(DAY, -255, CURRENT_DATE())
UNION ALL SELECT 65, 1059, 'L03.90', 'Cellulitis unspecified', 'Primary', DATEADD(DAY, -158, CURRENT_DATE())
UNION ALL SELECT 66, 1059, 'A41.9', 'Sepsis unspecified organism', 'Secondary', DATEADD(DAY, -156, CURRENT_DATE());


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.PROCEDURES (
  PROCEDURE_ID INTEGER,
  ENCOUNTER_ID INTEGER,
  CPT_CODE VARCHAR(10),
  DESCRIPTION VARCHAR(200),
  PROCEDURE_DATE DATE,
  PROVIDER_ID INTEGER,
  COST NUMBER(10,2)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.PROCEDURES
SELECT 1, 1001, '92928', 'Percutaneous coronary stent placement', DATEADD(DAY, -106, CURRENT_DATE()), 3, 45000.00
UNION ALL SELECT 2, 1001, '93458', 'Left heart catheterization', DATEADD(DAY, -107, CURRENT_DATE()), 3, 12000.00
UNION ALL SELECT 3, 1005, '44970', 'Laparoscopic appendectomy', DATEADD(DAY, -97, CURRENT_DATE()), 1, 15000.00
UNION ALL SELECT 4, 1006, '27236', 'Open treatment femoral neck fracture', DATEADD(DAY, -93, CURRENT_DATE()), 4, 35000.00
UNION ALL SELECT 5, 1009, '27447', 'Total knee arthroplasty', DATEADD(DAY, -86, CURRENT_DATE()), 14, 42000.00
UNION ALL SELECT 6, 1010, '19301', 'Partial mastectomy', DATEADD(DAY, -83, CURRENT_DATE()), 6, 18000.00
UNION ALL SELECT 7, 1014, '93656', 'Catheter ablation atrial fibrillation', DATEADD(DAY, -71, CURRENT_DATE()), 3, 38000.00
UNION ALL SELECT 8, 1015, '22612', 'Lumbar spinal fusion', DATEADD(DAY, -70, CURRENT_DATE()), 24, 55000.00
UNION ALL SELECT 9, 1019, '29888', 'ACL reconstruction arthroscopic', DATEADD(DAY, -60, CURRENT_DATE()), 4, 28000.00
UNION ALL SELECT 10, 1023, '47562', 'Laparoscopic cholecystectomy', DATEADD(DAY, -52, CURRENT_DATE()), 19, 12000.00
UNION ALL SELECT 11, 1026, '60240', 'Thyroid lobectomy', DATEADD(DAY, -45, CURRENT_DATE()), 19, 16000.00
UNION ALL SELECT 12, 1027, '55866', 'Robotic-assisted prostatectomy', DATEADD(DAY, -42, CURRENT_DATE()), 6, 48000.00
UNION ALL SELECT 13, 1029, '33405', 'Aortic valve replacement', DATEADD(DAY, -38, CURRENT_DATE()), 3, 85000.00
UNION ALL SELECT 14, 1033, '42826', 'Tonsillectomy', DATEADD(DAY, -31, CURRENT_DATE()), 7, 5000.00
UNION ALL SELECT 15, 1035, '49650', 'Laparoscopic inguinal hernia repair', DATEADD(DAY, -26, CURRENT_DATE()), 19, 9000.00
UNION ALL SELECT 16, 1042, '59510', 'Cesarean delivery', DATEADD(DAY, -13, CURRENT_DATE()), 21, 22000.00
UNION ALL SELECT 17, 1044, '22633', 'Lumbar interbody fusion', DATEADD(DAY, -9, CURRENT_DATE()), 14, 62000.00
UNION ALL SELECT 18, 1045, '27236', 'Open treatment femoral neck fracture', DATEADD(DAY, -7, CURRENT_DATE()), 4, 35000.00
UNION ALL SELECT 19, 1049, '44970', 'Laparoscopic appendectomy', DATEADD(DAY, -4, CURRENT_DATE()), 9, 15000.00
UNION ALL SELECT 20, 1008, '99291', 'Critical care first hour', DATEADD(DAY, -90, CURRENT_DATE()), 5, 3500.00
UNION ALL SELECT 21, 1013, '99291', 'Critical care first hour', DATEADD(DAY, -76, CURRENT_DATE()), 2, 3500.00
UNION ALL SELECT 22, 1017, '61154', 'Burr hole for intracranial pressure monitor', DATEADD(DAY, -66, CURRENT_DATE()), 12, 22000.00
UNION ALL SELECT 23, 1032, '99291', 'Critical care first hour', DATEADD(DAY, -33, CURRENT_DATE()), 11, 3500.00
UNION ALL SELECT 24, 1039, '34802', 'Endovascular repair of aortic aneurysm', DATEADD(DAY, -18, CURRENT_DATE()), 3, 72000.00
UNION ALL SELECT 25, 1047, '90935', 'Hemodialysis', DATEADD(DAY, -6, CURRENT_DATE()), 2, 4500.00
UNION ALL SELECT 26, 1047, '90935', 'Hemodialysis', DATEADD(DAY, -4, CURRENT_DATE()), 2, 4500.00
UNION ALL SELECT 27, 1031, '21800', 'Rib fracture treatment', DATEADD(DAY, -35, CURRENT_DATE()), 1, 8000.00
UNION ALL SELECT 28, 1028, '58660', 'Laparoscopy for endometriosis', DATEADD(DAY, -40, CURRENT_DATE()), 7, 14000.00
UNION ALL SELECT 29, 1040, '96365', 'IV infusion therapy first hour', DATEADD(DAY, -17, CURRENT_DATE()), 9, 2500.00
UNION ALL SELECT 30, 1037, '50590', 'Lithotripsy', DATEADD(DAY, -23, CURRENT_DATE()), 23, 18000.00;


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.MEDICATIONS (
  MEDICATION_ID INTEGER,
  ENCOUNTER_ID INTEGER,
  DRUG_NAME VARCHAR(100),
  DOSAGE VARCHAR(50),
  FREQUENCY VARCHAR(50),
  START_DATE DATE,
  END_DATE DATE,
  PRESCRIBING_PROVIDER_ID INTEGER
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.MEDICATIONS
SELECT 1, 1001, 'Aspirin', '325mg', 'Daily', DATEADD(DAY, -107, CURRENT_DATE()), DATEADD(DAY, -100, CURRENT_DATE()), 3
UNION ALL SELECT 2, 1001, 'Heparin', '5000 units', 'Every 12 hours', DATEADD(DAY, -107, CURRENT_DATE()), DATEADD(DAY, -104, CURRENT_DATE()), 3
UNION ALL SELECT 3, 1001, 'Metoprolol', '50mg', 'Twice daily', DATEADD(DAY, -106, CURRENT_DATE()), DATEADD(DAY, -100, CURRENT_DATE()), 3
UNION ALL SELECT 4, 1002, 'Furosemide', '40mg', 'Daily', DATEADD(DAY, -104, CURRENT_DATE()), NULL, 10
UNION ALL SELECT 5, 1002, 'Lisinopril', '10mg', 'Daily', DATEADD(DAY, -104, CURRENT_DATE()), NULL, 10
UNION ALL SELECT 6, 1003, 'Insulin Glargine', '20 units', 'At bedtime', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -98, CURRENT_DATE()), 8
UNION ALL SELECT 7, 1003, 'Metformin', '1000mg', 'Twice daily', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -98, CURRENT_DATE()), 8
UNION ALL SELECT 8, 1004, 'Azithromycin', '500mg', 'Daily', DATEADD(DAY, -100, CURRENT_DATE()), DATEADD(DAY, -95, CURRENT_DATE()), 16
UNION ALL SELECT 9, 1004, 'Albuterol', '2.5mg', 'Every 4 hours as needed', DATEADD(DAY, -100, CURRENT_DATE()), DATEADD(DAY, -94, CURRENT_DATE()), 16
UNION ALL SELECT 10, 1005, 'Cefazolin', '2g', 'Pre-operative', DATEADD(DAY, -97, CURRENT_DATE()), DATEADD(DAY, -97, CURRENT_DATE()), 1
UNION ALL SELECT 11, 1006, 'Morphine', '4mg', 'Every 4 hours as needed', DATEADD(DAY, -94, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 4
UNION ALL SELECT 12, 1006, 'Enoxaparin', '40mg', 'Daily', DATEADD(DAY, -93, CURRENT_DATE()), NULL, 4
UNION ALL SELECT 13, 1008, 'Alteplase', '0.9mg/kg', 'One-time dose', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -90, CURRENT_DATE()), 5
UNION ALL SELECT 14, 1008, 'Aspirin', '81mg', 'Daily', DATEADD(DAY, -89, CURRENT_DATE()), NULL, 5
UNION ALL SELECT 15, 1010, 'Tamoxifen', '20mg', 'Daily', DATEADD(DAY, -82, CURRENT_DATE()), NULL, 6
UNION ALL SELECT 16, 1011, 'Prednisone', '40mg', 'Daily taper', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 8
UNION ALL SELECT 17, 1013, 'Vancomycin', '1g', 'Every 12 hours', DATEADD(DAY, -76, CURRENT_DATE()), NULL, 2
UNION ALL SELECT 18, 1013, 'Piperacillin-Tazobactam', '4.5g', 'Every 6 hours', DATEADD(DAY, -76, CURRENT_DATE()), NULL, 2
UNION ALL SELECT 19, 1014, 'Amiodarone', '200mg', 'Three times daily', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 3
UNION ALL SELECT 20, 1016, 'Pembrolizumab', '200mg', 'Every 3 weeks', DATEADD(DAY, -66, CURRENT_DATE()), NULL, 13
UNION ALL SELECT 21, 1017, 'Mannitol', '1g/kg', 'Every 6 hours', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 12
UNION ALL SELECT 22, 1018, 'Insulin Regular', '10 units/hr', 'IV continuous', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 16
UNION ALL SELECT 23, 1020, 'Ciprofloxacin', '500mg', 'Twice daily', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 23
UNION ALL SELECT 24, 1025, 'Methylprednisolone', '125mg', 'Every 6 hours', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 17
UNION ALL SELECT 25, 1029, 'Warfarin', '5mg', 'Daily', DATEADD(DAY, -37, CURRENT_DATE()), NULL, 3
UNION ALL SELECT 26, 1030, 'Sertraline', '100mg', 'Daily', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 22
UNION ALL SELECT 27, 1032, 'Heparin', '5000 units', 'Every 12 hours', DATEADD(DAY, -33, CURRENT_DATE()), NULL, 11
UNION ALL SELECT 28, 1038, 'Carboplatin', 'AUC 5', 'Every 3 weeks', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 25
UNION ALL SELECT 29, 1043, 'Lactulose', '30mL', 'Three times daily', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 8
UNION ALL SELECT 30, 1047, 'Sodium Bicarbonate', '50mEq', 'IV bolus', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 2
UNION ALL SELECT 31, 1048, 'Levofloxacin', '750mg', 'Daily', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 16
UNION ALL SELECT 32, 1050, 'Furosemide', '80mg', 'Twice daily', DATEADD(DAY, -3, CURRENT_DATE()), NULL, 10;


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.LAB_RESULTS (
  LAB_ID INTEGER,
  ENCOUNTER_ID INTEGER,
  TEST_NAME VARCHAR(100),
  RESULT_VALUE NUMBER(10,2),
  UNIT VARCHAR(20),
  REFERENCE_RANGE_LOW NUMBER(10,2),
  REFERENCE_RANGE_HIGH NUMBER(10,2),
  RESULT_FLAG VARCHAR(20),
  RESULT_DATE DATE
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.LAB_RESULTS
SELECT 1, 1001, 'Troponin I', 8.50, 'ng/mL', 0.00, 0.04, 'Critical', DATEADD(DAY, -107, CURRENT_DATE())
UNION ALL SELECT 2, 1001, 'BNP', 850.00, 'pg/mL', 0.00, 100.00, 'High', DATEADD(DAY, -107, CURRENT_DATE())
UNION ALL SELECT 3, 1001, 'Total Cholesterol', 280.00, 'mg/dL', 0.00, 200.00, 'High', DATEADD(DAY, -106, CURRENT_DATE())
UNION ALL SELECT 4, 1001, 'Hemoglobin', 13.20, 'g/dL', 13.50, 17.50, 'Low', DATEADD(DAY, -107, CURRENT_DATE())
UNION ALL SELECT 5, 1002, 'BNP', 1250.00, 'pg/mL', 0.00, 100.00, 'Critical', DATEADD(DAY, -104, CURRENT_DATE())
UNION ALL SELECT 6, 1002, 'Creatinine', 1.80, 'mg/dL', 0.70, 1.30, 'High', DATEADD(DAY, -104, CURRENT_DATE())
UNION ALL SELECT 7, 1002, 'Sodium', 132.00, 'mEq/L', 136.00, 145.00, 'Low', DATEADD(DAY, -103, CURRENT_DATE())
UNION ALL SELECT 8, 1003, 'HbA1c', 11.20, '%', 4.00, 5.60, 'Critical', DATEADD(DAY, -102, CURRENT_DATE())
UNION ALL SELECT 9, 1003, 'Glucose', 385.00, 'mg/dL', 70.00, 100.00, 'Critical', DATEADD(DAY, -102, CURRENT_DATE())
UNION ALL SELECT 10, 1003, 'Creatinine', 1.10, 'mg/dL', 0.70, 1.30, 'Normal', DATEADD(DAY, -102, CURRENT_DATE())
UNION ALL SELECT 11, 1004, 'WBC', 18.50, 'K/uL', 4.50, 11.00, 'High', DATEADD(DAY, -100, CURRENT_DATE())
UNION ALL SELECT 12, 1004, 'Procalcitonin', 2.80, 'ng/mL', 0.00, 0.50, 'Critical', DATEADD(DAY, -100, CURRENT_DATE())
UNION ALL SELECT 13, 1004, 'Lactate', 1.80, 'mmol/L', 0.50, 2.00, 'Normal', DATEADD(DAY, -99, CURRENT_DATE())
UNION ALL SELECT 14, 1008, 'PT/INR', 1.10, 'ratio', 0.80, 1.20, 'Normal', DATEADD(DAY, -90, CURRENT_DATE())
UNION ALL SELECT 15, 1008, 'Glucose', 165.00, 'mg/dL', 70.00, 100.00, 'High', DATEADD(DAY, -90, CURRENT_DATE())
UNION ALL SELECT 16, 1010, 'CA 15-3', 48.00, 'U/mL', 0.00, 30.00, 'High', DATEADD(DAY, -84, CURRENT_DATE())
UNION ALL SELECT 17, 1010, 'Hemoglobin', 10.20, 'g/dL', 12.00, 16.00, 'Low', DATEADD(DAY, -84, CURRENT_DATE())
UNION ALL SELECT 18, 1011, 'ABG pH', 7.28, '', 7.35, 7.45, 'Low', DATEADD(DAY, -80, CURRENT_DATE())
UNION ALL SELECT 19, 1011, 'ABG pCO2', 55.00, 'mmHg', 35.00, 45.00, 'High', DATEADD(DAY, -80, CURRENT_DATE())
UNION ALL SELECT 20, 1013, 'Lactate', 4.50, 'mmol/L', 0.50, 2.00, 'Critical', DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 21, 1013, 'WBC', 22.00, 'K/uL', 4.50, 11.00, 'Critical', DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 22, 1013, 'Blood Culture', 1.00, 'Positive', 0.00, 0.00, 'Critical', DATEADD(DAY, -75, CURRENT_DATE())
UNION ALL SELECT 23, 1013, 'Procalcitonin', 8.50, 'ng/mL', 0.00, 0.50, 'Critical', DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 24, 1014, 'PT/INR', 1.50, 'ratio', 0.80, 1.20, 'High', DATEADD(DAY, -73, CURRENT_DATE())
UNION ALL SELECT 25, 1016, 'CEA', 12.50, 'ng/mL', 0.00, 3.00, 'High', DATEADD(DAY, -69, CURRENT_DATE())
UNION ALL SELECT 26, 1017, 'GCS', 8.00, 'score', 15.00, 15.00, 'Critical', DATEADD(DAY, -66, CURRENT_DATE())
UNION ALL SELECT 27, 1018, 'Glucose', 520.00, 'mg/dL', 70.00, 100.00, 'Critical', DATEADD(DAY, -63, CURRENT_DATE())
UNION ALL SELECT 28, 1018, 'ABG pH', 7.18, '', 7.35, 7.45, 'Critical', DATEADD(DAY, -63, CURRENT_DATE())
UNION ALL SELECT 29, 1018, 'Potassium', 5.80, 'mEq/L', 3.50, 5.00, 'High', DATEADD(DAY, -63, CURRENT_DATE())
UNION ALL SELECT 30, 1020, 'Urinalysis WBC', 85.00, '/HPF', 0.00, 5.00, 'High', DATEADD(DAY, -59, CURRENT_DATE())
UNION ALL SELECT 31, 1021, 'Lipase', 1200.00, 'U/L', 0.00, 160.00, 'Critical', DATEADD(DAY, -56, CURRENT_DATE())
UNION ALL SELECT 32, 1021, 'Amylase', 450.00, 'U/L', 30.00, 110.00, 'High', DATEADD(DAY, -56, CURRENT_DATE())
UNION ALL SELECT 33, 1022, 'Troponin I', 0.08, 'ng/mL', 0.00, 0.04, 'High', DATEADD(DAY, -53, CURRENT_DATE())
UNION ALL SELECT 34, 1022, 'LDL Cholesterol', 185.00, 'mg/dL', 0.00, 100.00, 'High', DATEADD(DAY, -53, CURRENT_DATE())
UNION ALL SELECT 35, 1024, 'Creatinine', 4.20, 'mg/dL', 0.70, 1.30, 'Critical', DATEADD(DAY, -50, CURRENT_DATE())
UNION ALL SELECT 36, 1024, 'BUN', 65.00, 'mg/dL', 7.00, 20.00, 'High', DATEADD(DAY, -50, CURRENT_DATE())
UNION ALL SELECT 37, 1024, 'GFR', 18.00, 'mL/min', 60.00, 120.00, 'Critical', DATEADD(DAY, -50, CURRENT_DATE())
UNION ALL SELECT 38, 1025, 'ABG pO2', 58.00, 'mmHg', 80.00, 100.00, 'Low', DATEADD(DAY, -48, CURRENT_DATE())
UNION ALL SELECT 39, 1027, 'PSA', 15.80, 'ng/mL', 0.00, 4.00, 'High', DATEADD(DAY, -43, CURRENT_DATE())
UNION ALL SELECT 40, 1029, 'PT/INR', 1.00, 'ratio', 0.80, 1.20, 'Normal', DATEADD(DAY, -39, CURRENT_DATE())
UNION ALL SELECT 41, 1029, 'Hemoglobin', 11.50, 'g/dL', 13.50, 17.50, 'Low', DATEADD(DAY, -39, CURRENT_DATE())
UNION ALL SELECT 42, 1032, 'D-Dimer', 4500.00, 'ng/mL', 0.00, 500.00, 'Critical', DATEADD(DAY, -33, CURRENT_DATE())
UNION ALL SELECT 43, 1032, 'Troponin I', 0.12, 'ng/mL', 0.00, 0.04, 'High', DATEADD(DAY, -33, CURRENT_DATE())
UNION ALL SELECT 44, 1038, 'CA-125', 285.00, 'U/mL', 0.00, 35.00, 'Critical', DATEADD(DAY, -21, CURRENT_DATE())
UNION ALL SELECT 45, 1039, 'Hemoglobin', 9.80, 'g/dL', 13.50, 17.50, 'Low', DATEADD(DAY, -19, CURRENT_DATE())
UNION ALL SELECT 46, 1041, 'CEA', 18.00, 'ng/mL', 0.00, 3.00, 'High', DATEADD(DAY, -15, CURRENT_DATE())
UNION ALL SELECT 47, 1043, 'ALT', 185.00, 'U/L', 7.00, 56.00, 'High', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 48, 1043, 'AST', 210.00, 'U/L', 10.00, 40.00, 'High', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 49, 1043, 'Albumin', 2.50, 'g/dL', 3.50, 5.50, 'Low', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 50, 1043, 'Bilirubin Total', 4.80, 'mg/dL', 0.10, 1.20, 'Critical', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 51, 1047, 'Creatinine', 5.50, 'mg/dL', 0.70, 1.30, 'Critical', DATEADD(DAY, -6, CURRENT_DATE())
UNION ALL SELECT 52, 1047, 'Potassium', 6.20, 'mEq/L', 3.50, 5.00, 'Critical', DATEADD(DAY, -6, CURRENT_DATE())
UNION ALL SELECT 53, 1047, 'BUN', 85.00, 'mg/dL', 7.00, 20.00, 'Critical', DATEADD(DAY, -6, CURRENT_DATE())
UNION ALL SELECT 54, 1048, 'WBC', 16.80, 'K/uL', 4.50, 11.00, 'High', DATEADD(DAY, -5, CURRENT_DATE())
UNION ALL SELECT 55, 1050, 'BNP', 980.00, 'pg/mL', 0.00, 100.00, 'Critical', DATEADD(DAY, -3, CURRENT_DATE());


CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.BEDS (
  BED_ID INTEGER,
  DEPARTMENT_ID INTEGER,
  BED_NUMBER VARCHAR(10),
  BED_TYPE VARCHAR(20),
  STATUS VARCHAR(20),
  CURRENT_PATIENT_ID INTEGER
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.BEDS VALUES
(1, 1, 'ER-01', 'Standard', 'Occupied', 47),
(2, 1, 'ER-02', 'Standard', 'Available', NULL),
(3, 1, 'ER-03', 'Standard', 'Occupied', NULL),
(4, 1, 'ER-04', 'Standard', 'Available', NULL),
(5, 1, 'ER-05', 'Standard', 'Available', NULL),
(6, 1, 'ER-06', 'Standard', 'Maintenance', NULL),
(7, 2, 'ICU-01', 'ICU', 'Occupied', 13),
(8, 2, 'ICU-02', 'ICU', 'Occupied', 32),
(9, 2, 'ICU-03', 'ICU', 'Available', NULL),
(10, 2, 'ICU-04', 'ICU', 'Occupied', 17),
(11, 2, 'ICU-05', 'ICU', 'Maintenance', NULL),
(12, 2, 'ICU-06', 'ICU', 'Available', NULL),
(13, 3, 'CARD-01', 'Standard', 'Occupied', 2),
(14, 3, 'CARD-02', 'Standard', 'Occupied', 22),
(15, 3, 'CARD-03', 'Standard', 'Occupied', 29),
(16, 3, 'CARD-04', 'Standard', 'Occupied', 39),
(17, 3, 'CARD-05', 'Standard', 'Available', NULL),
(18, 3, 'CARD-06', 'Standard', 'Occupied', 50),
(19, 4, 'ORTH-01', 'Standard', 'Occupied', 6),
(20, 4, 'ORTH-02', 'Standard', 'Occupied', 45),
(21, 4, 'ORTH-03', 'Standard', 'Available', NULL),
(22, 4, 'ORTH-04', 'Standard', 'Available', NULL),
(23, 5, 'NEUR-01', 'Standard', 'Occupied', 8),
(24, 5, 'NEUR-02', 'Standard', 'Occupied', 34),
(25, 5, 'NEUR-03', 'Standard', 'Available', NULL),
(26, 5, 'NEUR-04', 'Isolation', 'Maintenance', NULL),
(27, 6, 'ONC-01', 'Standard', 'Occupied', 10),
(28, 6, 'ONC-02', 'Standard', 'Occupied', 16),
(29, 6, 'ONC-03', 'Standard', 'Occupied', 27),
(30, 6, 'ONC-04', 'Standard', 'Occupied', 38),
(31, 6, 'ONC-05', 'Standard', 'Occupied', 41),
(32, 6, 'ONC-06', 'Standard', 'Available', NULL),
(33, 7, 'PED-01', 'Pediatric', 'Available', NULL),
(34, 7, 'PED-02', 'Pediatric', 'Available', NULL),
(35, 7, 'PED-03', 'Pediatric', 'Available', NULL),
(36, 7, 'PED-04', 'Pediatric', 'Maintenance', NULL),
(37, 8, 'GEN-01', 'Standard', 'Occupied', 21),
(38, 8, 'GEN-02', 'Standard', 'Occupied', 24),
(39, 8, 'GEN-03', 'Standard', 'Occupied', 43),
(40, 8, 'GEN-04', 'Standard', 'Occupied', 48),
(41, 8, 'GEN-05', 'Standard', 'Available', NULL),
(42, 8, 'GEN-06', 'Standard', 'Available', NULL),
(43, 8, 'GEN-07', 'Isolation', 'Available', NULL),
(44, 8, 'GEN-08', 'Standard', 'Available', NULL);

CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.READMISSIONS (
  READMISSION_ID INTEGER,
  PATIENT_ID INTEGER,
  ORIGINAL_ENCOUNTER_ID INTEGER,
  READMISSION_ENCOUNTER_ID INTEGER,
  DAYS_BETWEEN INTEGER,
  RISK_SCORE NUMBER(3,2),
  REASON VARCHAR(200)
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.READMISSIONS VALUES
(1, 2, 1052, 1002, 77, 0.85, 'Heart failure decompensation'),
(2, 11, 1053, 1011, 52, 0.72, 'COPD exacerbation recurrence'),
(3, 1, 1051, 1001, 46, 0.65, 'Chest pain post cardiac event'),
(4, 20, 1055, 1020, 113, 0.45, 'Recurrent urinary tract infection'),
(5, 8, 1057, 1008, 165, 0.90, 'Cerebrovascular accident after prior TIA'),
(6, 13, 1059, 1013, 82, 0.88, 'Recurrent sepsis'),
(7, 14, 1054, 1014, 156, 0.35, 'Atrial fibrillation with rapid ventricular response'),
(8, 4, 1058, 1004, 23, 0.55, 'Pneumonia recurrence'),
(9, 50, 1050, 1050, 0, 0.92, 'Chronic heart failure - frequent admits'),
(10, 24, 1024, 1024, 0, 0.78, 'Chronic kidney disease progression'),
(11, 43, 1043, 1043, 0, 0.82, 'Hepatic encephalopathy'),
(12, 32, 1032, 1032, 0, 0.75, 'Recurrent PE risk'),
(13, 34, 1034, 1034, 0, 0.60, 'Alzheimer behavioral crisis'),
(14, 16, 1016, 1016, 0, 0.70, 'Chemotherapy complications'),
(15, 45, 1045, 1045, 0, 0.80, 'Post-surgical complication risk'),
(16, 6, 1006, 1006, 0, 0.73, 'Post-surgical DVT risk'),
(17, 48, 1048, 1048, 0, 0.68, 'Pneumonia in elderly with comorbidities'),
(18, 39, 1039, 1039, 0, 0.87, 'Post-aortic repair monitoring'),
(19, 27, 1027, 1027, 0, 0.40, 'Post-prostatectomy recovery'),
(20, 47, 1047, 1047, 0, 0.91, 'Acute kidney failure progression');

CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.OPERATIONS.INSURANCE_CLAIMS (
  CLAIM_ID INTEGER,
  ENCOUNTER_ID INTEGER,
  PATIENT_ID INTEGER,
  INSURANCE_TYPE VARCHAR(30),
  CLAIM_AMOUNT NUMBER(12,2),
  APPROVED_AMOUNT NUMBER(12,2),
  STATUS VARCHAR(20),
  SUBMISSION_DATE DATE,
  RESOLUTION_DATE DATE
);

INSERT INTO HEALTHCARE_HOL_DB.OPERATIONS.INSURANCE_CLAIMS
SELECT 1, 1001, 1, 'Medicare', 62000.00, 55800.00, 'Approved', DATEADD(DAY, -99, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE())
UNION ALL SELECT 2, 1002, 2, 'Medicare', 45000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 3, 1003, 3, 'Commercial', 18500.00, 17200.00, 'Approved', DATEADD(DAY, -97, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE())
UNION ALL SELECT 4, 1004, 4, 'Commercial', 22000.00, 20500.00, 'Approved', DATEADD(DAY, -93, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE())
UNION ALL SELECT 5, 1005, 5, 'Medicaid', 18000.00, 14400.00, 'Approved', DATEADD(DAY, -94, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE())
UNION ALL SELECT 6, 1006, 6, 'Medicare', 48000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 7, 1007, 7, 'Commercial', 8500.00, 8500.00, 'Approved', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE())
UNION ALL SELECT 8, 1008, 8, 'Medicare', 35000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 9, 1009, 9, 'Commercial', 52000.00, 48500.00, 'Approved', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE())
UNION ALL SELECT 10, 1010, 10, 'Medicare', 28000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 11, 1011, 11, 'Medicare', 15000.00, 13500.00, 'Approved', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE())
UNION ALL SELECT 12, 1012, 12, 'Commercial', 12000.00, 11800.00, 'Approved', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE())
UNION ALL SELECT 13, 1013, 13, 'Medicaid', 85000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 14, 1014, 14, 'Medicare', 48000.00, 42000.00, 'Approved', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE())
UNION ALL SELECT 15, 1015, 15, 'Commercial', 65000.00, 60000.00, 'Approved', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE())
UNION ALL SELECT 16, 1016, 16, 'Medicare', 55000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 17, 1017, 17, 'Self-Pay', 95000.00, 0.00, 'Denied', DATEADD(DAY, -2, CURRENT_DATE()), CURRENT_DATE()
UNION ALL SELECT 18, 1018, 18, 'Medicaid', 18000.00, 14000.00, 'Approved', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE())
UNION ALL SELECT 19, 1019, 19, 'Commercial', 35000.00, 33000.00, 'Approved', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE())
UNION ALL SELECT 20, 1020, 20, 'Medicare', 8500.00, 7800.00, 'Approved', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE())
UNION ALL SELECT 21, 1021, 21, 'Commercial', 32000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 22, 1022, 22, 'Medicare', 40000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 23, 1023, 23, 'Commercial', 15000.00, 14500.00, 'Approved', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE())
UNION ALL SELECT 24, 1024, 24, 'Medicare', 25000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 25, 1025, 25, 'Medicaid', 12000.00, 9500.00, 'Approved', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE())
UNION ALL SELECT 26, 1026, 26, 'Commercial', 22000.00, 21000.00, 'Approved', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE())
UNION ALL SELECT 27, 1027, 27, 'Medicare', 58000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 28, 1029, 29, 'Medicare', 95000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 29, 1031, 31, 'Commercial', 42000.00, 38000.00, 'Approved', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 30, 1033, 33, 'Commercial', 7000.00, 6800.00, 'Approved', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE())
UNION ALL SELECT 31, 1035, 35, 'Self-Pay', 12000.00, 0.00, 'Denied', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE())
UNION ALL SELECT 32, 1036, 36, 'Medicare', 18000.00, 16500.00, 'Approved', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE())
UNION ALL SELECT 33, 1037, 37, 'Commercial', 22000.00, 21500.00, 'Approved', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE())
UNION ALL SELECT 34, 1038, 38, 'Medicaid', 45000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 35, 1039, 39, 'Medicare', 82000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 36, 1040, 40, 'Commercial', 5500.00, 5200.00, 'Approved', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE())
UNION ALL SELECT 37, 1041, 41, 'Medicare', 35000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 38, 1042, 42, 'Commercial', 28000.00, 26500.00, 'Approved', DATEADD(DAY, -8, CURRENT_DATE()), CURRENT_DATE()
UNION ALL SELECT 39, 1044, 44, 'Commercial', 72000.00, 68000.00, 'Approved', DATEADD(DAY, -2, CURRENT_DATE()), NULL
UNION ALL SELECT 40, 1045, 45, 'Medicare', 45000.00, NULL, 'Pending', DATEADD(DAY, -2, CURRENT_DATE()), NULL;



CREATE OR REPLACE TABLE HEALTHCARE_HOL_DB.CLINICAL.DAILY_CENSUS (
  CENSUS_ID INTEGER,
  DEPARTMENT_ID INTEGER,
  CENSUS_DATE DATE,
  ADMISSIONS INTEGER,
  DISCHARGES INTEGER,
  OCCUPANCY_COUNT INTEGER,
  AVAILABLE_BEDS INTEGER
);

INSERT INTO HEALTHCARE_HOL_DB.CLINICAL.DAILY_CENSUS
SELECT 1, 1, DATEADD(DAY, -89, CURRENT_DATE()), 7, 7, 43, 50
UNION ALL SELECT 2, 1, DATEADD(DAY, -88, CURRENT_DATE()), 8, 8, 44, 50
UNION ALL SELECT 3, 1, DATEADD(DAY, -87, CURRENT_DATE()), 10, 5, 49, 50
UNION ALL SELECT 4, 1, DATEADD(DAY, -86, CURRENT_DATE()), 6, 7, 42, 50
UNION ALL SELECT 5, 1, DATEADD(DAY, -85, CURRENT_DATE()), 9, 7, 47, 50
UNION ALL SELECT 6, 1, DATEADD(DAY, -84, CURRENT_DATE()), 5, 5, 43, 50
UNION ALL SELECT 7, 1, DATEADD(DAY, -83, CURRENT_DATE()), 5, 4, 46, 50
UNION ALL SELECT 8, 1, DATEADD(DAY, -82, CURRENT_DATE()), 7, 6, 45, 50
UNION ALL SELECT 9, 1, DATEADD(DAY, -81, CURRENT_DATE()), 7, 6, 41, 50
UNION ALL SELECT 10, 1, DATEADD(DAY, -80, CURRENT_DATE()), 9, 6, 43, 50
UNION ALL SELECT 11, 1, DATEADD(DAY, -79, CURRENT_DATE()), 9, 6, 47, 50
UNION ALL SELECT 12, 1, DATEADD(DAY, -78, CURRENT_DATE()), 7, 6, 42, 50
UNION ALL SELECT 13, 1, DATEADD(DAY, -77, CURRENT_DATE()), 5, 3, 44, 50
UNION ALL SELECT 14, 1, DATEADD(DAY, -76, CURRENT_DATE()), 4, 4, 41, 50
UNION ALL SELECT 15, 1, DATEADD(DAY, -75, CURRENT_DATE()), 6, 7, 41, 50
UNION ALL SELECT 16, 1, DATEADD(DAY, -74, CURRENT_DATE()), 6, 7, 40, 50
UNION ALL SELECT 17, 1, DATEADD(DAY, -73, CURRENT_DATE()), 8, 5, 47, 50
UNION ALL SELECT 18, 1, DATEADD(DAY, -72, CURRENT_DATE()), 5, 5, 40, 50
UNION ALL SELECT 19, 1, DATEADD(DAY, -71, CURRENT_DATE()), 8, 6, 43, 50
UNION ALL SELECT 20, 1, DATEADD(DAY, -70, CURRENT_DATE()), 6, 3, 47, 50
UNION ALL SELECT 21, 1, DATEADD(DAY, -69, CURRENT_DATE()), 6, 4, 45, 50
UNION ALL SELECT 22, 1, DATEADD(DAY, -68, CURRENT_DATE()), 8, 8, 40, 50
UNION ALL SELECT 23, 1, DATEADD(DAY, -67, CURRENT_DATE()), 7, 8, 42, 50
UNION ALL SELECT 24, 1, DATEADD(DAY, -66, CURRENT_DATE()), 6, 5, 41, 50
UNION ALL SELECT 25, 1, DATEADD(DAY, -65, CURRENT_DATE()), 9, 5, 48, 50
UNION ALL SELECT 26, 1, DATEADD(DAY, -64, CURRENT_DATE()), 6, 6, 44, 50
UNION ALL SELECT 27, 1, DATEADD(DAY, -63, CURRENT_DATE()), 4, 5, 38, 50
UNION ALL SELECT 28, 1, DATEADD(DAY, -62, CURRENT_DATE()), 4, 4, 41, 50
UNION ALL SELECT 29, 1, DATEADD(DAY, -61, CURRENT_DATE()), 9, 7, 44, 50
UNION ALL SELECT 30, 1, DATEADD(DAY, -60, CURRENT_DATE()), 7, 5, 43, 50
UNION ALL SELECT 31, 1, DATEADD(DAY, -59, CURRENT_DATE()), 7, 8, 40, 50
UNION ALL SELECT 32, 1, DATEADD(DAY, -58, CURRENT_DATE()), 6, 6, 41, 50
UNION ALL SELECT 33, 1, DATEADD(DAY, -57, CURRENT_DATE()), 6, 6, 40, 50
UNION ALL SELECT 34, 1, DATEADD(DAY, -56, CURRENT_DATE()), 6, 5, 42, 50
UNION ALL SELECT 35, 1, DATEADD(DAY, -55, CURRENT_DATE()), 5, 6, 42, 50
UNION ALL SELECT 36, 1, DATEADD(DAY, -54, CURRENT_DATE()), 7, 6, 40, 50
UNION ALL SELECT 37, 1, DATEADD(DAY, -53, CURRENT_DATE()), 7, 6, 41, 50
UNION ALL SELECT 38, 1, DATEADD(DAY, -52, CURRENT_DATE()), 10, 5, 45, 50
UNION ALL SELECT 39, 1, DATEADD(DAY, -51, CURRENT_DATE()), 10, 6, 48, 50
UNION ALL SELECT 40, 1, DATEADD(DAY, -50, CURRENT_DATE()), 9, 9, 43, 50
UNION ALL SELECT 41, 1, DATEADD(DAY, -49, CURRENT_DATE()), 6, 6, 43, 50
UNION ALL SELECT 42, 1, DATEADD(DAY, -48, CURRENT_DATE()), 7, 6, 45, 50
UNION ALL SELECT 43, 1, DATEADD(DAY, -47, CURRENT_DATE()), 8, 8, 42, 50
UNION ALL SELECT 44, 1, DATEADD(DAY, -46, CURRENT_DATE()), 9, 8, 44, 50
UNION ALL SELECT 45, 1, DATEADD(DAY, -45, CURRENT_DATE()), 8, 9, 39, 50
UNION ALL SELECT 46, 1, DATEADD(DAY, -44, CURRENT_DATE()), 8, 5, 43, 50
UNION ALL SELECT 47, 1, DATEADD(DAY, -43, CURRENT_DATE()), 7, 9, 41, 50
UNION ALL SELECT 48, 1, DATEADD(DAY, -42, CURRENT_DATE()), 5, 5, 44, 50
UNION ALL SELECT 49, 1, DATEADD(DAY, -41, CURRENT_DATE()), 6, 7, 42, 50
UNION ALL SELECT 50, 1, DATEADD(DAY, -40, CURRENT_DATE()), 6, 6, 41, 50
UNION ALL SELECT 51, 1, DATEADD(DAY, -39, CURRENT_DATE()), 9, 8, 45, 50
UNION ALL SELECT 52, 1, DATEADD(DAY, -38, CURRENT_DATE()), 9, 6, 45, 50
UNION ALL SELECT 53, 1, DATEADD(DAY, -37, CURRENT_DATE()), 9, 8, 45, 50
UNION ALL SELECT 54, 1, DATEADD(DAY, -36, CURRENT_DATE()), 9, 7, 46, 50
UNION ALL SELECT 55, 1, DATEADD(DAY, -35, CURRENT_DATE()), 4, 7, 36, 50
UNION ALL SELECT 56, 1, DATEADD(DAY, -34, CURRENT_DATE()), 8, 6, 43, 50
UNION ALL SELECT 57, 1, DATEADD(DAY, -33, CURRENT_DATE()), 7, 9, 42, 50
UNION ALL SELECT 58, 1, DATEADD(DAY, -32, CURRENT_DATE()), 8, 6, 46, 50
UNION ALL SELECT 59, 1, DATEADD(DAY, -31, CURRENT_DATE()), 9, 9, 41, 50
UNION ALL SELECT 60, 1, DATEADD(DAY, -30, CURRENT_DATE()), 8, 10, 43, 50
UNION ALL SELECT 61, 1, DATEADD(DAY, -29, CURRENT_DATE()), 8, 10, 38, 50
UNION ALL SELECT 62, 1, DATEADD(DAY, -28, CURRENT_DATE()), 5, 4, 43, 50
UNION ALL SELECT 63, 1, DATEADD(DAY, -27, CURRENT_DATE()), 8, 4, 48, 50
UNION ALL SELECT 64, 1, DATEADD(DAY, -26, CURRENT_DATE()), 9, 7, 45, 50
UNION ALL SELECT 65, 1, DATEADD(DAY, -25, CURRENT_DATE()), 7, 7, 39, 50
UNION ALL SELECT 66, 1, DATEADD(DAY, -24, CURRENT_DATE()), 9, 6, 43, 50
UNION ALL SELECT 67, 1, DATEADD(DAY, -23, CURRENT_DATE()), 11, 8, 42, 50
UNION ALL SELECT 68, 1, DATEADD(DAY, -22, CURRENT_DATE()), 7, 9, 42, 50
UNION ALL SELECT 69, 1, DATEADD(DAY, -21, CURRENT_DATE()), 8, 6, 46, 50
UNION ALL SELECT 70, 1, DATEADD(DAY, -20, CURRENT_DATE()), 5, 4, 46, 50
UNION ALL SELECT 71, 1, DATEADD(DAY, -19, CURRENT_DATE()), 7, 7, 40, 50
UNION ALL SELECT 72, 1, DATEADD(DAY, -18, CURRENT_DATE()), 10, 7, 42, 50
UNION ALL SELECT 73, 1, DATEADD(DAY, -17, CURRENT_DATE()), 9, 8, 43, 50
UNION ALL SELECT 74, 1, DATEADD(DAY, -16, CURRENT_DATE()), 7, 7, 42, 50
UNION ALL SELECT 75, 1, DATEADD(DAY, -15, CURRENT_DATE()), 11, 9, 42, 50
UNION ALL SELECT 76, 1, DATEADD(DAY, -14, CURRENT_DATE()), 7, 6, 43, 50
UNION ALL SELECT 77, 1, DATEADD(DAY, -13, CURRENT_DATE()), 6, 4, 47, 50
UNION ALL SELECT 78, 1, DATEADD(DAY, -12, CURRENT_DATE()), 6, 7, 41, 50
UNION ALL SELECT 79, 1, DATEADD(DAY, -11, CURRENT_DATE()), 9, 10, 39, 50
UNION ALL SELECT 80, 1, DATEADD(DAY, -10, CURRENT_DATE()), 8, 8, 40, 50
UNION ALL SELECT 81, 1, DATEADD(DAY, -9, CURRENT_DATE()), 10, 8, 42, 50
UNION ALL SELECT 82, 1, DATEADD(DAY, -8, CURRENT_DATE()), 7, 7, 39, 50
UNION ALL SELECT 83, 1, DATEADD(DAY, -7, CURRENT_DATE()), 6, 5, 46, 50
UNION ALL SELECT 84, 1, DATEADD(DAY, -6, CURRENT_DATE()), 4, 5, 38, 50
UNION ALL SELECT 85, 1, DATEADD(DAY, -5, CURRENT_DATE()), 9, 7, 46, 50
UNION ALL SELECT 86, 1, DATEADD(DAY, -4, CURRENT_DATE()), 9, 7, 47, 50
UNION ALL SELECT 87, 1, DATEADD(DAY, -3, CURRENT_DATE()), 8, 9, 39, 50
UNION ALL SELECT 88, 1, DATEADD(DAY, -2, CURRENT_DATE()), 10, 8, 42, 50
UNION ALL SELECT 89, 1, DATEADD(DAY, -1, CURRENT_DATE()), 7, 7, 43, 50
UNION ALL SELECT 90, 1, DATEADD(DAY, -0, CURRENT_DATE()), 5, 4, 45, 50
UNION ALL SELECT 91, 2, DATEADD(DAY, -89, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 92, 2, DATEADD(DAY, -88, CURRENT_DATE()), 4, 4, 31, 35
UNION ALL SELECT 93, 2, DATEADD(DAY, -87, CURRENT_DATE()), 6, 5, 29, 35
UNION ALL SELECT 94, 2, DATEADD(DAY, -86, CURRENT_DATE()), 4, 6, 24, 35
UNION ALL SELECT 95, 2, DATEADD(DAY, -85, CURRENT_DATE()), 5, 6, 30, 35
UNION ALL SELECT 96, 2, DATEADD(DAY, -84, CURRENT_DATE()), 3, 4, 24, 35
UNION ALL SELECT 97, 2, DATEADD(DAY, -83, CURRENT_DATE()), 3, 3, 27, 35
UNION ALL SELECT 98, 2, DATEADD(DAY, -82, CURRENT_DATE()), 5, 5, 27, 35
UNION ALL SELECT 99, 2, DATEADD(DAY, -81, CURRENT_DATE()), 4, 4, 31, 35
UNION ALL SELECT 100, 2, DATEADD(DAY, -80, CURRENT_DATE()), 6, 4, 31, 35
UNION ALL SELECT 101, 2, DATEADD(DAY, -79, CURRENT_DATE()), 5, 4, 27, 35
UNION ALL SELECT 102, 2, DATEADD(DAY, -78, CURRENT_DATE()), 5, 5, 31, 35
UNION ALL SELECT 103, 2, DATEADD(DAY, -77, CURRENT_DATE()), 3, 4, 27, 35
UNION ALL SELECT 104, 2, DATEADD(DAY, -76, CURRENT_DATE()), 3, 4, 28, 35
UNION ALL SELECT 105, 2, DATEADD(DAY, -75, CURRENT_DATE()), 3, 6, 26, 35
UNION ALL SELECT 106, 2, DATEADD(DAY, -74, CURRENT_DATE()), 6, 6, 29, 35
UNION ALL SELECT 107, 2, DATEADD(DAY, -73, CURRENT_DATE()), 5, 6, 27, 35
UNION ALL SELECT 108, 2, DATEADD(DAY, -72, CURRENT_DATE()), 5, 5, 27, 35
UNION ALL SELECT 109, 2, DATEADD(DAY, -71, CURRENT_DATE()), 4, 5, 25, 35
UNION ALL SELECT 110, 2, DATEADD(DAY, -70, CURRENT_DATE()), 2, 4, 26, 35
UNION ALL SELECT 111, 2, DATEADD(DAY, -69, CURRENT_DATE()), 4, 4, 27, 35
UNION ALL SELECT 112, 2, DATEADD(DAY, -68, CURRENT_DATE()), 4, 5, 26, 35
UNION ALL SELECT 113, 2, DATEADD(DAY, -67, CURRENT_DATE()), 5, 6, 25, 35
UNION ALL SELECT 114, 2, DATEADD(DAY, -66, CURRENT_DATE()), 3, 4, 27, 35
UNION ALL SELECT 115, 2, DATEADD(DAY, -65, CURRENT_DATE()), 4, 5, 25, 35
UNION ALL SELECT 116, 2, DATEADD(DAY, -64, CURRENT_DATE()), 4, 5, 27, 35
UNION ALL SELECT 117, 2, DATEADD(DAY, -63, CURRENT_DATE()), 4, 4, 27, 35
UNION ALL SELECT 118, 2, DATEADD(DAY, -62, CURRENT_DATE()), 3, 3, 27, 35
UNION ALL SELECT 119, 2, DATEADD(DAY, -61, CURRENT_DATE()), 4, 5, 25, 35
UNION ALL SELECT 120, 2, DATEADD(DAY, -60, CURRENT_DATE()), 4, 4, 27, 35
UNION ALL SELECT 121, 2, DATEADD(DAY, -59, CURRENT_DATE()), 5, 6, 26, 35
UNION ALL SELECT 122, 2, DATEADD(DAY, -58, CURRENT_DATE()), 6, 6, 28, 35
UNION ALL SELECT 123, 2, DATEADD(DAY, -57, CURRENT_DATE()), 3, 5, 28, 35
UNION ALL SELECT 124, 2, DATEADD(DAY, -56, CURRENT_DATE()), 3, 3, 25, 35
UNION ALL SELECT 125, 2, DATEADD(DAY, -55, CURRENT_DATE()), 3, 4, 25, 35
UNION ALL SELECT 126, 2, DATEADD(DAY, -54, CURRENT_DATE()), 5, 5, 26, 35
UNION ALL SELECT 127, 2, DATEADD(DAY, -53, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 128, 2, DATEADD(DAY, -52, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 129, 2, DATEADD(DAY, -51, CURRENT_DATE()), 5, 6, 24, 35
UNION ALL SELECT 130, 2, DATEADD(DAY, -50, CURRENT_DATE()), 3, 6, 27, 35
UNION ALL SELECT 131, 2, DATEADD(DAY, -49, CURRENT_DATE()), 3, 3, 28, 35
UNION ALL SELECT 132, 2, DATEADD(DAY, -48, CURRENT_DATE()), 4, 4, 30, 35
UNION ALL SELECT 133, 2, DATEADD(DAY, -47, CURRENT_DATE()), 6, 4, 28, 35
UNION ALL SELECT 134, 2, DATEADD(DAY, -46, CURRENT_DATE()), 5, 6, 28, 35
UNION ALL SELECT 135, 2, DATEADD(DAY, -45, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 136, 2, DATEADD(DAY, -44, CURRENT_DATE()), 6, 5, 29, 35
UNION ALL SELECT 137, 2, DATEADD(DAY, -43, CURRENT_DATE()), 5, 4, 30, 35
UNION ALL SELECT 138, 2, DATEADD(DAY, -42, CURRENT_DATE()), 3, 4, 27, 35
UNION ALL SELECT 139, 2, DATEADD(DAY, -41, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 140, 2, DATEADD(DAY, -40, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 141, 2, DATEADD(DAY, -39, CURRENT_DATE()), 6, 4, 31, 35
UNION ALL SELECT 142, 2, DATEADD(DAY, -38, CURRENT_DATE()), 7, 6, 30, 35
UNION ALL SELECT 143, 2, DATEADD(DAY, -37, CURRENT_DATE()), 5, 4, 29, 35
UNION ALL SELECT 144, 2, DATEADD(DAY, -36, CURRENT_DATE()), 7, 5, 32, 35
UNION ALL SELECT 145, 2, DATEADD(DAY, -35, CURRENT_DATE()), 4, 3, 31, 35
UNION ALL SELECT 146, 2, DATEADD(DAY, -34, CURRENT_DATE()), 5, 5, 29, 35
UNION ALL SELECT 147, 2, DATEADD(DAY, -33, CURRENT_DATE()), 6, 7, 24, 35
UNION ALL SELECT 148, 2, DATEADD(DAY, -32, CURRENT_DATE()), 7, 4, 30, 35
UNION ALL SELECT 149, 2, DATEADD(DAY, -31, CURRENT_DATE()), 5, 7, 25, 35
UNION ALL SELECT 150, 2, DATEADD(DAY, -30, CURRENT_DATE()), 4, 7, 26, 35
UNION ALL SELECT 151, 2, DATEADD(DAY, -29, CURRENT_DATE()), 4, 5, 24, 35
UNION ALL SELECT 152, 2, DATEADD(DAY, -28, CURRENT_DATE()), 4, 4, 26, 35
UNION ALL SELECT 153, 2, DATEADD(DAY, -27, CURRENT_DATE()), 3, 3, 27, 35
UNION ALL SELECT 154, 2, DATEADD(DAY, -26, CURRENT_DATE()), 5, 5, 27, 35
UNION ALL SELECT 155, 2, DATEADD(DAY, -25, CURRENT_DATE()), 5, 6, 26, 35
UNION ALL SELECT 156, 2, DATEADD(DAY, -24, CURRENT_DATE()), 5, 7, 26, 35
UNION ALL SELECT 157, 2, DATEADD(DAY, -23, CURRENT_DATE()), 6, 7, 27, 35
UNION ALL SELECT 158, 2, DATEADD(DAY, -22, CURRENT_DATE()), 5, 6, 29, 35
UNION ALL SELECT 159, 2, DATEADD(DAY, -21, CURRENT_DATE()), 4, 3, 27, 35
UNION ALL SELECT 160, 2, DATEADD(DAY, -20, CURRENT_DATE()), 5, 4, 27, 35
UNION ALL SELECT 161, 2, DATEADD(DAY, -19, CURRENT_DATE()), 5, 6, 29, 35
UNION ALL SELECT 162, 2, DATEADD(DAY, -18, CURRENT_DATE()), 7, 5, 30, 35
UNION ALL SELECT 163, 2, DATEADD(DAY, -17, CURRENT_DATE()), 7, 7, 27, 35
UNION ALL SELECT 164, 2, DATEADD(DAY, -16, CURRENT_DATE()), 4, 7, 27, 35
UNION ALL SELECT 165, 2, DATEADD(DAY, -15, CURRENT_DATE()), 7, 7, 28, 35
UNION ALL SELECT 166, 2, DATEADD(DAY, -14, CURRENT_DATE()), 5, 4, 30, 35
UNION ALL SELECT 167, 2, DATEADD(DAY, -13, CURRENT_DATE()), 3, 4, 25, 35
UNION ALL SELECT 168, 2, DATEADD(DAY, -12, CURRENT_DATE()), 5, 5, 28, 35
UNION ALL SELECT 169, 2, DATEADD(DAY, -11, CURRENT_DATE()), 6, 7, 24, 35
UNION ALL SELECT 170, 2, DATEADD(DAY, -10, CURRENT_DATE()), 4, 5, 25, 35
UNION ALL SELECT 171, 2, DATEADD(DAY, -9, CURRENT_DATE()), 5, 6, 25, 35
UNION ALL SELECT 172, 2, DATEADD(DAY, -8, CURRENT_DATE()), 7, 6, 27, 35
UNION ALL SELECT 173, 2, DATEADD(DAY, -7, CURRENT_DATE()), 3, 3, 29, 35
UNION ALL SELECT 174, 2, DATEADD(DAY, -6, CURRENT_DATE()), 4, 4, 30, 35
UNION ALL SELECT 175, 2, DATEADD(DAY, -5, CURRENT_DATE()), 4, 4, 30, 35
UNION ALL SELECT 176, 2, DATEADD(DAY, -4, CURRENT_DATE()), 4, 6, 26, 35
UNION ALL SELECT 177, 2, DATEADD(DAY, -3, CURRENT_DATE()), 7, 4, 34, 35
UNION ALL SELECT 178, 2, DATEADD(DAY, -2, CURRENT_DATE()), 4, 6, 24, 35
UNION ALL SELECT 179, 2, DATEADD(DAY, -1, CURRENT_DATE()), 4, 6, 28, 35
UNION ALL SELECT 180, 2, DATEADD(DAY, -0, CURRENT_DATE()), 3, 4, 26, 35
UNION ALL SELECT 181, 3, DATEADD(DAY, -89, CURRENT_DATE()), 10, 11, 84, 100
UNION ALL SELECT 182, 3, DATEADD(DAY, -88, CURRENT_DATE()), 11, 10, 85, 100
UNION ALL SELECT 183, 3, DATEADD(DAY, -87, CURRENT_DATE()), 9, 10, 83, 100
UNION ALL SELECT 184, 3, DATEADD(DAY, -86, CURRENT_DATE()), 9, 12, 82, 100
UNION ALL SELECT 185, 3, DATEADD(DAY, -85, CURRENT_DATE()), 14, 9, 91, 100
UNION ALL SELECT 186, 3, DATEADD(DAY, -84, CURRENT_DATE()), 6, 7, 86, 100
UNION ALL SELECT 187, 3, DATEADD(DAY, -83, CURRENT_DATE()), 6, 7, 81, 100
UNION ALL SELECT 188, 3, DATEADD(DAY, -82, CURRENT_DATE()), 14, 12, 85, 100
UNION ALL SELECT 189, 3, DATEADD(DAY, -81, CURRENT_DATE()), 11, 9, 87, 100
UNION ALL SELECT 190, 3, DATEADD(DAY, -80, CURRENT_DATE()), 9, 13, 81, 100
UNION ALL SELECT 191, 3, DATEADD(DAY, -79, CURRENT_DATE()), 10, 7, 88, 100
UNION ALL SELECT 192, 3, DATEADD(DAY, -78, CURRENT_DATE()), 8, 11, 83, 100
UNION ALL SELECT 193, 3, DATEADD(DAY, -77, CURRENT_DATE()), 9, 7, 87, 100
UNION ALL SELECT 194, 3, DATEADD(DAY, -76, CURRENT_DATE()), 7, 9, 84, 100
UNION ALL SELECT 195, 3, DATEADD(DAY, -75, CURRENT_DATE()), 14, 12, 85, 100
UNION ALL SELECT 196, 3, DATEADD(DAY, -74, CURRENT_DATE()), 9, 10, 85, 100
UNION ALL SELECT 197, 3, DATEADD(DAY, -73, CURRENT_DATE()), 11, 11, 87, 100
UNION ALL SELECT 198, 3, DATEADD(DAY, -72, CURRENT_DATE()), 8, 12, 84, 100
UNION ALL SELECT 199, 3, DATEADD(DAY, -71, CURRENT_DATE()), 11, 7, 89, 100
UNION ALL SELECT 200, 3, DATEADD(DAY, -70, CURRENT_DATE()), 7, 8, 85, 100
UNION ALL SELECT 201, 3, DATEADD(DAY, -69, CURRENT_DATE()), 9, 9, 84, 100
UNION ALL SELECT 202, 3, DATEADD(DAY, -68, CURRENT_DATE()), 8, 11, 81, 100
UNION ALL SELECT 203, 3, DATEADD(DAY, -67, CURRENT_DATE()), 10, 12, 83, 100
UNION ALL SELECT 204, 3, DATEADD(DAY, -66, CURRENT_DATE()), 10, 13, 83, 100
UNION ALL SELECT 205, 3, DATEADD(DAY, -65, CURRENT_DATE()), 10, 10, 84, 100
UNION ALL SELECT 206, 3, DATEADD(DAY, -64, CURRENT_DATE()), 10, 9, 87, 100
UNION ALL SELECT 207, 3, DATEADD(DAY, -63, CURRENT_DATE()), 8, 6, 86, 100
UNION ALL SELECT 208, 3, DATEADD(DAY, -62, CURRENT_DATE()), 7, 6, 84, 100
UNION ALL SELECT 209, 3, DATEADD(DAY, -61, CURRENT_DATE()), 10, 8, 85, 100
UNION ALL SELECT 210, 3, DATEADD(DAY, -60, CURRENT_DATE()), 12, 7, 88, 100
UNION ALL SELECT 211, 3, DATEADD(DAY, -59, CURRENT_DATE()), 14, 9, 89, 100
UNION ALL SELECT 212, 3, DATEADD(DAY, -58, CURRENT_DATE()), 12, 10, 87, 100
UNION ALL SELECT 213, 3, DATEADD(DAY, -57, CURRENT_DATE()), 13, 10, 85, 100
UNION ALL SELECT 214, 3, DATEADD(DAY, -56, CURRENT_DATE()), 9, 9, 83, 100
UNION ALL SELECT 215, 3, DATEADD(DAY, -55, CURRENT_DATE()), 9, 7, 85, 100
UNION ALL SELECT 216, 3, DATEADD(DAY, -54, CURRENT_DATE()), 12, 9, 85, 100
UNION ALL SELECT 217, 3, DATEADD(DAY, -53, CURRENT_DATE()), 13, 7, 91, 100
UNION ALL SELECT 218, 3, DATEADD(DAY, -52, CURRENT_DATE()), 9, 12, 81, 100
UNION ALL SELECT 219, 3, DATEADD(DAY, -51, CURRENT_DATE()), 13, 11, 87, 100
UNION ALL SELECT 220, 3, DATEADD(DAY, -50, CURRENT_DATE()), 9, 11, 84, 100
UNION ALL SELECT 221, 3, DATEADD(DAY, -49, CURRENT_DATE()), 7, 7, 88, 100
UNION ALL SELECT 222, 3, DATEADD(DAY, -48, CURRENT_DATE()), 6, 7, 82, 100
UNION ALL SELECT 223, 3, DATEADD(DAY, -47, CURRENT_DATE()), 9, 14, 78, 100
UNION ALL SELECT 224, 3, DATEADD(DAY, -46, CURRENT_DATE()), 15, 10, 92, 100
UNION ALL SELECT 225, 3, DATEADD(DAY, -45, CURRENT_DATE()), 11, 14, 83, 100
UNION ALL SELECT 226, 3, DATEADD(DAY, -44, CURRENT_DATE()), 10, 10, 88, 100
UNION ALL SELECT 227, 3, DATEADD(DAY, -43, CURRENT_DATE()), 12, 8, 91, 100
UNION ALL SELECT 228, 3, DATEADD(DAY, -42, CURRENT_DATE()), 6, 10, 80, 100
UNION ALL SELECT 229, 3, DATEADD(DAY, -41, CURRENT_DATE()), 7, 8, 85, 100
UNION ALL SELECT 230, 3, DATEADD(DAY, -40, CURRENT_DATE()), 14, 11, 87, 100
UNION ALL SELECT 231, 3, DATEADD(DAY, -39, CURRENT_DATE()), 16, 11, 89, 100
UNION ALL SELECT 232, 3, DATEADD(DAY, -38, CURRENT_DATE()), 13, 14, 82, 100
UNION ALL SELECT 233, 3, DATEADD(DAY, -37, CURRENT_DATE()), 11, 12, 84, 100
UNION ALL SELECT 234, 3, DATEADD(DAY, -36, CURRENT_DATE()), 11, 8, 89, 100
UNION ALL SELECT 235, 3, DATEADD(DAY, -35, CURRENT_DATE()), 7, 6, 84, 100
UNION ALL SELECT 236, 3, DATEADD(DAY, -34, CURRENT_DATE()), 7, 10, 82, 100
UNION ALL SELECT 237, 3, DATEADD(DAY, -33, CURRENT_DATE()), 12, 9, 87, 100
UNION ALL SELECT 238, 3, DATEADD(DAY, -32, CURRENT_DATE()), 9, 10, 82, 100
UNION ALL SELECT 239, 3, DATEADD(DAY, -31, CURRENT_DATE()), 11, 14, 82, 100
UNION ALL SELECT 240, 3, DATEADD(DAY, -30, CURRENT_DATE()), 9, 9, 85, 100
UNION ALL SELECT 241, 3, DATEADD(DAY, -29, CURRENT_DATE()), 13, 12, 84, 100
UNION ALL SELECT 242, 3, DATEADD(DAY, -28, CURRENT_DATE()), 9, 6, 88, 100
UNION ALL SELECT 243, 3, DATEADD(DAY, -27, CURRENT_DATE()), 7, 6, 83, 100
UNION ALL SELECT 244, 3, DATEADD(DAY, -26, CURRENT_DATE()), 10, 15, 81, 100
UNION ALL SELECT 245, 3, DATEADD(DAY, -25, CURRENT_DATE()), 10, 9, 84, 100
UNION ALL SELECT 246, 3, DATEADD(DAY, -24, CURRENT_DATE()), 14, 10, 91, 100
UNION ALL SELECT 247, 3, DATEADD(DAY, -23, CURRENT_DATE()), 17, 10, 90, 100
UNION ALL SELECT 248, 3, DATEADD(DAY, -22, CURRENT_DATE()), 14, 10, 87, 100
UNION ALL SELECT 249, 3, DATEADD(DAY, -21, CURRENT_DATE()), 7, 8, 86, 100
UNION ALL SELECT 250, 3, DATEADD(DAY, -20, CURRENT_DATE()), 9, 8, 85, 100
UNION ALL SELECT 251, 3, DATEADD(DAY, -19, CURRENT_DATE()), 10, 10, 87, 100
UNION ALL SELECT 252, 3, DATEADD(DAY, -18, CURRENT_DATE()), 16, 12, 91, 100
UNION ALL SELECT 253, 3, DATEADD(DAY, -17, CURRENT_DATE()), 14, 11, 91, 100
UNION ALL SELECT 254, 3, DATEADD(DAY, -16, CURRENT_DATE()), 11, 13, 81, 100
UNION ALL SELECT 255, 3, DATEADD(DAY, -15, CURRENT_DATE()), 13, 14, 87, 100
UNION ALL SELECT 256, 3, DATEADD(DAY, -14, CURRENT_DATE()), 8, 8, 83, 100
UNION ALL SELECT 257, 3, DATEADD(DAY, -13, CURRENT_DATE()), 7, 9, 84, 100
UNION ALL SELECT 258, 3, DATEADD(DAY, -12, CURRENT_DATE()), 15, 11, 92, 100
UNION ALL SELECT 259, 3, DATEADD(DAY, -11, CURRENT_DATE()), 9, 9, 88, 100
UNION ALL SELECT 260, 3, DATEADD(DAY, -10, CURRENT_DATE()), 9, 13, 84, 100
UNION ALL SELECT 261, 3, DATEADD(DAY, -9, CURRENT_DATE()), 11, 10, 87, 100
UNION ALL SELECT 262, 3, DATEADD(DAY, -8, CURRENT_DATE()), 13, 10, 88, 100
UNION ALL SELECT 263, 3, DATEADD(DAY, -7, CURRENT_DATE()), 10, 9, 85, 100
UNION ALL SELECT 264, 3, DATEADD(DAY, -6, CURRENT_DATE()), 11, 6, 88, 100
UNION ALL SELECT 265, 3, DATEADD(DAY, -5, CURRENT_DATE()), 11, 12, 83, 100
UNION ALL SELECT 266, 3, DATEADD(DAY, -4, CURRENT_DATE()), 12, 14, 83, 100
UNION ALL SELECT 267, 3, DATEADD(DAY, -3, CURRENT_DATE()), 14, 9, 93, 100
UNION ALL SELECT 268, 3, DATEADD(DAY, -2, CURRENT_DATE()), 13, 13, 85, 100
UNION ALL SELECT 269, 3, DATEADD(DAY, -1, CURRENT_DATE()), 15, 12, 89, 100
UNION ALL SELECT 270, 3, DATEADD(DAY, -0, CURRENT_DATE()), 9, 6, 88, 100
UNION ALL SELECT 271, 4, DATEADD(DAY, -89, CURRENT_DATE()), 4, 5, 17, 25
UNION ALL SELECT 272, 4, DATEADD(DAY, -88, CURRENT_DATE()), 5, 5, 19, 25
UNION ALL SELECT 273, 4, DATEADD(DAY, -87, CURRENT_DATE()), 4, 3, 17, 25
UNION ALL SELECT 274, 4, DATEADD(DAY, -86, CURRENT_DATE()), 5, 5, 17, 25
UNION ALL SELECT 275, 4, DATEADD(DAY, -85, CURRENT_DATE()), 4, 4, 20, 25
UNION ALL SELECT 276, 4, DATEADD(DAY, -84, CURRENT_DATE()), 3, 3, 21, 25
UNION ALL SELECT 277, 4, DATEADD(DAY, -83, CURRENT_DATE()), 2, 3, 17, 25
UNION ALL SELECT 278, 4, DATEADD(DAY, -82, CURRENT_DATE()), 4, 3, 21, 25
UNION ALL SELECT 279, 4, DATEADD(DAY, -81, CURRENT_DATE()), 4, 3, 20, 25
UNION ALL SELECT 280, 4, DATEADD(DAY, -80, CURRENT_DATE()), 4, 3, 21, 25
UNION ALL SELECT 281, 4, DATEADD(DAY, -79, CURRENT_DATE()), 5, 3, 18, 25
UNION ALL SELECT 282, 4, DATEADD(DAY, -78, CURRENT_DATE()), 3, 4, 15, 25
UNION ALL SELECT 283, 4, DATEADD(DAY, -77, CURRENT_DATE()), 3, 3, 18, 25
UNION ALL SELECT 284, 4, DATEADD(DAY, -76, CURRENT_DATE()), 2, 2, 20, 25
UNION ALL SELECT 285, 4, DATEADD(DAY, -75, CURRENT_DATE()), 3, 4, 20, 25
UNION ALL SELECT 286, 4, DATEADD(DAY, -74, CURRENT_DATE()), 4, 4, 17, 25
UNION ALL SELECT 287, 4, DATEADD(DAY, -73, CURRENT_DATE()), 3, 4, 20, 25
UNION ALL SELECT 288, 4, DATEADD(DAY, -72, CURRENT_DATE()), 3, 4, 16, 25
UNION ALL SELECT 289, 4, DATEADD(DAY, -71, CURRENT_DATE()), 3, 3, 20, 25
UNION ALL SELECT 290, 4, DATEADD(DAY, -70, CURRENT_DATE()), 2, 3, 19, 25
UNION ALL SELECT 291, 4, DATEADD(DAY, -69, CURRENT_DATE()), 3, 3, 18, 25
UNION ALL SELECT 292, 4, DATEADD(DAY, -68, CURRENT_DATE()), 4, 4, 16, 25
UNION ALL SELECT 293, 4, DATEADD(DAY, -67, CURRENT_DATE()), 5, 3, 19, 25
UNION ALL SELECT 294, 4, DATEADD(DAY, -66, CURRENT_DATE()), 3, 5, 18, 25
UNION ALL SELECT 295, 4, DATEADD(DAY, -65, CURRENT_DATE()), 3, 3, 17, 25
UNION ALL SELECT 296, 4, DATEADD(DAY, -64, CURRENT_DATE()), 3, 3, 17, 25
UNION ALL SELECT 297, 4, DATEADD(DAY, -63, CURRENT_DATE()), 3, 3, 18, 25
UNION ALL SELECT 298, 4, DATEADD(DAY, -62, CURRENT_DATE()), 2, 3, 16, 25
UNION ALL SELECT 299, 4, DATEADD(DAY, -61, CURRENT_DATE()), 3, 3, 18, 25
UNION ALL SELECT 300, 4, DATEADD(DAY, -60, CURRENT_DATE()), 3, 5, 16, 25
UNION ALL SELECT 301, 4, DATEADD(DAY, -59, CURRENT_DATE()), 5, 3, 21, 25
UNION ALL SELECT 302, 4, DATEADD(DAY, -58, CURRENT_DATE()), 4, 4, 17, 25
UNION ALL SELECT 303, 4, DATEADD(DAY, -57, CURRENT_DATE()), 3, 3, 19, 25
UNION ALL SELECT 304, 4, DATEADD(DAY, -56, CURRENT_DATE()), 2, 2, 17, 25
UNION ALL SELECT 305, 4, DATEADD(DAY, -55, CURRENT_DATE()), 3, 3, 17, 25
UNION ALL SELECT 306, 4, DATEADD(DAY, -54, CURRENT_DATE()), 4, 3, 17, 25
UNION ALL SELECT 307, 4, DATEADD(DAY, -53, CURRENT_DATE()), 5, 5, 17, 25
UNION ALL SELECT 308, 4, DATEADD(DAY, -52, CURRENT_DATE()), 4, 4, 19, 25
UNION ALL SELECT 309, 4, DATEADD(DAY, -51, CURRENT_DATE()), 3, 5, 16, 25
UNION ALL SELECT 310, 4, DATEADD(DAY, -50, CURRENT_DATE()), 4, 3, 20, 25
UNION ALL SELECT 311, 4, DATEADD(DAY, -49, CURRENT_DATE()), 2, 3, 19, 25
UNION ALL SELECT 312, 4, DATEADD(DAY, -48, CURRENT_DATE()), 2, 3, 16, 25
UNION ALL SELECT 313, 4, DATEADD(DAY, -47, CURRENT_DATE()), 5, 3, 22, 25
UNION ALL SELECT 314, 4, DATEADD(DAY, -46, CURRENT_DATE()), 5, 3, 20, 25
UNION ALL SELECT 315, 4, DATEADD(DAY, -45, CURRENT_DATE()), 3, 4, 19, 25
UNION ALL SELECT 316, 4, DATEADD(DAY, -44, CURRENT_DATE()), 5, 4, 19, 25
UNION ALL SELECT 317, 4, DATEADD(DAY, -43, CURRENT_DATE()), 4, 5, 19, 25
UNION ALL SELECT 318, 4, DATEADD(DAY, -42, CURRENT_DATE()), 4, 3, 21, 25
UNION ALL SELECT 319, 4, DATEADD(DAY, -41, CURRENT_DATE()), 3, 2, 18, 25
UNION ALL SELECT 320, 4, DATEADD(DAY, -40, CURRENT_DATE()), 5, 4, 21, 25
UNION ALL SELECT 321, 4, DATEADD(DAY, -39, CURRENT_DATE()), 3, 5, 17, 25
UNION ALL SELECT 322, 4, DATEADD(DAY, -38, CURRENT_DATE()), 4, 4, 19, 25
UNION ALL SELECT 323, 4, DATEADD(DAY, -37, CURRENT_DATE()), 4, 5, 19, 25
UNION ALL SELECT 324, 4, DATEADD(DAY, -36, CURRENT_DATE()), 4, 4, 18, 25
UNION ALL SELECT 325, 4, DATEADD(DAY, -35, CURRENT_DATE()), 3, 3, 21, 25
UNION ALL SELECT 326, 4, DATEADD(DAY, -34, CURRENT_DATE()), 3, 3, 17, 25
UNION ALL SELECT 327, 4, DATEADD(DAY, -33, CURRENT_DATE()), 4, 3, 19, 25
UNION ALL SELECT 328, 4, DATEADD(DAY, -32, CURRENT_DATE()), 4, 3, 20, 25
UNION ALL SELECT 329, 4, DATEADD(DAY, -31, CURRENT_DATE()), 4, 5, 18, 25
UNION ALL SELECT 330, 4, DATEADD(DAY, -30, CURRENT_DATE()), 4, 3, 17, 25
UNION ALL SELECT 331, 4, DATEADD(DAY, -29, CURRENT_DATE()), 5, 5, 19, 25
UNION ALL SELECT 332, 4, DATEADD(DAY, -28, CURRENT_DATE()), 3, 2, 21, 25
UNION ALL SELECT 333, 4, DATEADD(DAY, -27, CURRENT_DATE()), 2, 4, 15, 25
UNION ALL SELECT 334, 4, DATEADD(DAY, -26, CURRENT_DATE()), 6, 5, 21, 25
UNION ALL SELECT 335, 4, DATEADD(DAY, -25, CURRENT_DATE()), 5, 5, 19, 25
UNION ALL SELECT 336, 4, DATEADD(DAY, -24, CURRENT_DATE()), 5, 4, 18, 25
UNION ALL SELECT 337, 4, DATEADD(DAY, -23, CURRENT_DATE()), 4, 6, 15, 25
UNION ALL SELECT 338, 4, DATEADD(DAY, -22, CURRENT_DATE()), 4, 5, 15, 25
UNION ALL SELECT 339, 4, DATEADD(DAY, -21, CURRENT_DATE()), 4, 3, 16, 25
UNION ALL SELECT 340, 4, DATEADD(DAY, -20, CURRENT_DATE()), 3, 3, 19, 25
UNION ALL SELECT 341, 4, DATEADD(DAY, -19, CURRENT_DATE()), 4, 4, 19, 25
UNION ALL SELECT 342, 4, DATEADD(DAY, -18, CURRENT_DATE()), 5, 3, 20, 25
UNION ALL SELECT 343, 4, DATEADD(DAY, -17, CURRENT_DATE()), 4, 4, 16, 25
UNION ALL SELECT 344, 4, DATEADD(DAY, -16, CURRENT_DATE()), 4, 5, 18, 25
UNION ALL SELECT 345, 4, DATEADD(DAY, -15, CURRENT_DATE()), 5, 3, 17, 25
UNION ALL SELECT 346, 4, DATEADD(DAY, -14, CURRENT_DATE()), 4, 3, 18, 25
UNION ALL SELECT 347, 4, DATEADD(DAY, -13, CURRENT_DATE()), 3, 3, 15, 25
UNION ALL SELECT 348, 4, DATEADD(DAY, -12, CURRENT_DATE()), 3, 5, 19, 25
UNION ALL SELECT 349, 4, DATEADD(DAY, -11, CURRENT_DATE()), 5, 4, 18, 25
UNION ALL SELECT 350, 4, DATEADD(DAY, -10, CURRENT_DATE()), 5, 4, 20, 25
UNION ALL SELECT 351, 4, DATEADD(DAY, -9, CURRENT_DATE()), 5, 3, 17, 25
UNION ALL SELECT 352, 4, DATEADD(DAY, -8, CURRENT_DATE()), 5, 5, 15, 25
UNION ALL SELECT 353, 4, DATEADD(DAY, -7, CURRENT_DATE()), 2, 3, 15, 25
UNION ALL SELECT 354, 4, DATEADD(DAY, -6, CURRENT_DATE()), 3, 2, 19, 25
UNION ALL SELECT 355, 4, DATEADD(DAY, -5, CURRENT_DATE()), 4, 5, 17, 25
UNION ALL SELECT 356, 4, DATEADD(DAY, -4, CURRENT_DATE()), 5, 5, 19, 25
UNION ALL SELECT 357, 4, DATEADD(DAY, -3, CURRENT_DATE()), 5, 5, 16, 25
UNION ALL SELECT 358, 4, DATEADD(DAY, -2, CURRENT_DATE()), 4, 4, 15, 25
UNION ALL SELECT 359, 4, DATEADD(DAY, -1, CURRENT_DATE()), 4, 3, 19, 25
UNION ALL SELECT 360, 4, DATEADD(DAY, -0, CURRENT_DATE()), 3, 2, 19, 25
UNION ALL SELECT 361, 5, DATEADD(DAY, -89, CURRENT_DATE()), 8, 7, 31, 40
UNION ALL SELECT 362, 5, DATEADD(DAY, -88, CURRENT_DATE()), 7, 7, 33, 40
UNION ALL SELECT 363, 5, DATEADD(DAY, -87, CURRENT_DATE()), 5, 6, 30, 40
UNION ALL SELECT 364, 5, DATEADD(DAY, -86, CURRENT_DATE()), 6, 5, 35, 40
UNION ALL SELECT 365, 5, DATEADD(DAY, -85, CURRENT_DATE()), 5, 5, 30, 40
UNION ALL SELECT 366, 5, DATEADD(DAY, -84, CURRENT_DATE()), 4, 3, 34, 40
UNION ALL SELECT 367, 5, DATEADD(DAY, -83, CURRENT_DATE()), 3, 5, 29, 40
UNION ALL SELECT 368, 5, DATEADD(DAY, -82, CURRENT_DATE()), 6, 7, 31, 40
UNION ALL SELECT 369, 5, DATEADD(DAY, -81, CURRENT_DATE()), 7, 7, 32, 40
UNION ALL SELECT 370, 5, DATEADD(DAY, -80, CURRENT_DATE()), 7, 7, 29, 40
UNION ALL SELECT 371, 5, DATEADD(DAY, -79, CURRENT_DATE()), 5, 4, 33, 40
UNION ALL SELECT 372, 5, DATEADD(DAY, -78, CURRENT_DATE()), 5, 5, 33, 40
UNION ALL SELECT 373, 5, DATEADD(DAY, -77, CURRENT_DATE()), 5, 4, 35, 40
UNION ALL SELECT 374, 5, DATEADD(DAY, -76, CURRENT_DATE()), 3, 5, 31, 40
UNION ALL SELECT 375, 5, DATEADD(DAY, -75, CURRENT_DATE()), 7, 6, 32, 40
UNION ALL SELECT 376, 5, DATEADD(DAY, -74, CURRENT_DATE()), 5, 5, 33, 40
UNION ALL SELECT 377, 5, DATEADD(DAY, -73, CURRENT_DATE()), 6, 6, 33, 40
UNION ALL SELECT 378, 5, DATEADD(DAY, -72, CURRENT_DATE()), 5, 6, 33, 40
UNION ALL SELECT 379, 5, DATEADD(DAY, -71, CURRENT_DATE()), 4, 7, 28, 40
UNION ALL SELECT 380, 5, DATEADD(DAY, -70, CURRENT_DATE()), 4, 4, 30, 40
UNION ALL SELECT 381, 5, DATEADD(DAY, -69, CURRENT_DATE()), 3, 3, 32, 40
UNION ALL SELECT 382, 5, DATEADD(DAY, -68, CURRENT_DATE()), 7, 4, 35, 40
UNION ALL SELECT 383, 5, DATEADD(DAY, -67, CURRENT_DATE()), 7, 5, 32, 40
UNION ALL SELECT 384, 5, DATEADD(DAY, -66, CURRENT_DATE()), 4, 6, 30, 40
UNION ALL SELECT 385, 5, DATEADD(DAY, -65, CURRENT_DATE()), 6, 5, 31, 40
UNION ALL SELECT 386, 5, DATEADD(DAY, -64, CURRENT_DATE()), 4, 6, 30, 40
UNION ALL SELECT 387, 5, DATEADD(DAY, -63, CURRENT_DATE()), 4, 3, 35, 40
UNION ALL SELECT 388, 5, DATEADD(DAY, -62, CURRENT_DATE()), 3, 4, 29, 40
UNION ALL SELECT 389, 5, DATEADD(DAY, -61, CURRENT_DATE()), 5, 6, 29, 40
UNION ALL SELECT 390, 5, DATEADD(DAY, -60, CURRENT_DATE()), 6, 6, 31, 40
UNION ALL SELECT 391, 5, DATEADD(DAY, -59, CURRENT_DATE()), 7, 7, 31, 40
UNION ALL SELECT 392, 5, DATEADD(DAY, -58, CURRENT_DATE()), 6, 7, 34, 40
UNION ALL SELECT 393, 5, DATEADD(DAY, -57, CURRENT_DATE()), 6, 5, 36, 40
UNION ALL SELECT 394, 5, DATEADD(DAY, -56, CURRENT_DATE()), 4, 3, 30, 40
UNION ALL SELECT 395, 5, DATEADD(DAY, -55, CURRENT_DATE()), 3, 4, 28, 40
UNION ALL SELECT 396, 5, DATEADD(DAY, -54, CURRENT_DATE()), 5, 6, 33, 40
UNION ALL SELECT 397, 5, DATEADD(DAY, -53, CURRENT_DATE()), 7, 5, 36, 40
UNION ALL SELECT 398, 5, DATEADD(DAY, -52, CURRENT_DATE()), 6, 7, 32, 40
UNION ALL SELECT 399, 5, DATEADD(DAY, -51, CURRENT_DATE()), 5, 7, 32, 40
UNION ALL SELECT 400, 5, DATEADD(DAY, -50, CURRENT_DATE()), 7, 6, 31, 40
UNION ALL SELECT 401, 5, DATEADD(DAY, -49, CURRENT_DATE()), 4, 3, 34, 40
UNION ALL SELECT 402, 5, DATEADD(DAY, -48, CURRENT_DATE()), 4, 4, 34, 40
UNION ALL SELECT 403, 5, DATEADD(DAY, -47, CURRENT_DATE()), 6, 7, 28, 40
UNION ALL SELECT 404, 5, DATEADD(DAY, -46, CURRENT_DATE()), 5, 8, 30, 40
UNION ALL SELECT 405, 5, DATEADD(DAY, -45, CURRENT_DATE()), 4, 6, 33, 40
UNION ALL SELECT 406, 5, DATEADD(DAY, -44, CURRENT_DATE()), 7, 5, 36, 40
UNION ALL SELECT 407, 5, DATEADD(DAY, -43, CURRENT_DATE()), 5, 8, 29, 40
UNION ALL SELECT 408, 5, DATEADD(DAY, -42, CURRENT_DATE()), 4, 4, 32, 40
UNION ALL SELECT 409, 5, DATEADD(DAY, -41, CURRENT_DATE()), 4, 4, 30, 40
UNION ALL SELECT 410, 5, DATEADD(DAY, -40, CURRENT_DATE()), 7, 5, 32, 40
UNION ALL SELECT 411, 5, DATEADD(DAY, -39, CURRENT_DATE()), 5, 7, 31, 40
UNION ALL SELECT 412, 5, DATEADD(DAY, -38, CURRENT_DATE()), 7, 5, 36, 40
UNION ALL SELECT 413, 5, DATEADD(DAY, -37, CURRENT_DATE()), 7, 5, 32, 40
UNION ALL SELECT 414, 5, DATEADD(DAY, -36, CURRENT_DATE()), 5, 7, 32, 40
UNION ALL SELECT 415, 5, DATEADD(DAY, -35, CURRENT_DATE()), 5, 5, 29, 40
UNION ALL SELECT 416, 5, DATEADD(DAY, -34, CURRENT_DATE()), 4, 5, 28, 40
UNION ALL SELECT 417, 5, DATEADD(DAY, -33, CURRENT_DATE()), 5, 8, 28, 40
UNION ALL SELECT 418, 5, DATEADD(DAY, -32, CURRENT_DATE()), 8, 6, 32, 40
UNION ALL SELECT 419, 5, DATEADD(DAY, -31, CURRENT_DATE()), 7, 5, 33, 40
UNION ALL SELECT 420, 5, DATEADD(DAY, -30, CURRENT_DATE()), 7, 5, 33, 40
UNION ALL SELECT 421, 5, DATEADD(DAY, -29, CURRENT_DATE()), 5, 8, 31, 40
UNION ALL SELECT 422, 5, DATEADD(DAY, -28, CURRENT_DATE()), 5, 4, 30, 40
UNION ALL SELECT 423, 5, DATEADD(DAY, -27, CURRENT_DATE()), 4, 5, 29, 40
UNION ALL SELECT 424, 5, DATEADD(DAY, -26, CURRENT_DATE()), 5, 7, 32, 40
UNION ALL SELECT 425, 5, DATEADD(DAY, -25, CURRENT_DATE()), 8, 6, 34, 40
UNION ALL SELECT 426, 5, DATEADD(DAY, -24, CURRENT_DATE()), 7, 5, 32, 40
UNION ALL SELECT 427, 5, DATEADD(DAY, -23, CURRENT_DATE()), 6, 7, 31, 40
UNION ALL SELECT 428, 5, DATEADD(DAY, -22, CURRENT_DATE()), 5, 6, 33, 40
UNION ALL SELECT 429, 5, DATEADD(DAY, -21, CURRENT_DATE()), 4, 3, 33, 40
UNION ALL SELECT 430, 5, DATEADD(DAY, -20, CURRENT_DATE()), 6, 6, 33, 40
UNION ALL SELECT 431, 5, DATEADD(DAY, -19, CURRENT_DATE()), 8, 5, 35, 40
UNION ALL SELECT 432, 5, DATEADD(DAY, -18, CURRENT_DATE()), 5, 6, 29, 40
UNION ALL SELECT 433, 5, DATEADD(DAY, -17, CURRENT_DATE()), 7, 6, 34, 40
UNION ALL SELECT 434, 5, DATEADD(DAY, -16, CURRENT_DATE()), 8, 8, 33, 40
UNION ALL SELECT 435, 5, DATEADD(DAY, -15, CURRENT_DATE()), 5, 6, 28, 40
UNION ALL SELECT 436, 5, DATEADD(DAY, -14, CURRENT_DATE()), 5, 4, 34, 40
UNION ALL SELECT 437, 5, DATEADD(DAY, -13, CURRENT_DATE()), 4, 4, 31, 40
UNION ALL SELECT 438, 5, DATEADD(DAY, -12, CURRENT_DATE()), 7, 6, 34, 40
UNION ALL SELECT 439, 5, DATEADD(DAY, -11, CURRENT_DATE()), 6, 5, 35, 40
UNION ALL SELECT 440, 5, DATEADD(DAY, -10, CURRENT_DATE()), 5, 5, 31, 40
UNION ALL SELECT 441, 5, DATEADD(DAY, -9, CURRENT_DATE()), 5, 8, 26, 40
UNION ALL SELECT 442, 5, DATEADD(DAY, -8, CURRENT_DATE()), 7, 8, 30, 40
UNION ALL SELECT 443, 5, DATEADD(DAY, -7, CURRENT_DATE()), 3, 4, 31, 40
UNION ALL SELECT 444, 5, DATEADD(DAY, -6, CURRENT_DATE()), 4, 4, 30, 40
UNION ALL SELECT 445, 5, DATEADD(DAY, -5, CURRENT_DATE()), 8, 6, 37, 40
UNION ALL SELECT 446, 5, DATEADD(DAY, -4, CURRENT_DATE()), 5, 6, 31, 40
UNION ALL SELECT 447, 5, DATEADD(DAY, -3, CURRENT_DATE()), 6, 4, 36, 40
UNION ALL SELECT 448, 5, DATEADD(DAY, -2, CURRENT_DATE()), 5, 5, 30, 40
UNION ALL SELECT 449, 5, DATEADD(DAY, -1, CURRENT_DATE()), 6, 6, 34, 40
UNION ALL SELECT 450, 5, DATEADD(DAY, -0, CURRENT_DATE()), 4, 4, 35, 40
UNION ALL SELECT 451, 6, DATEADD(DAY, -89, CURRENT_DATE()), 3, 2, 12, 15
UNION ALL SELECT 452, 6, DATEADD(DAY, -88, CURRENT_DATE()), 3, 3, 14, 15
UNION ALL SELECT 453, 6, DATEADD(DAY, -87, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 454, 6, DATEADD(DAY, -86, CURRENT_DATE()), 3, 2, 13, 15
UNION ALL SELECT 455, 6, DATEADD(DAY, -85, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 456, 6, DATEADD(DAY, -84, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 457, 6, DATEADD(DAY, -83, CURRENT_DATE()), 2, 2, 12, 15
UNION ALL SELECT 458, 6, DATEADD(DAY, -82, CURRENT_DATE()), 3, 3, 9, 15
UNION ALL SELECT 459, 6, DATEADD(DAY, -81, CURRENT_DATE()), 4, 3, 13, 15
UNION ALL SELECT 460, 6, DATEADD(DAY, -80, CURRENT_DATE()), 3, 2, 11, 15
UNION ALL SELECT 461, 6, DATEADD(DAY, -79, CURRENT_DATE()), 3, 3, 14, 15
UNION ALL SELECT 462, 6, DATEADD(DAY, -78, CURRENT_DATE()), 3, 3, 14, 15
UNION ALL SELECT 463, 6, DATEADD(DAY, -77, CURRENT_DATE()), 2, 1, 14, 15
UNION ALL SELECT 464, 6, DATEADD(DAY, -76, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 465, 6, DATEADD(DAY, -75, CURRENT_DATE()), 3, 3, 11, 15
UNION ALL SELECT 466, 6, DATEADD(DAY, -74, CURRENT_DATE()), 2, 3, 12, 15
UNION ALL SELECT 467, 6, DATEADD(DAY, -73, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 468, 6, DATEADD(DAY, -72, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 469, 6, DATEADD(DAY, -71, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 470, 6, DATEADD(DAY, -70, CURRENT_DATE()), 2, 2, 10, 15
UNION ALL SELECT 471, 6, DATEADD(DAY, -69, CURRENT_DATE()), 2, 2, 10, 15
UNION ALL SELECT 472, 6, DATEADD(DAY, -68, CURRENT_DATE()), 3, 2, 12, 15
UNION ALL SELECT 473, 6, DATEADD(DAY, -67, CURRENT_DATE()), 3, 3, 14, 15
UNION ALL SELECT 474, 6, DATEADD(DAY, -66, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 475, 6, DATEADD(DAY, -65, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 476, 6, DATEADD(DAY, -64, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 477, 6, DATEADD(DAY, -63, CURRENT_DATE()), 2, 2, 10, 15
UNION ALL SELECT 478, 6, DATEADD(DAY, -62, CURRENT_DATE()), 2, 1, 11, 15
UNION ALL SELECT 479, 6, DATEADD(DAY, -61, CURRENT_DATE()), 4, 3, 14, 15
UNION ALL SELECT 480, 6, DATEADD(DAY, -60, CURRENT_DATE()), 3, 3, 9, 15
UNION ALL SELECT 481, 6, DATEADD(DAY, -59, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 482, 6, DATEADD(DAY, -58, CURRENT_DATE()), 2, 3, 12, 15
UNION ALL SELECT 483, 6, DATEADD(DAY, -57, CURRENT_DATE()), 3, 2, 14, 15
UNION ALL SELECT 484, 6, DATEADD(DAY, -56, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 485, 6, DATEADD(DAY, -55, CURRENT_DATE()), 2, 2, 12, 15
UNION ALL SELECT 486, 6, DATEADD(DAY, -54, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 487, 6, DATEADD(DAY, -53, CURRENT_DATE()), 4, 2, 13, 15
UNION ALL SELECT 488, 6, DATEADD(DAY, -52, CURRENT_DATE()), 4, 4, 11, 15
UNION ALL SELECT 489, 6, DATEADD(DAY, -51, CURRENT_DATE()), 4, 3, 11, 15
UNION ALL SELECT 490, 6, DATEADD(DAY, -50, CURRENT_DATE()), 2, 3, 14, 15
UNION ALL SELECT 491, 6, DATEADD(DAY, -49, CURRENT_DATE()), 2, 2, 14, 15
UNION ALL SELECT 492, 6, DATEADD(DAY, -48, CURRENT_DATE()), 3, 2, 14, 15
UNION ALL SELECT 493, 6, DATEADD(DAY, -47, CURRENT_DATE()), 2, 3, 8, 15
UNION ALL SELECT 494, 6, DATEADD(DAY, -46, CURRENT_DATE()), 3, 2, 10, 15
UNION ALL SELECT 495, 6, DATEADD(DAY, -45, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 496, 6, DATEADD(DAY, -44, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 497, 6, DATEADD(DAY, -43, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 498, 6, DATEADD(DAY, -42, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 499, 6, DATEADD(DAY, -41, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 500, 6, DATEADD(DAY, -40, CURRENT_DATE()), 4, 4, 12, 15
UNION ALL SELECT 501, 6, DATEADD(DAY, -39, CURRENT_DATE()), 3, 3, 11, 15
UNION ALL SELECT 502, 6, DATEADD(DAY, -38, CURRENT_DATE()), 4, 2, 14, 15
UNION ALL SELECT 503, 6, DATEADD(DAY, -37, CURRENT_DATE()), 3, 3, 14, 15
UNION ALL SELECT 504, 6, DATEADD(DAY, -36, CURRENT_DATE()), 2, 4, 8, 15
UNION ALL SELECT 505, 6, DATEADD(DAY, -35, CURRENT_DATE()), 3, 2, 12, 15
UNION ALL SELECT 506, 6, DATEADD(DAY, -34, CURRENT_DATE()), 2, 2, 12, 15
UNION ALL SELECT 507, 6, DATEADD(DAY, -33, CURRENT_DATE()), 4, 3, 11, 15
UNION ALL SELECT 508, 6, DATEADD(DAY, -32, CURRENT_DATE()), 2, 4, 11, 15
UNION ALL SELECT 509, 6, DATEADD(DAY, -31, CURRENT_DATE()), 2, 3, 9, 15
UNION ALL SELECT 510, 6, DATEADD(DAY, -30, CURRENT_DATE()), 4, 4, 12, 15
UNION ALL SELECT 511, 6, DATEADD(DAY, -29, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 512, 6, DATEADD(DAY, -28, CURRENT_DATE()), 2, 2, 14, 15
UNION ALL SELECT 513, 6, DATEADD(DAY, -27, CURRENT_DATE()), 2, 2, 9, 15
UNION ALL SELECT 514, 6, DATEADD(DAY, -26, CURRENT_DATE()), 3, 4, 13, 15
UNION ALL SELECT 515, 6, DATEADD(DAY, -25, CURRENT_DATE()), 2, 4, 11, 15
UNION ALL SELECT 516, 6, DATEADD(DAY, -24, CURRENT_DATE()), 4, 3, 13, 15
UNION ALL SELECT 517, 6, DATEADD(DAY, -23, CURRENT_DATE()), 3, 4, 11, 15
UNION ALL SELECT 518, 6, DATEADD(DAY, -22, CURRENT_DATE()), 3, 4, 14, 15
UNION ALL SELECT 519, 6, DATEADD(DAY, -21, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 520, 6, DATEADD(DAY, -20, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 521, 6, DATEADD(DAY, -19, CURRENT_DATE()), 3, 4, 12, 15
UNION ALL SELECT 522, 6, DATEADD(DAY, -18, CURRENT_DATE()), 3, 3, 10, 15
UNION ALL SELECT 523, 6, DATEADD(DAY, -17, CURRENT_DATE()), 4, 3, 11, 15
UNION ALL SELECT 524, 6, DATEADD(DAY, -16, CURRENT_DATE()), 4, 3, 11, 15
UNION ALL SELECT 525, 6, DATEADD(DAY, -15, CURRENT_DATE()), 4, 4, 13, 15
UNION ALL SELECT 526, 6, DATEADD(DAY, -14, CURRENT_DATE()), 2, 2, 11, 15
UNION ALL SELECT 527, 6, DATEADD(DAY, -13, CURRENT_DATE()), 2, 2, 12, 15
UNION ALL SELECT 528, 6, DATEADD(DAY, -12, CURRENT_DATE()), 3, 3, 9, 15
UNION ALL SELECT 529, 6, DATEADD(DAY, -11, CURRENT_DATE()), 3, 4, 9, 15
UNION ALL SELECT 530, 6, DATEADD(DAY, -10, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 531, 6, DATEADD(DAY, -9, CURRENT_DATE()), 2, 4, 10, 15
UNION ALL SELECT 532, 6, DATEADD(DAY, -8, CURRENT_DATE()), 3, 2, 12, 15
UNION ALL SELECT 533, 6, DATEADD(DAY, -7, CURRENT_DATE()), 2, 2, 13, 15
UNION ALL SELECT 534, 6, DATEADD(DAY, -6, CURRENT_DATE()), 2, 3, 12, 15
UNION ALL SELECT 535, 6, DATEADD(DAY, -5, CURRENT_DATE()), 3, 3, 13, 15
UNION ALL SELECT 536, 6, DATEADD(DAY, -4, CURRENT_DATE()), 3, 3, 12, 15
UNION ALL SELECT 537, 6, DATEADD(DAY, -3, CURRENT_DATE()), 4, 3, 11, 15
UNION ALL SELECT 538, 6, DATEADD(DAY, -2, CURRENT_DATE()), 2, 2, 10, 15
UNION ALL SELECT 539, 6, DATEADD(DAY, -1, CURRENT_DATE()), 4, 3, 12, 15
UNION ALL SELECT 540, 6, DATEADD(DAY, -0, CURRENT_DATE()), 2, 2, 12, 15;

GRANT ALL ON ALL TABLES IN SCHEMA HEALTHCARE_HOL_DB.CLINICAL TO ROLE HEALTHCARE_HOL_ROLE;
GRANT ALL ON ALL TABLES IN SCHEMA HEALTHCARE_HOL_DB.OPERATIONS TO ROLE HEALTHCARE_HOL_ROLE;
GRANT ALL ON ALL STAGES IN SCHEMA HEALTHCARE_HOL_DB.CLINICAL TO ROLE HEALTHCARE_HOL_ROLE;
