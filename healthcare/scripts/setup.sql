USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS HEALTHCARE_HOL_WH
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
UNION ALL SELECT 1060, 30, 5, 5, 'Outpatient', DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -102, CURRENT_DATE()), 0, 'Psychiatric evaluation', 'Completed'
UNION ALL SELECT 2001, 2, 24, 2, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 1, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2002, 38, 14, 2, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 1, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2003, 36, 7, 1, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 2, 'Head injury', 'Completed'
UNION ALL SELECT 2004, 49, 6, 1, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 2, 'Seizure', 'Active'
UNION ALL SELECT 2005, 7, 12, 7, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 2, 'Croup', 'Active'
UNION ALL SELECT 2006, 35, 4, 8, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 2007, 37, 7, 6, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 4, 'Leukemia', 'Completed'
UNION ALL SELECT 2008, 15, 4, 2, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 4, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2009, 23, 7, 6, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 8, 'Leukemia', 'Completed'
UNION ALL SELECT 2010, 35, 24, 3, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 2, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2011, 44, 11, 4, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 1, 'ACL repair', 'Completed'
UNION ALL SELECT 2012, 18, 3, 7, 'Outpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -90, CURRENT_DATE()), 0, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2013, 14, 21, 6, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 8, 'Lymphoma', 'Completed'
UNION ALL SELECT 2014, 9, 8, 5, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 3, 'TIA', 'Completed'
UNION ALL SELECT 2015, 24, 8, 7, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 1, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2016, 41, 6, 3, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 2, 'Valve disease', 'Completed'
UNION ALL SELECT 2017, 34, 9, 8, 'Emergency', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 3, 'Pneumonia', 'Completed'
UNION ALL SELECT 2018, 8, 10, 6, 'Inpatient', DATEADD(DAY, -90, CURRENT_DATE()), NULL, 0, 'Lymphoma', 'Active'
UNION ALL SELECT 2019, 33, 4, 3, 'Outpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2020, 10, 12, 4, 'Inpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 10, 'ACL repair', 'Completed'
UNION ALL SELECT 2021, 39, 11, 1, 'Inpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 8, 'Burns', 'Completed'
UNION ALL SELECT 2022, 16, 2, 5, 'Outpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 0, 'Epilepsy', 'Completed'
UNION ALL SELECT 2023, 47, 16, 2, 'Outpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 0, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2024, 9, 22, 3, 'Outpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), 0, 'Pericarditis', 'Completed'
UNION ALL SELECT 2025, 14, 18, 7, 'Emergency', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 2, 'Croup', 'Completed'
UNION ALL SELECT 2026, 29, 17, 6, 'Inpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 1, 'Lymphoma', 'Completed'
UNION ALL SELECT 2027, 38, 8, 4, 'Inpatient', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 4, 'Hip fracture', 'Completed'
UNION ALL SELECT 2028, 22, 3, 1, 'Emergency', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 1, 'Head injury', 'Completed'
UNION ALL SELECT 2029, 16, 16, 8, 'Inpatient', DATEADD(DAY, -89, CURRENT_DATE()), NULL, 0, 'Anemia', 'Active'
UNION ALL SELECT 2030, 23, 14, 7, 'Emergency', DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 3, 'Dehydration', 'Completed'
UNION ALL SELECT 2031, 4, 13, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 7, 'Severe trauma', 'Completed'
UNION ALL SELECT 2032, 35, 15, 4, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 2, 'Knee replacement', 'Completed'
UNION ALL SELECT 2033, 29, 18, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 14, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2034, 49, 8, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2035, 11, 13, 1, 'Outpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 0, 'Chest pain', 'Completed'
UNION ALL SELECT 2036, 19, 14, 8, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 2, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2037, 48, 11, 1, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 3, 'Chest pain', 'Completed'
UNION ALL SELECT 2038, 4, 17, 3, 'Outpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 0, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2039, 44, 8, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 7, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2040, 40, 3, 1, 'Emergency', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 2041, 43, 23, 4, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 2, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2042, 30, 11, 5, 'Outpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 0, 'Neuropathy', 'Completed'
UNION ALL SELECT 2043, 5, 18, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 1, 'Septic shock', 'Completed'
UNION ALL SELECT 2044, 16, 12, 2, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 6, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2045, 43, 18, 1, 'Outpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 0, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2046, 17, 4, 3, 'Emergency', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2047, 14, 22, 6, 'Outpatient', DATEADD(DAY, -88, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2048, 4, 3, 5, 'Inpatient', DATEADD(DAY, -88, CURRENT_DATE()), NULL, 2, 'TIA', 'Active'
UNION ALL SELECT 2049, 11, 24, 5, 'Emergency', DATEADD(DAY, -87, CURRENT_DATE()), NULL, 1, 'Migraine', 'Active'
UNION ALL SELECT 2050, 35, 2, 3, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), NULL, 1, 'Angina', 'Active'
UNION ALL SELECT 2051, 24, 2, 5, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), NULL, 1, 'Multiple sclerosis', 'Active'
UNION ALL SELECT 2052, 40, 24, 7, 'Outpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -87, CURRENT_DATE()), 0, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2053, 12, 14, 3, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 8, 'Heart failure', 'Completed'
UNION ALL SELECT 2054, 43, 24, 7, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 1, 'Croup', 'Completed'
UNION ALL SELECT 2055, 3, 16, 7, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 8, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2056, 15, 1, 4, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2057, 23, 21, 5, 'Inpatient', DATEADD(DAY, -87, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 14, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2058, 8, 9, 1, 'Emergency', DATEADD(DAY, -87, CURRENT_DATE()), NULL, 1, 'Laceration', 'Active'
UNION ALL SELECT 2059, 47, 11, 6, 'Inpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Lymphoma', 'Completed'
UNION ALL SELECT 2060, 17, 2, 4, 'Inpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2061, 24, 14, 4, 'Outpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 2062, 43, 4, 6, 'Outpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2063, 21, 13, 7, 'Inpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2064, 44, 24, 7, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2065, 19, 7, 5, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 2, 'Migraine', 'Completed'
UNION ALL SELECT 2066, 44, 7, 8, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2067, 19, 17, 2, 'Inpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 2, 'Severe trauma', 'Completed'
UNION ALL SELECT 2068, 44, 10, 4, 'Outpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -86, CURRENT_DATE()), 0, 'Knee replacement', 'Completed'
UNION ALL SELECT 2069, 16, 16, 1, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 2, 'Overdose', 'Completed'
UNION ALL SELECT 2070, 46, 23, 4, 'Inpatient', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 1, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2071, 49, 25, 1, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2072, 36, 8, 1, 'Emergency', DATEADD(DAY, -86, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2073, 49, 15, 6, 'Outpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 0, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2074, 36, 15, 7, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2075, 50, 25, 5, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 1, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2076, 16, 9, 5, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), NULL, 3, 'Multiple sclerosis', 'Active'
UNION ALL SELECT 2077, 25, 23, 4, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 2, 'Knee replacement', 'Completed'
UNION ALL SELECT 2078, 27, 2, 8, 'Outpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 0, 'COPD', 'Completed'
UNION ALL SELECT 2079, 49, 19, 1, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 2080, 35, 24, 7, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2081, 28, 16, 5, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 4, 'Stroke', 'Completed'
UNION ALL SELECT 2082, 30, 5, 3, 'Outpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -85, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2083, 6, 21, 1, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), NULL, 3, 'Seizure', 'Active'
UNION ALL SELECT 2084, 21, 7, 7, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 5, 'Dehydration', 'Completed'
UNION ALL SELECT 2085, 17, 3, 7, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 3, 'Dehydration', 'Completed'
UNION ALL SELECT 2086, 15, 21, 6, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 2087, 2, 20, 4, 'Inpatient', DATEADD(DAY, -85, CURRENT_DATE()), NULL, 3, 'Knee replacement', 'Active'
UNION ALL SELECT 2088, 30, 23, 4, 'Emergency', DATEADD(DAY, -85, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 3, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2089, 20, 4, 3, 'Outpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2090, 26, 23, 7, 'Inpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 4, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2091, 45, 25, 2, 'Emergency', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2092, 23, 18, 1, 'Emergency', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 3, 'Seizure', 'Completed'
UNION ALL SELECT 2093, 32, 4, 7, 'Outpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -84, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 2094, 46, 5, 8, 'Inpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 3, 'Anemia', 'Completed'
UNION ALL SELECT 2095, 30, 14, 8, 'Inpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 1, 'Cellulitis', 'Completed'
UNION ALL SELECT 2096, 29, 8, 5, 'Inpatient', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 4, 'Neuropathy', 'Completed'
UNION ALL SELECT 2097, 32, 11, 1, 'Emergency', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 2098, 36, 1, 5, 'Outpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2099, 32, 18, 7, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 3, 'Croup', 'Completed'
UNION ALL SELECT 2100, 2, 3, 8, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 4, 'Cellulitis', 'Completed'
UNION ALL SELECT 2101, 31, 18, 6, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 14, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2102, 45, 15, 6, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2103, 8, 24, 6, 'Outpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 0, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2104, 14, 24, 4, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 3, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2105, 7, 7, 5, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), NULL, 1, 'Multiple sclerosis', 'Active'
UNION ALL SELECT 2106, 18, 2, 3, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), NULL, 4, 'Heart failure', 'Active'
UNION ALL SELECT 2107, 7, 1, 8, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 2, 'Cellulitis', 'Completed'
UNION ALL SELECT 2108, 17, 16, 1, 'Emergency', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2109, 10, 5, 1, 'Outpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 0, 'Overdose', 'Completed'
UNION ALL SELECT 2110, 8, 18, 4, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2111, 29, 15, 7, 'Outpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -83, CURRENT_DATE()), 0, 'Appendicitis', 'Completed'
UNION ALL SELECT 2112, 37, 20, 5, 'Emergency', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 1, 'Stroke', 'Completed'
UNION ALL SELECT 2113, 43, 3, 5, 'Inpatient', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 3, 'Epilepsy', 'Completed'
UNION ALL SELECT 2114, 29, 23, 7, 'Emergency', DATEADD(DAY, -83, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 2, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2115, 44, 8, 2, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 4, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2116, 28, 4, 4, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 1, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2117, 5, 2, 3, 'Emergency', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2118, 8, 15, 8, 'Emergency', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 3, 'Cellulitis', 'Completed'
UNION ALL SELECT 2119, 6, 20, 8, 'Outpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2120, 2, 3, 5, 'Outpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 0, 'Epilepsy', 'Completed'
UNION ALL SELECT 2121, 49, 22, 1, 'Emergency', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 1, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2122, 18, 6, 8, 'Emergency', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 1, 'Anemia', 'Completed'
UNION ALL SELECT 2123, 22, 11, 7, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2124, 19, 22, 8, 'Outpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -82, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 2125, 6, 11, 8, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 14, 'Cellulitis', 'Completed'
UNION ALL SELECT 2126, 43, 18, 1, 'Emergency', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 2, 'Burns', 'Completed'
UNION ALL SELECT 2127, 41, 15, 8, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 3, 'Pneumonia', 'Completed'
UNION ALL SELECT 2128, 45, 16, 8, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 4, 'UTI', 'Completed'
UNION ALL SELECT 2129, 20, 18, 3, 'Inpatient', DATEADD(DAY, -82, CURRENT_DATE()), NULL, 0, 'Heart failure', 'Active'
UNION ALL SELECT 2130, 8, 21, 8, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 5, 'Diabetes management', 'Completed'
UNION ALL SELECT 2131, 27, 16, 5, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 3, 'Migraine', 'Completed'
UNION ALL SELECT 2132, 5, 9, 3, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 5, 'Valve disease', 'Completed'
UNION ALL SELECT 2133, 19, 24, 1, 'Emergency', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2134, 29, 18, 3, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 3, 'Pericarditis', 'Completed'
UNION ALL SELECT 2135, 21, 7, 8, 'Emergency', DATEADD(DAY, -81, CURRENT_DATE()), NULL, 2, 'COPD', 'Active'
UNION ALL SELECT 2136, 46, 13, 8, 'Outpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -81, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 2137, 32, 2, 3, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2138, 7, 17, 8, 'Inpatient', DATEADD(DAY, -81, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 1, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2139, 31, 9, 2, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), NULL, 2, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2140, 44, 18, 6, 'Outpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 0, 'Lymphoma', 'Completed'
UNION ALL SELECT 2141, 35, 2, 8, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 4, 'UTI', 'Completed'
UNION ALL SELECT 2142, 48, 3, 4, 'Outpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 0, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2143, 29, 6, 2, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), NULL, 0, 'Severe trauma', 'Active'
UNION ALL SELECT 2144, 4, 10, 6, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2145, 11, 6, 3, 'Emergency', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -77, CURRENT_DATE()), 3, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2146, 15, 15, 3, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 4, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2147, 19, 22, 8, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 10, 'Diabetes management', 'Completed'
UNION ALL SELECT 2148, 41, 14, 5, 'Inpatient', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 6, 'TIA', 'Completed'
UNION ALL SELECT 2149, 7, 8, 8, 'Emergency', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 3, 'Anemia', 'Completed'
UNION ALL SELECT 2150, 18, 1, 7, 'Outpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 0, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2151, 39, 24, 1, 'Emergency', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 1, 'Burns', 'Completed'
UNION ALL SELECT 2152, 15, 21, 6, 'Inpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 4, 'Lung cancer', 'Completed'
UNION ALL SELECT 2153, 41, 4, 3, 'Inpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -77, CURRENT_DATE()), 2, 'Heart failure', 'Completed'
UNION ALL SELECT 2154, 6, 10, 3, 'Emergency', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 1, 'Angina', 'Completed'
UNION ALL SELECT 2155, 34, 17, 6, 'Outpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2156, 19, 24, 8, 'Outpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2157, 10, 25, 2, 'Emergency', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -77, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2158, 6, 13, 6, 'Inpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 2159, 38, 13, 5, 'Emergency', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 3, 'Neuropathy', 'Completed'
UNION ALL SELECT 2160, 40, 18, 1, 'Outpatient', DATEADD(DAY, -79, CURRENT_DATE()), DATEADD(DAY, -79, CURRENT_DATE()), 0, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2161, 41, 15, 2, 'Inpatient', DATEADD(DAY, -79, CURRENT_DATE()), NULL, 2, 'Severe trauma', 'Active'
UNION ALL SELECT 2162, 20, 16, 1, 'Inpatient', DATEADD(DAY, -79, CURRENT_DATE()), NULL, 7, 'Fracture', 'Active'
UNION ALL SELECT 2163, 43, 24, 6, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2164, 27, 21, 3, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2165, 3, 23, 5, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 2, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2166, 7, 22, 6, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 14, 'Colon cancer', 'Completed'
UNION ALL SELECT 2167, 18, 7, 7, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2168, 43, 7, 2, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), NULL, 14, 'Severe trauma', 'Active'
UNION ALL SELECT 2169, 16, 5, 6, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), NULL, 0, 'Pancreatic cancer', 'Active'
UNION ALL SELECT 2170, 38, 7, 4, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'ACL repair', 'Completed'
UNION ALL SELECT 2171, 39, 1, 3, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2172, 35, 9, 3, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), NULL, 7, 'Chest pain evaluation', 'Active'
UNION ALL SELECT 2173, 16, 19, 6, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), NULL, 2, 'Colon cancer', 'Active'
UNION ALL SELECT 2174, 34, 4, 7, 'Inpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 2, 'Fracture', 'Completed'
UNION ALL SELECT 2175, 29, 17, 2, 'Emergency', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2176, 42, 1, 8, 'Outpatient', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -78, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2177, 44, 4, 7, 'Emergency', DATEADD(DAY, -78, CURRENT_DATE()), DATEADD(DAY, -77, CURRENT_DATE()), 1, 'Dehydration', 'Completed'
UNION ALL SELECT 2178, 9, 9, 2, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2179, 30, 17, 5, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), NULL, 5, 'Parkinson disease', 'Active'
UNION ALL SELECT 2180, 28, 15, 4, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 6, 'Knee replacement', 'Completed'
UNION ALL SELECT 2181, 21, 14, 2, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 2, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2182, 5, 3, 8, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), NULL, 0, 'UTI', 'Active'
UNION ALL SELECT 2183, 9, 18, 6, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 3, 'Breast cancer', 'Completed'
UNION ALL SELECT 2184, 27, 12, 2, 'Emergency', DATEADD(DAY, -77, CURRENT_DATE()), NULL, 3, 'Severe trauma', 'Active'
UNION ALL SELECT 2185, 39, 10, 5, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 3, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2186, 15, 4, 8, 'Outpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -77, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2187, 37, 8, 5, 'Inpatient', DATEADD(DAY, -77, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 3, 'Neuropathy', 'Completed'
UNION ALL SELECT 2188, 39, 22, 1, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2189, 23, 1, 6, 'Outpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 0, 'Lung cancer', 'Completed'
UNION ALL SELECT 2190, 5, 5, 7, 'Emergency', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2191, 27, 15, 7, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 2192, 4, 5, 2, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), NULL, 0, 'Septic shock', 'Active'
UNION ALL SELECT 2193, 18, 15, 2, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 4, 'Severe trauma', 'Completed'
UNION ALL SELECT 2194, 49, 17, 4, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 1, 'Hip fracture', 'Completed'
UNION ALL SELECT 2195, 34, 22, 8, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Cellulitis', 'Completed'
UNION ALL SELECT 2196, 14, 10, 1, 'Emergency', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2197, 32, 24, 1, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 2198, 5, 13, 6, 'Emergency', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2199, 37, 14, 6, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 4, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2200, 2, 11, 7, 'Outpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), 0, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2201, 6, 14, 6, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2202, 26, 10, 2, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 2, 'Severe trauma', 'Completed'
UNION ALL SELECT 2203, 34, 17, 2, 'Emergency', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2204, 16, 4, 3, 'Inpatient', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 1, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2205, 12, 25, 2, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 5, 'Severe trauma', 'Completed'
UNION ALL SELECT 2206, 44, 19, 8, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2207, 29, 3, 3, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 2, 'Pericarditis', 'Completed'
UNION ALL SELECT 2208, 23, 17, 1, 'Emergency', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2209, 5, 21, 5, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Neuropathy', 'Completed'
UNION ALL SELECT 2210, 30, 19, 7, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2211, 29, 19, 1, 'Emergency', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 1, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2212, 7, 11, 8, 'Emergency', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 1, 'UTI', 'Completed'
UNION ALL SELECT 2213, 34, 17, 8, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 8, 'Diabetes management', 'Completed'
UNION ALL SELECT 2214, 44, 20, 6, 'Emergency', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 2215, 19, 9, 7, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Fracture', 'Completed'
UNION ALL SELECT 2216, 22, 3, 3, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2217, 9, 20, 7, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Fracture', 'Completed'
UNION ALL SELECT 2218, 42, 11, 7, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 5, 'Croup', 'Completed'
UNION ALL SELECT 2219, 42, 22, 2, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), NULL, 0, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 2220, 12, 7, 5, 'Outpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 0, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2221, 9, 5, 4, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 5, 'Hip fracture', 'Completed'
UNION ALL SELECT 2222, 43, 11, 1, 'Inpatient', DATEADD(DAY, -75, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 2, 'Overdose', 'Completed'
UNION ALL SELECT 2223, 47, 15, 3, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 4, 'Heart failure', 'Completed'
UNION ALL SELECT 2224, 40, 10, 8, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 1, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2225, 13, 12, 8, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 2, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2226, 11, 7, 7, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 1, 'Croup', 'Completed'
UNION ALL SELECT 2227, 36, 4, 6, 'Outpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2228, 6, 25, 5, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), NULL, 8, 'Epilepsy', 'Active'
UNION ALL SELECT 2229, 6, 8, 7, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 1, 'Croup', 'Completed'
UNION ALL SELECT 2230, 33, 12, 7, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), NULL, 0, 'Bronchiolitis', 'Active'
UNION ALL SELECT 2231, 2, 11, 4, 'Outpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 2232, 9, 2, 3, 'Outpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2233, 49, 23, 3, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), NULL, 0, 'Pericarditis', 'Active'
UNION ALL SELECT 2234, 2, 9, 2, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2235, 8, 25, 7, 'Inpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 1, 'Appendicitis', 'Completed'
UNION ALL SELECT 2236, 5, 4, 8, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 3, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2237, 19, 14, 3, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 2, 'Heart failure', 'Completed'
UNION ALL SELECT 2238, 34, 12, 2, 'Outpatient', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -74, CURRENT_DATE()), 0, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2239, 25, 16, 1, 'Emergency', DATEADD(DAY, -74, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 2, 'Chest pain', 'Completed'
UNION ALL SELECT 2240, 23, 8, 2, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 1, 'Severe trauma', 'Completed'
UNION ALL SELECT 2241, 9, 2, 6, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 6, 'Colon cancer', 'Completed'
UNION ALL SELECT 2242, 45, 16, 8, 'Outpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 0, 'Diabetes management', 'Completed'
UNION ALL SELECT 2243, 3, 10, 8, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), NULL, 1, 'COPD', 'Active'
UNION ALL SELECT 2244, 33, 13, 5, 'Emergency', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 3, 'Neuropathy', 'Completed'
UNION ALL SELECT 2245, 50, 2, 6, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 2, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2246, 26, 24, 7, 'Outpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -73, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 2247, 32, 23, 3, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 5, 'Pericarditis', 'Completed'
UNION ALL SELECT 2248, 47, 14, 2, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 14, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2249, 21, 4, 5, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 2, 'Stroke', 'Completed'
UNION ALL SELECT 2250, 11, 23, 7, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), NULL, 0, 'Dehydration', 'Active'
UNION ALL SELECT 2251, 40, 14, 6, 'Inpatient', DATEADD(DAY, -73, CURRENT_DATE()), NULL, 5, 'Colon cancer', 'Active'
UNION ALL SELECT 2252, 24, 17, 7, 'Emergency', DATEADD(DAY, -73, CURRENT_DATE()), NULL, 1, 'Croup', 'Active'
UNION ALL SELECT 2253, 3, 5, 8, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 4, 'UTI', 'Completed'
UNION ALL SELECT 2254, 39, 5, 1, 'Outpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 0, 'Burns', 'Completed'
UNION ALL SELECT 2255, 37, 5, 2, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2256, 2, 24, 2, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2257, 50, 9, 5, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 14, 'TIA', 'Completed'
UNION ALL SELECT 2258, 13, 4, 8, 'Outpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 0, 'Diabetes management', 'Completed'
UNION ALL SELECT 2259, 6, 22, 8, 'Emergency', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 3, 'DVT', 'Completed'
UNION ALL SELECT 2260, 11, 23, 5, 'Outpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 0, 'TIA', 'Completed'
UNION ALL SELECT 2261, 33, 8, 6, 'Outpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 0, 'Breast cancer', 'Completed'
UNION ALL SELECT 2262, 32, 1, 4, 'Emergency', DATEADD(DAY, -72, CURRENT_DATE()), NULL, 3, 'Spinal stenosis', 'Active'
UNION ALL SELECT 2263, 5, 10, 2, 'Outpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -72, CURRENT_DATE()), 0, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2264, 50, 14, 7, 'Emergency', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 2, 'Croup', 'Completed'
UNION ALL SELECT 2265, 30, 22, 8, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 6, 'DVT', 'Completed'
UNION ALL SELECT 2266, 50, 5, 3, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 7, 'Valve disease', 'Completed'
UNION ALL SELECT 2267, 20, 6, 3, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 5, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2268, 6, 9, 5, 'Emergency', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 1, 'Epilepsy', 'Completed'
UNION ALL SELECT 2269, 33, 21, 2, 'Inpatient', DATEADD(DAY, -72, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2270, 37, 2, 6, 'Outpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 0, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2271, 42, 7, 5, 'Emergency', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 2272, 42, 10, 5, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 6, 'Migraine', 'Completed'
UNION ALL SELECT 2273, 5, 23, 8, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 2, 'Pneumonia', 'Completed'
UNION ALL SELECT 2274, 39, 5, 6, 'Outpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2275, 26, 5, 6, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2276, 8, 9, 8, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), NULL, 0, 'Hypertension crisis', 'Active'
UNION ALL SELECT 2277, 25, 20, 5, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 7, 'Migraine', 'Completed'
UNION ALL SELECT 2278, 37, 24, 6, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2279, 32, 10, 8, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 10, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2280, 14, 19, 4, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 2, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2281, 19, 18, 8, 'Outpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -71, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2282, 47, 12, 5, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), NULL, 0, 'Neuropathy', 'Active'
UNION ALL SELECT 2283, 37, 18, 1, 'Emergency', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 2, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2284, 40, 22, 5, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 14, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2285, 36, 12, 6, 'Inpatient', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 4, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2286, 3, 2, 1, 'Emergency', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 3, 'Laceration', 'Completed'
UNION ALL SELECT 2287, 21, 20, 3, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 14, 'Angina', 'Completed'
UNION ALL SELECT 2288, 38, 11, 5, 'Outpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2289, 31, 1, 5, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2290, 47, 23, 5, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 3, 'TIA', 'Completed'
UNION ALL SELECT 2291, 47, 2, 4, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2292, 10, 22, 7, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), NULL, 10, 'Bronchiolitis', 'Active'
UNION ALL SELECT 2293, 29, 11, 1, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 4, 'Seizure', 'Completed'
UNION ALL SELECT 2294, 48, 24, 8, 'Emergency', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 3, 'Pneumonia', 'Completed'
UNION ALL SELECT 2295, 34, 13, 8, 'Outpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2296, 35, 12, 6, 'Emergency', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 3, 'Leukemia', 'Completed'
UNION ALL SELECT 2297, 40, 16, 5, 'Outpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 0, 'Epilepsy', 'Completed'
UNION ALL SELECT 2298, 15, 10, 5, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 2299, 31, 12, 6, 'Outpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 0, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2300, 19, 4, 5, 'Emergency', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 2, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2301, 19, 2, 3, 'Outpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -70, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2302, 42, 9, 8, 'Inpatient', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 6, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2303, 9, 4, 5, 'Emergency', DATEADD(DAY, -70, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 1, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2304, 41, 8, 4, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 2, 'Hip fracture', 'Completed'
UNION ALL SELECT 2305, 1, 18, 3, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 8, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2306, 42, 7, 8, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 4, 'Cellulitis', 'Completed'
UNION ALL SELECT 2307, 42, 19, 2, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 5, 'Septic shock', 'Completed'
UNION ALL SELECT 2308, 27, 6, 3, 'Outpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2309, 12, 24, 8, 'Outpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 0, 'Cellulitis', 'Completed'
UNION ALL SELECT 2310, 22, 10, 2, 'Outpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 0, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2311, 9, 17, 8, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 6, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2312, 42, 9, 8, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 2313, 12, 20, 4, 'Emergency', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 2, 'ACL repair', 'Completed'
UNION ALL SELECT 2314, 26, 22, 2, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 1, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2315, 1, 9, 4, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 5, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2316, 38, 24, 5, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 4, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2317, 43, 4, 1, 'Emergency', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 3, 'Burns', 'Completed'
UNION ALL SELECT 2318, 45, 4, 5, 'Outpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -69, CURRENT_DATE()), 0, 'TIA', 'Completed'
UNION ALL SELECT 2319, 15, 5, 4, 'Inpatient', DATEADD(DAY, -69, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 5, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2320, 49, 18, 8, 'Emergency', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 3, 'COPD', 'Completed'
UNION ALL SELECT 2321, 34, 15, 2, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), NULL, 0, 'Cardiac arrest recovery', 'Active'
UNION ALL SELECT 2322, 4, 18, 2, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2323, 8, 22, 8, 'Emergency', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 3, 'COPD', 'Completed'
UNION ALL SELECT 2324, 30, 5, 1, 'Emergency', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 3, 'Head injury', 'Completed'
UNION ALL SELECT 2325, 47, 1, 5, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), NULL, 0, 'Migraine', 'Active'
UNION ALL SELECT 2326, 38, 3, 4, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 5, 'Hip fracture', 'Completed'
UNION ALL SELECT 2327, 5, 16, 1, 'Emergency', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 1, 'Chest pain', 'Completed'
UNION ALL SELECT 2328, 24, 13, 7, 'Outpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 2329, 6, 22, 7, 'Outpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -68, CURRENT_DATE()), 0, 'Fracture', 'Completed'
UNION ALL SELECT 2330, 8, 6, 6, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 1, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2331, 49, 1, 1, 'Emergency', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2332, 16, 15, 4, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 1, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2333, 3, 22, 2, 'Inpatient', DATEADD(DAY, -68, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 8, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2334, 5, 4, 4, 'Inpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2335, 16, 24, 1, 'Emergency', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 1, 'Chest pain', 'Completed'
UNION ALL SELECT 2336, 9, 17, 1, 'Emergency', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2337, 16, 10, 6, 'Outpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 0, 'Lung cancer', 'Completed'
UNION ALL SELECT 2338, 20, 9, 7, 'Emergency', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2339, 36, 16, 7, 'Outpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 0, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2340, 34, 11, 7, 'Emergency', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 2, 'Fracture', 'Completed'
UNION ALL SELECT 2341, 16, 8, 8, 'Outpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 0, 'Cellulitis', 'Completed'
UNION ALL SELECT 2342, 4, 18, 8, 'Outpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 2343, 25, 8, 3, 'Inpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 4, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2344, 6, 18, 6, 'Outpatient', DATEADD(DAY, -67, CURRENT_DATE()), DATEADD(DAY, -67, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2345, 5, 7, 1, 'Emergency', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 2, 'Overdose', 'Completed'
UNION ALL SELECT 2346, 20, 1, 6, 'Outpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 0, 'Lung cancer', 'Completed'
UNION ALL SELECT 2347, 48, 25, 2, 'Emergency', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 3, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2348, 36, 11, 4, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2349, 17, 12, 5, 'Outpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2350, 49, 11, 8, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 2, 'COPD', 'Completed'
UNION ALL SELECT 2351, 48, 5, 4, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 8, 'Hip fracture', 'Completed'
UNION ALL SELECT 2352, 19, 5, 7, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2353, 36, 21, 8, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 6, 'DVT', 'Completed'
UNION ALL SELECT 2354, 30, 6, 8, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 5, 'DVT', 'Completed'
UNION ALL SELECT 2355, 34, 2, 1, 'Outpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 0, 'Fracture', 'Completed'
UNION ALL SELECT 2356, 27, 5, 1, 'Inpatient', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 1, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2357, 24, 2, 8, 'Emergency', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 3, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2358, 2, 17, 1, 'Emergency', DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2359, 12, 4, 7, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2360, 18, 13, 6, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 2, 'Breast cancer', 'Completed'
UNION ALL SELECT 2361, 20, 22, 4, 'Outpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 0, 'ACL repair', 'Completed'
UNION ALL SELECT 2362, 6, 13, 1, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), NULL, 3, 'Seizure', 'Active'
UNION ALL SELECT 2363, 6, 16, 3, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 1, 'Valve disease', 'Completed'
UNION ALL SELECT 2364, 15, 7, 1, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 1, 'Overdose', 'Completed'
UNION ALL SELECT 2365, 35, 19, 5, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 8, 'TIA', 'Completed'
UNION ALL SELECT 2366, 38, 5, 4, 'Outpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -65, CURRENT_DATE()), 0, 'ACL repair', 'Completed'
UNION ALL SELECT 2367, 20, 6, 2, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 6, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2368, 25, 25, 6, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 14, 'Leukemia', 'Completed'
UNION ALL SELECT 2369, 4, 4, 6, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), NULL, 0, 'Lymphoma', 'Active'
UNION ALL SELECT 2370, 50, 11, 7, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 2, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2371, 36, 13, 6, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 3, 'Lymphoma', 'Completed'
UNION ALL SELECT 2372, 16, 23, 5, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 1, 'Stroke', 'Completed'
UNION ALL SELECT 2373, 48, 13, 3, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), NULL, 0, 'Angina', 'Active'
UNION ALL SELECT 2374, 29, 12, 5, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 2375, 36, 18, 8, 'Inpatient', DATEADD(DAY, -65, CURRENT_DATE()), NULL, 0, 'Anemia', 'Active'
UNION ALL SELECT 2376, 39, 20, 2, 'Emergency', DATEADD(DAY, -65, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 2, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2377, 37, 17, 4, 'Emergency', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 2, 'Knee replacement', 'Completed'
UNION ALL SELECT 2378, 10, 3, 8, 'Inpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 2379, 24, 9, 2, 'Inpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2380, 7, 5, 8, 'Inpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 2, 'Cellulitis', 'Completed'
UNION ALL SELECT 2381, 22, 15, 7, 'Emergency', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 3, 'Appendicitis', 'Completed'
UNION ALL SELECT 2382, 20, 11, 3, 'Inpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 1, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2383, 19, 24, 6, 'Inpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 10, 'Leukemia', 'Completed'
UNION ALL SELECT 2384, 25, 9, 6, 'Emergency', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2385, 44, 25, 3, 'Outpatient', DATEADD(DAY, -64, CURRENT_DATE()), DATEADD(DAY, -64, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2386, 19, 23, 8, 'Outpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 0, 'UTI', 'Completed'
UNION ALL SELECT 2387, 44, 16, 7, 'Emergency', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 3, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2388, 25, 3, 7, 'Outpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 2389, 35, 17, 7, 'Emergency', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 2, 'Croup', 'Completed'
UNION ALL SELECT 2390, 7, 25, 2, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2391, 37, 21, 1, 'Outpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), 0, 'Seizure', 'Completed'
UNION ALL SELECT 2392, 7, 1, 7, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2393, 29, 12, 4, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 4, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2394, 23, 1, 3, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 2, 'Pericarditis', 'Completed'
UNION ALL SELECT 2395, 47, 5, 2, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 3, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2396, 23, 16, 8, 'Inpatient', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 4, 'UTI', 'Completed'
UNION ALL SELECT 2397, 46, 4, 1, 'Emergency', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 3, 'Chest pain', 'Completed'
UNION ALL SELECT 2398, 34, 6, 4, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2399, 26, 21, 4, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 4, 'Knee replacement', 'Completed'
UNION ALL SELECT 2400, 29, 19, 4, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 5, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2401, 37, 4, 2, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2402, 43, 16, 5, 'Outpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2403, 40, 13, 7, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 2, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2404, 44, 23, 3, 'Outpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -62, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2405, 21, 4, 3, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 1, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2406, 27, 20, 7, 'Emergency', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2407, 36, 6, 3, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 1, 'Pericarditis', 'Completed'
UNION ALL SELECT 2408, 23, 1, 1, 'Inpatient', DATEADD(DAY, -62, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 6, 'Burns', 'Completed'
UNION ALL SELECT 2409, 27, 22, 8, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 6, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2410, 37, 1, 2, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2411, 50, 15, 3, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), NULL, 1, 'Pericarditis', 'Active'
UNION ALL SELECT 2412, 35, 25, 6, 'Emergency', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 2413, 48, 21, 2, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 14, 'Septic shock', 'Completed'
UNION ALL SELECT 2414, 6, 15, 6, 'Outpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 0, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2415, 14, 24, 4, 'Emergency', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2416, 40, 5, 3, 'Outpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 0, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2417, 35, 9, 6, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 2, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2418, 37, 9, 5, 'Emergency', DATEADD(DAY, -61, CURRENT_DATE()), NULL, 1, 'Neuropathy', 'Active'
UNION ALL SELECT 2419, 4, 9, 7, 'Emergency', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 1, 'Croup', 'Completed'
UNION ALL SELECT 2420, 16, 25, 6, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2421, 41, 14, 5, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 4, 'Migraine', 'Completed'
UNION ALL SELECT 2422, 26, 17, 2, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 8, 'Severe trauma', 'Completed'
UNION ALL SELECT 2423, 21, 19, 8, 'Outpatient', DATEADD(DAY, -61, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2424, 47, 15, 2, 'Inpatient', DATEADD(DAY, -61, CURRENT_DATE()), NULL, 2, 'Severe trauma', 'Active'
UNION ALL SELECT 2425, 14, 14, 7, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Croup', 'Completed'
UNION ALL SELECT 2426, 36, 19, 6, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 3, 'Lung cancer', 'Completed'
UNION ALL SELECT 2427, 3, 4, 1, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 8, 'Burns', 'Completed'
UNION ALL SELECT 2428, 1, 14, 8, 'Outpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 0, 'COPD', 'Completed'
UNION ALL SELECT 2429, 11, 9, 5, 'Emergency', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Stroke', 'Completed'
UNION ALL SELECT 2430, 4, 13, 3, 'Emergency', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2431, 1, 7, 2, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 3, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2432, 1, 1, 8, 'Outpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2433, 45, 5, 7, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Dehydration', 'Completed'
UNION ALL SELECT 2434, 7, 11, 2, 'Emergency', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2435, 5, 17, 3, 'Emergency', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Heart failure', 'Completed'
UNION ALL SELECT 2436, 27, 20, 3, 'Outpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 0, 'Pericarditis', 'Completed'
UNION ALL SELECT 2437, 9, 25, 2, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2438, 9, 8, 6, 'Inpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2439, 50, 23, 5, 'Outpatient', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -60, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2440, 14, 17, 5, 'Emergency', DATEADD(DAY, -60, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 2, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2441, 25, 4, 8, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 3, 'COPD', 'Completed'
UNION ALL SELECT 2442, 24, 11, 1, 'Emergency', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 2443, 49, 16, 3, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), NULL, 0, 'Atrial fibrillation', 'Active'
UNION ALL SELECT 2444, 14, 2, 5, 'Outpatient', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -59, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2445, 41, 23, 5, 'Emergency', DATEADD(DAY, -59, CURRENT_DATE()), NULL, 2, 'Parkinson disease', 'Active'
UNION ALL SELECT 2446, 18, 3, 3, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 8, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2447, 35, 11, 3, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 5, 'Valve disease', 'Completed'
UNION ALL SELECT 2448, 20, 23, 2, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), NULL, 6, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 2449, 28, 4, 2, 'Inpatient', DATEADD(DAY, -59, CURRENT_DATE()), NULL, 0, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 2450, 8, 1, 3, 'Emergency', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 2, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2451, 11, 12, 5, 'Emergency', DATEADD(DAY, -59, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 3, 'Epilepsy', 'Completed'
UNION ALL SELECT 2452, 28, 9, 6, 'Inpatient', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 5, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2453, 32, 15, 2, 'Inpatient', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2454, 11, 9, 6, 'Inpatient', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2455, 48, 17, 4, 'Inpatient', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 7, 'Hip fracture', 'Completed'
UNION ALL SELECT 2456, 24, 13, 8, 'Inpatient', DATEADD(DAY, -58, CURRENT_DATE()), NULL, 10, 'Diabetes management', 'Active'
UNION ALL SELECT 2457, 15, 11, 7, 'Emergency', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2458, 8, 17, 6, 'Outpatient', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -58, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2459, 26, 3, 1, 'Emergency', DATEADD(DAY, -58, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 2, 'Burns', 'Completed'
UNION ALL SELECT 2460, 1, 12, 8, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 5, 'COPD', 'Completed'
UNION ALL SELECT 2461, 30, 12, 4, 'Outpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 0, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2462, 47, 18, 4, 'Emergency', DATEADD(DAY, -57, CURRENT_DATE()), NULL, 2, 'ACL repair', 'Active'
UNION ALL SELECT 2463, 41, 23, 6, 'Outpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 0, 'Breast cancer', 'Completed'
UNION ALL SELECT 2464, 48, 24, 7, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 3, 'Appendicitis', 'Completed'
UNION ALL SELECT 2465, 4, 5, 8, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 8, 'Cellulitis', 'Completed'
UNION ALL SELECT 2466, 45, 12, 7, 'Outpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 2467, 33, 5, 2, 'Emergency', DATEADD(DAY, -57, CURRENT_DATE()), NULL, 3, 'Severe trauma', 'Active'
UNION ALL SELECT 2468, 16, 10, 3, 'Outpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2469, 45, 24, 7, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), NULL, 2, 'Appendicitis', 'Active'
UNION ALL SELECT 2470, 9, 25, 4, 'Emergency', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 1, 'ACL repair', 'Completed'
UNION ALL SELECT 2471, 27, 4, 6, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 5, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2472, 17, 4, 8, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 4, 'UTI', 'Completed'
UNION ALL SELECT 2473, 14, 11, 1, 'Inpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -56, CURRENT_DATE()), 1, 'Laceration', 'Completed'
UNION ALL SELECT 2474, 44, 10, 1, 'Emergency', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2475, 7, 15, 4, 'Outpatient', DATEADD(DAY, -57, CURRENT_DATE()), DATEADD(DAY, -57, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 2476, 50, 8, 1, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 2477, 38, 19, 2, 'Emergency', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2478, 9, 3, 8, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), NULL, 10, 'DVT', 'Active'
UNION ALL SELECT 2479, 47, 13, 7, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 4, 'Dehydration', 'Completed'
UNION ALL SELECT 2480, 12, 9, 4, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 1, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2481, 42, 10, 4, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), NULL, 3, 'Rotator cuff tear', 'Active'
UNION ALL SELECT 2482, 25, 5, 5, 'Inpatient', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 7, 'Migraine', 'Completed'
UNION ALL SELECT 2483, 25, 23, 1, 'Emergency', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 2, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2484, 25, 9, 6, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), NULL, 3, 'Lung cancer', 'Active'
UNION ALL SELECT 2485, 4, 16, 5, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 3, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2486, 7, 8, 3, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 6, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2487, 49, 8, 1, 'Emergency', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 2, 'Overdose', 'Completed'
UNION ALL SELECT 2488, 12, 8, 3, 'Outpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2489, 46, 23, 1, 'Outpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 0, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2490, 32, 18, 4, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), NULL, 0, 'Spinal stenosis', 'Active'
UNION ALL SELECT 2491, 15, 20, 1, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 3, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2492, 9, 11, 4, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 6, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2493, 2, 5, 1, 'Emergency', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 1, 'Overdose', 'Completed'
UNION ALL SELECT 2494, 5, 12, 6, 'Outpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2495, 22, 10, 2, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2496, 42, 11, 8, 'Emergency', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 3, 'Diabetes management', 'Completed'
UNION ALL SELECT 2497, 43, 19, 4, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 2, 'ACL repair', 'Completed'
UNION ALL SELECT 2498, 12, 24, 3, 'Outpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -55, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2499, 50, 19, 7, 'Inpatient', DATEADD(DAY, -55, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 2, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2500, 41, 19, 4, 'Outpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 2501, 16, 12, 2, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), NULL, 7, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2502, 29, 1, 6, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 4, 'Colon cancer', 'Completed'
UNION ALL SELECT 2503, 47, 1, 2, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 5, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2504, 32, 13, 7, 'Emergency', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 2505, 11, 15, 4, 'Emergency', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 1, 'Hip fracture', 'Completed'
UNION ALL SELECT 2506, 5, 11, 2, 'Emergency', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 1, 'Septic shock', 'Completed'
UNION ALL SELECT 2507, 22, 20, 2, 'Emergency', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2508, 39, 14, 3, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 2, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2509, 45, 18, 7, 'Outpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -54, CURRENT_DATE()), 0, 'Fracture', 'Completed'
UNION ALL SELECT 2510, 20, 8, 5, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 3, 'Stroke', 'Completed'
UNION ALL SELECT 2511, 4, 12, 3, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 2, 'Heart failure', 'Completed'
UNION ALL SELECT 2512, 13, 4, 8, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 4, 'Pneumonia', 'Completed'
UNION ALL SELECT 2513, 8, 10, 8, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 7, 'Anemia', 'Completed'
UNION ALL SELECT 2514, 12, 12, 7, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 2, 'Dehydration', 'Completed'
UNION ALL SELECT 2515, 17, 8, 8, 'Emergency', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 3, 'Cellulitis', 'Completed'
UNION ALL SELECT 2516, 43, 12, 2, 'Inpatient', DATEADD(DAY, -54, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 5, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2517, 34, 14, 7, 'Emergency', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 3, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2518, 20, 3, 8, 'Outpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 2519, 8, 25, 3, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 14, 'Pericarditis', 'Completed'
UNION ALL SELECT 2520, 9, 2, 4, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 4, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2521, 39, 9, 3, 'Outpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -53, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2522, 6, 13, 2, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2523, 1, 23, 8, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 1, 'Anemia', 'Completed'
UNION ALL SELECT 2524, 7, 19, 2, 'Inpatient', DATEADD(DAY, -53, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 7, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2525, 25, 21, 5, 'Emergency', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2526, 40, 20, 3, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 7, 'Valve disease', 'Completed'
UNION ALL SELECT 2527, 4, 24, 4, 'Outpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 0, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2528, 22, 10, 1, 'Emergency', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2529, 9, 10, 4, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 6, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2530, 39, 21, 7, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 1, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2531, 49, 17, 8, 'Outpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2532, 5, 10, 3, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 7, 'Valve disease', 'Completed'
UNION ALL SELECT 2533, 12, 7, 1, 'Emergency', DATEADD(DAY, -52, CURRENT_DATE()), NULL, 2, 'Allergic reaction', 'Active'
UNION ALL SELECT 2534, 46, 7, 6, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 3, 'Colon cancer', 'Completed'
UNION ALL SELECT 2535, 44, 1, 2, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2536, 38, 18, 8, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 6, 'DVT', 'Completed'
UNION ALL SELECT 2537, 19, 1, 2, 'Inpatient', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 7, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2538, 15, 21, 4, 'Emergency', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 2, 'Knee replacement', 'Completed'
UNION ALL SELECT 2539, 31, 5, 1, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 2540, 46, 23, 5, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 7, 'TIA', 'Completed'
UNION ALL SELECT 2541, 17, 7, 8, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 3, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2542, 1, 17, 2, 'Outpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 0, 'Severe trauma', 'Completed'
UNION ALL SELECT 2543, 20, 22, 5, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 2, 'Stroke', 'Completed'
UNION ALL SELECT 2544, 18, 9, 6, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 2, 'Leukemia', 'Completed'
UNION ALL SELECT 2545, 4, 20, 4, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), NULL, 3, 'Rotator cuff tear', 'Active'
UNION ALL SELECT 2546, 19, 9, 8, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 5, 'Anemia', 'Completed'
UNION ALL SELECT 2547, 22, 24, 4, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 3, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2548, 33, 10, 6, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 4, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2549, 7, 16, 5, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 3, 'Epilepsy', 'Completed'
UNION ALL SELECT 2550, 44, 11, 3, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 1, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2551, 22, 12, 7, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 1, 'Appendicitis', 'Completed'
UNION ALL SELECT 2552, 31, 7, 2, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 4, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2553, 4, 5, 7, 'Outpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -51, CURRENT_DATE()), 0, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2554, 10, 11, 8, 'Emergency', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 3, 'Diabetes management', 'Completed'
UNION ALL SELECT 2555, 41, 2, 6, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -50, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 2556, 32, 25, 3, 'Inpatient', DATEADD(DAY, -51, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2557, 25, 1, 8, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 1, 'Pneumonia', 'Completed'
UNION ALL SELECT 2558, 2, 22, 4, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 3, 'Hip fracture', 'Completed'
UNION ALL SELECT 2559, 9, 4, 5, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2560, 19, 15, 5, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 2, 'TIA', 'Completed'
UNION ALL SELECT 2561, 22, 16, 3, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 2, 'Angina', 'Active'
UNION ALL SELECT 2562, 47, 5, 4, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 1, 'Knee replacement', 'Active'
UNION ALL SELECT 2563, 25, 21, 1, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2564, 42, 1, 2, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 2, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2565, 31, 23, 5, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 4, 'Epilepsy', 'Active'
UNION ALL SELECT 2566, 43, 4, 7, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 3, 'Fracture', 'Active'
UNION ALL SELECT 2567, 33, 24, 2, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), NULL, 1, 'Cardiac arrest recovery', 'Active'
UNION ALL SELECT 2568, 39, 7, 4, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2569, 19, 6, 7, 'Emergency', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2570, 16, 1, 6, 'Inpatient', DATEADD(DAY, -50, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 8, 'Breast cancer', 'Completed'
UNION ALL SELECT 2571, 10, 3, 8, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 2, 'UTI', 'Completed'
UNION ALL SELECT 2572, 19, 9, 8, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 6, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2573, 24, 22, 5, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2574, 1, 5, 1, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 3, 'Laceration', 'Completed'
UNION ALL SELECT 2575, 24, 11, 2, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2576, 45, 16, 7, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), NULL, 1, 'Croup', 'Active'
UNION ALL SELECT 2577, 11, 4, 1, 'Outpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 0, 'Seizure', 'Completed'
UNION ALL SELECT 2578, 12, 20, 8, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 3, 'Anemia', 'Completed'
UNION ALL SELECT 2579, 31, 16, 3, 'Outpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -49, CURRENT_DATE()), 0, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2580, 17, 21, 2, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 7, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2581, 43, 11, 4, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 1, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2582, 31, 12, 4, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 3, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2583, 1, 21, 1, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 2584, 49, 16, 2, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), NULL, 14, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2585, 36, 21, 4, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 1, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2586, 6, 16, 8, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 14, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2587, 7, 13, 1, 'Inpatient', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 3, 'Seizure', 'Completed'
UNION ALL SELECT 2588, 33, 18, 5, 'Emergency', DATEADD(DAY, -49, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 2, 'Epilepsy', 'Completed'
UNION ALL SELECT 2589, 30, 11, 4, 'Emergency', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2590, 8, 4, 8, 'Inpatient', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 2, 'COPD', 'Completed'
UNION ALL SELECT 2591, 36, 17, 5, 'Emergency', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2592, 7, 9, 7, 'Inpatient', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 1, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2593, 30, 7, 4, 'Inpatient', DATEADD(DAY, -48, CURRENT_DATE()), NULL, 5, 'Carpal tunnel', 'Active'
UNION ALL SELECT 2594, 50, 15, 2, 'Inpatient', DATEADD(DAY, -48, CURRENT_DATE()), NULL, 10, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 2595, 1, 17, 8, 'Emergency', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 3, 'Pneumonia', 'Completed'
UNION ALL SELECT 2596, 45, 19, 3, 'Emergency', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 2, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2597, 33, 13, 6, 'Outpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 0, 'Lymphoma', 'Completed'
UNION ALL SELECT 2598, 18, 13, 4, 'Outpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 0, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2599, 9, 14, 3, 'Outpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2600, 46, 24, 6, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 1, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2601, 44, 12, 5, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 5, 'TIA', 'Completed'
UNION ALL SELECT 2602, 33, 18, 3, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 3, 'Angina', 'Completed'
UNION ALL SELECT 2603, 44, 24, 7, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 2, 'Croup', 'Completed'
UNION ALL SELECT 2604, 2, 13, 2, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), NULL, 0, 'Septic shock', 'Active'
UNION ALL SELECT 2605, 49, 6, 5, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2606, 14, 25, 5, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), NULL, 6, 'Parkinson disease', 'Active'
UNION ALL SELECT 2607, 48, 21, 4, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2608, 45, 22, 5, 'Outpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -47, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2609, 36, 2, 6, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 2, 'Breast cancer', 'Completed'
UNION ALL SELECT 2610, 49, 19, 6, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 3, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2611, 29, 6, 5, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 10, 'TIA', 'Completed'
UNION ALL SELECT 2612, 25, 2, 2, 'Inpatient', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2613, 1, 11, 5, 'Emergency', DATEADD(DAY, -47, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2614, 50, 21, 1, 'Emergency', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Overdose', 'Completed'
UNION ALL SELECT 2615, 46, 11, 2, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), NULL, 1, 'Cardiac arrest recovery', 'Active'
UNION ALL SELECT 2616, 27, 18, 3, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 1, 'Valve disease', 'Completed'
UNION ALL SELECT 2617, 22, 12, 6, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 5, 'Colon cancer', 'Completed'
UNION ALL SELECT 2618, 8, 22, 1, 'Emergency', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2619, 3, 22, 4, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), NULL, 5, 'Spinal stenosis', 'Active'
UNION ALL SELECT 2620, 35, 24, 5, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2621, 32, 2, 8, 'Outpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 0, 'Cellulitis', 'Completed'
UNION ALL SELECT 2622, 7, 6, 2, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 4, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2623, 44, 14, 4, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2624, 42, 3, 7, 'Emergency', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2625, 5, 2, 2, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Septic shock', 'Completed'
UNION ALL SELECT 2626, 17, 14, 4, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 2, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2627, 44, 4, 7, 'Inpatient', DATEADD(DAY, -46, CURRENT_DATE()), NULL, 5, 'Febrile seizure', 'Active'
UNION ALL SELECT 2628, 45, 3, 1, 'Outpatient', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -46, CURRENT_DATE()), 0, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2629, 39, 3, 5, 'Emergency', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 2, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2630, 31, 6, 1, 'Emergency', DATEADD(DAY, -46, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 3, 'Head injury', 'Completed'
UNION ALL SELECT 2631, 20, 22, 3, 'Outpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2632, 8, 2, 3, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 2, 'Heart failure', 'Completed'
UNION ALL SELECT 2633, 20, 7, 2, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 5, 'Severe trauma', 'Completed'
UNION ALL SELECT 2634, 11, 6, 3, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 1, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2635, 49, 18, 1, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), NULL, 3, 'Burns', 'Active'
UNION ALL SELECT 2636, 13, 24, 2, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), NULL, 2, 'Cardiac arrest recovery', 'Active'
UNION ALL SELECT 2637, 7, 10, 4, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 1, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2638, 40, 22, 6, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2639, 28, 6, 6, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 5, 'Breast cancer', 'Completed'
UNION ALL SELECT 2640, 18, 12, 7, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2641, 50, 10, 6, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 1, 'Lymphoma', 'Completed'
UNION ALL SELECT 2642, 9, 18, 5, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), NULL, 7, 'Epilepsy', 'Active'
UNION ALL SELECT 2643, 2, 17, 2, 'Inpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 3, 'Severe trauma', 'Completed'
UNION ALL SELECT 2644, 3, 18, 4, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 2, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2645, 24, 13, 3, 'Outpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 0, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2646, 9, 15, 5, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), NULL, 3, 'Parkinson disease', 'Active'
UNION ALL SELECT 2647, 40, 22, 4, 'Emergency', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 1, 'Knee replacement', 'Completed'
UNION ALL SELECT 2648, 48, 24, 3, 'Outpatient', DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 0, 'Pericarditis', 'Completed'
UNION ALL SELECT 2649, 5, 9, 4, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 4, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2650, 25, 16, 6, 'Outpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 0, 'Lymphoma', 'Completed'
UNION ALL SELECT 2651, 7, 23, 6, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 2, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2652, 25, 21, 3, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 4, 'Valve disease', 'Completed'
UNION ALL SELECT 2653, 25, 8, 5, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 6, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2654, 39, 1, 8, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 1, 'Diabetes management', 'Completed'
UNION ALL SELECT 2655, 14, 5, 5, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 4, 'Epilepsy', 'Completed'
UNION ALL SELECT 2656, 27, 11, 4, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 4, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2657, 42, 14, 3, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 1, 'Heart failure', 'Completed'
UNION ALL SELECT 2658, 41, 17, 3, 'Outpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -44, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2659, 17, 6, 3, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), NULL, 3, 'Valve disease', 'Active'
UNION ALL SELECT 2660, 6, 7, 5, 'Emergency', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 2, 'Migraine', 'Completed'
UNION ALL SELECT 2661, 39, 5, 7, 'Emergency', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 3, 'Croup', 'Completed'
UNION ALL SELECT 2662, 11, 24, 5, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 3, 'TIA', 'Completed'
UNION ALL SELECT 2663, 25, 13, 4, 'Inpatient', DATEADD(DAY, -44, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 1, 'Knee replacement', 'Completed'
UNION ALL SELECT 2664, 10, 20, 7, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 8, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2665, 6, 16, 2, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 4, 'Severe trauma', 'Completed'
UNION ALL SELECT 2666, 34, 14, 7, 'Outpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), 0, 'Appendicitis', 'Completed'
UNION ALL SELECT 2667, 15, 16, 7, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 3, 'Croup', 'Completed'
UNION ALL SELECT 2668, 28, 5, 2, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2669, 39, 18, 5, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), NULL, 0, 'Migraine', 'Active'
UNION ALL SELECT 2670, 37, 17, 1, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2671, 27, 12, 6, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 4, 'Breast cancer', 'Completed'
UNION ALL SELECT 2672, 37, 12, 7, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 4, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2673, 36, 18, 7, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 3, 'Dehydration', 'Completed'
UNION ALL SELECT 2674, 37, 12, 5, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), NULL, 3, 'Neuropathy', 'Active'
UNION ALL SELECT 2675, 29, 23, 4, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 3, 'Knee replacement', 'Completed'
UNION ALL SELECT 2676, 11, 13, 1, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 2, 'Chest pain', 'Completed'
UNION ALL SELECT 2677, 6, 3, 7, 'Inpatient', DATEADD(DAY, -43, CURRENT_DATE()), NULL, 0, 'Appendicitis', 'Active'
UNION ALL SELECT 2678, 47, 13, 1, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 3, 'Seizure', 'Completed'
UNION ALL SELECT 2679, 50, 6, 1, 'Emergency', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 3, 'Burns', 'Completed'
UNION ALL SELECT 2680, 13, 2, 5, 'Emergency', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 2681, 24, 8, 1, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'Chest pain', 'Completed'
UNION ALL SELECT 2682, 50, 13, 5, 'Emergency', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2683, 6, 18, 2, 'Inpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 3, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2684, 18, 8, 6, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2685, 37, 1, 7, 'Inpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 3, 'Appendicitis', 'Completed'
UNION ALL SELECT 2686, 22, 4, 5, 'Emergency', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 3, 'Neuropathy', 'Completed'
UNION ALL SELECT 2687, 45, 15, 5, 'Emergency', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 2, 'Migraine', 'Completed'
UNION ALL SELECT 2688, 44, 15, 8, 'Inpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 2, 'Pneumonia', 'Completed'
UNION ALL SELECT 2689, 44, 23, 4, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'Knee replacement', 'Completed'
UNION ALL SELECT 2690, 34, 18, 6, 'Emergency', DATEADD(DAY, -42, CURRENT_DATE()), NULL, 2, 'Breast cancer', 'Active'
UNION ALL SELECT 2691, 5, 18, 6, 'Inpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 2, 'Lung cancer', 'Completed'
UNION ALL SELECT 2692, 12, 24, 5, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'TIA', 'Completed'
UNION ALL SELECT 2693, 16, 24, 4, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'Knee replacement', 'Completed'
UNION ALL SELECT 2694, 16, 20, 4, 'Inpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 1, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2695, 40, 1, 8, 'Outpatient', DATEADD(DAY, -42, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2696, 37, 9, 8, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 5, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2697, 15, 25, 7, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 3, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2698, 33, 12, 1, 'Emergency', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 2699, 21, 23, 8, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 1, 'Pneumonia', 'Completed'
UNION ALL SELECT 2700, 24, 20, 6, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2701, 40, 11, 8, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 2, 'DVT', 'Completed'
UNION ALL SELECT 2702, 24, 13, 6, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 3, 'Colon cancer', 'Completed'
UNION ALL SELECT 2703, 7, 24, 4, 'Outpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 0, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2704, 13, 5, 7, 'Outpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), 0, 'Croup', 'Completed'
UNION ALL SELECT 2705, 12, 14, 1, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 7, 'Burns', 'Completed'
UNION ALL SELECT 2706, 32, 10, 6, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 3, 'Colon cancer', 'Completed'
UNION ALL SELECT 2707, 4, 7, 3, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 4, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2708, 17, 12, 6, 'Inpatient', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 8, 'Colon cancer', 'Completed'
UNION ALL SELECT 2709, 8, 12, 7, 'Emergency', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 3, 'Croup', 'Completed'
UNION ALL SELECT 2710, 50, 10, 3, 'Inpatient', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 3, 'Angina', 'Completed'
UNION ALL SELECT 2711, 6, 13, 8, 'Inpatient', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 10, 'Cellulitis', 'Completed'
UNION ALL SELECT 2712, 27, 21, 6, 'Inpatient', DATEADD(DAY, -40, CURRENT_DATE()), NULL, 6, 'Prostate cancer', 'Active'
UNION ALL SELECT 2713, 22, 8, 3, 'Inpatient', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 2, 'Angina', 'Completed'
UNION ALL SELECT 2714, 18, 15, 7, 'Outpatient', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 0, 'Croup', 'Completed'
UNION ALL SELECT 2715, 27, 6, 8, 'Outpatient', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -40, CURRENT_DATE()), 0, 'Diabetes management', 'Completed'
UNION ALL SELECT 2716, 43, 9, 4, 'Emergency', DATEADD(DAY, -40, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 1, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2717, 31, 18, 2, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 2, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2718, 7, 9, 2, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 4, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2719, 15, 8, 5, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), NULL, 4, 'TIA', 'Active'
UNION ALL SELECT 2720, 2, 2, 3, 'Outpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2721, 30, 18, 8, 'Emergency', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 3, 'Cellulitis', 'Completed'
UNION ALL SELECT 2722, 41, 24, 8, 'Emergency', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 2723, 35, 8, 8, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 2, 'UTI', 'Completed'
UNION ALL SELECT 2724, 1, 1, 5, 'Outpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -39, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2725, 19, 16, 6, 'Inpatient', DATEADD(DAY, -39, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 8, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2726, 1, 25, 5, 'Emergency', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2727, 27, 18, 4, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 1, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2728, 25, 8, 7, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 4, 'Appendicitis', 'Completed'
UNION ALL SELECT 2729, 19, 21, 5, 'Emergency', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 1, 'TIA', 'Completed'
UNION ALL SELECT 2730, 9, 10, 3, 'Emergency', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2731, 13, 11, 8, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), NULL, 10, 'Pneumonia', 'Active'
UNION ALL SELECT 2732, 19, 9, 2, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 5, 'Septic shock', 'Completed'
UNION ALL SELECT 2733, 1, 16, 3, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 2, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2734, 30, 23, 6, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), NULL, 0, 'Pancreatic cancer', 'Active'
UNION ALL SELECT 2735, 4, 9, 3, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 3, 'Valve disease', 'Completed'
UNION ALL SELECT 2736, 25, 1, 5, 'Outpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2737, 50, 15, 7, 'Emergency', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 2738, 34, 22, 2, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 4, 'Septic shock', 'Completed'
UNION ALL SELECT 2739, 11, 21, 6, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 8, 'Leukemia', 'Completed'
UNION ALL SELECT 2740, 31, 21, 5, 'Inpatient', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 7, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2741, 16, 21, 2, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 1, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2742, 26, 8, 2, 'Outpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 0, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2743, 45, 20, 8, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), NULL, 0, 'Diabetes management', 'Active'
UNION ALL SELECT 2744, 32, 3, 3, 'Outpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -37, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2745, 4, 12, 1, 'Emergency', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 1, 'Laceration', 'Completed'
UNION ALL SELECT 2746, 36, 21, 6, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 7, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2747, 45, 13, 1, 'Emergency', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 1, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2748, 36, 10, 8, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 1, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2749, 18, 20, 8, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 1, 'Diabetes management', 'Completed'
UNION ALL SELECT 2750, 35, 12, 5, 'Inpatient', DATEADD(DAY, -37, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 4, 'Migraine', 'Completed'
UNION ALL SELECT 2751, 2, 20, 3, 'Emergency', DATEADD(DAY, -37, CURRENT_DATE()), NULL, 3, 'Angina', 'Active'
UNION ALL SELECT 2752, 13, 17, 7, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2753, 42, 11, 7, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), NULL, 4, 'Asthma exacerbation', 'Active'
UNION ALL SELECT 2754, 12, 2, 3, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), NULL, 1, 'Myocardial infarction', 'Active'
UNION ALL SELECT 2755, 43, 16, 7, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 1, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2756, 1, 7, 2, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), NULL, 7, 'Severe trauma', 'Active'
UNION ALL SELECT 2757, 24, 18, 1, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 1, 'Seizure', 'Completed'
UNION ALL SELECT 2758, 34, 2, 5, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 2, 'TIA', 'Completed'
UNION ALL SELECT 2759, 7, 24, 2, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 1, 'Septic shock', 'Completed'
UNION ALL SELECT 2760, 37, 21, 4, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), NULL, 3, 'Knee replacement', 'Active'
UNION ALL SELECT 2761, 44, 15, 6, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 7, 'Leukemia', 'Completed'
UNION ALL SELECT 2762, 36, 13, 3, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 3, 'Angina', 'Completed'
UNION ALL SELECT 2763, 21, 18, 6, 'Outpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2764, 47, 11, 7, 'Inpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 3, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2765, 24, 15, 5, 'Outpatient', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -36, CURRENT_DATE()), 0, 'Migraine', 'Completed'
UNION ALL SELECT 2766, 19, 20, 1, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), NULL, 2, 'Chest pain', 'Active'
UNION ALL SELECT 2767, 14, 11, 4, 'Emergency', DATEADD(DAY, -36, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 2, 'Hip fracture', 'Completed'
UNION ALL SELECT 2768, 7, 2, 3, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 1, 'Pericarditis', 'Completed'
UNION ALL SELECT 2769, 15, 9, 4, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2770, 47, 3, 4, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 3, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2771, 39, 21, 2, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 6, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2772, 50, 11, 1, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 1, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2773, 48, 21, 4, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2774, 34, 2, 5, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 3, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2775, 4, 22, 3, 'Outpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 0, 'Valve disease', 'Completed'
UNION ALL SELECT 2776, 15, 14, 2, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2777, 37, 24, 8, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 2, 'Pneumonia', 'Completed'
UNION ALL SELECT 2778, 49, 5, 3, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 3, 'Pericarditis', 'Completed'
UNION ALL SELECT 2779, 36, 20, 4, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2780, 44, 19, 6, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 2, 'Breast cancer', 'Completed'
UNION ALL SELECT 2781, 21, 12, 4, 'Emergency', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 1, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2782, 40, 5, 8, 'Inpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 6, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2783, 10, 25, 6, 'Outpatient', DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 2784, 40, 5, 4, 'Outpatient', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 0, 'ACL repair', 'Completed'
UNION ALL SELECT 2785, 45, 4, 6, 'Inpatient', DATEADD(DAY, -34, CURRENT_DATE()), NULL, 0, 'Colon cancer', 'Active'
UNION ALL SELECT 2786, 48, 18, 4, 'Inpatient', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 3, 'Knee replacement', 'Completed'
UNION ALL SELECT 2787, 40, 24, 8, 'Emergency', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 2788, 17, 6, 1, 'Emergency', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 3, 'Chest pain', 'Completed'
UNION ALL SELECT 2789, 42, 1, 8, 'Inpatient', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 2, 'UTI', 'Completed'
UNION ALL SELECT 2790, 7, 1, 6, 'Outpatient', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -34, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2791, 25, 17, 4, 'Inpatient', DATEADD(DAY, -34, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2792, 12, 7, 2, 'Outpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 0, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2793, 3, 8, 1, 'Emergency', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 3, 'Head injury', 'Completed'
UNION ALL SELECT 2794, 44, 12, 6, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Colon cancer', 'Completed'
UNION ALL SELECT 2795, 4, 21, 5, 'Outpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 0, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2796, 36, 9, 1, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 7, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2797, 47, 13, 2, 'Outpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -33, CURRENT_DATE()), 0, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2798, 27, 8, 4, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 14, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2799, 29, 18, 6, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Lung cancer', 'Completed'
UNION ALL SELECT 2800, 9, 10, 4, 'Emergency', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2801, 42, 19, 3, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2802, 12, 11, 2, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 5, 'Septic shock', 'Completed'
UNION ALL SELECT 2803, 27, 10, 7, 'Emergency', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 3, 'Dehydration', 'Completed'
UNION ALL SELECT 2804, 10, 25, 5, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Epilepsy', 'Completed'
UNION ALL SELECT 2805, 39, 19, 5, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2806, 6, 23, 6, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 3, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2807, 12, 13, 6, 'Inpatient', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 1, 'Lymphoma', 'Completed'
UNION ALL SELECT 2808, 18, 14, 1, 'Emergency', DATEADD(DAY, -32, CURRENT_DATE()), NULL, 1, 'Allergic reaction', 'Active'
UNION ALL SELECT 2809, 40, 16, 8, 'Outpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 0, 'DVT', 'Completed'
UNION ALL SELECT 2810, 26, 25, 7, 'Emergency', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2811, 34, 4, 1, 'Emergency', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 1, 'Burns', 'Completed'
UNION ALL SELECT 2812, 48, 2, 7, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 5, 'Febrile seizure', 'Completed'
UNION ALL SELECT 2813, 19, 15, 4, 'Outpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -32, CURRENT_DATE()), 0, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2814, 30, 6, 5, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 8, 'Migraine', 'Completed'
UNION ALL SELECT 2815, 30, 21, 3, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 3, 'Pericarditis', 'Completed'
UNION ALL SELECT 2816, 26, 14, 3, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 1, 'Angina', 'Completed'
UNION ALL SELECT 2817, 30, 3, 4, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 4, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2818, 46, 24, 3, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 5, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2819, 34, 23, 2, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 14, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2820, 25, 18, 3, 'Inpatient', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 1, 'Valve disease', 'Completed'
UNION ALL SELECT 2821, 11, 5, 3, 'Emergency', DATEADD(DAY, -32, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 2, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2822, 41, 6, 5, 'Outpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2823, 40, 25, 1, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 2824, 39, 16, 1, 'Emergency', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 2, 'Allergic reaction', 'Completed'
UNION ALL SELECT 2825, 39, 20, 2, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 3, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2826, 4, 6, 4, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), NULL, 2, 'Knee replacement', 'Active'
UNION ALL SELECT 2827, 43, 19, 1, 'Emergency', DATEADD(DAY, -31, CURRENT_DATE()), NULL, 1, 'Overdose', 'Active'
UNION ALL SELECT 2828, 11, 22, 3, 'Emergency', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 3, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2829, 30, 24, 3, 'Outpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2830, 21, 12, 5, 'Outpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -31, CURRENT_DATE()), 0, 'Migraine', 'Completed'
UNION ALL SELECT 2831, 19, 16, 2, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 7, 'Septic shock', 'Completed'
UNION ALL SELECT 2832, 34, 7, 7, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), NULL, 0, 'Fracture', 'Active'
UNION ALL SELECT 2833, 31, 24, 2, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 5, 'Severe trauma', 'Completed'
UNION ALL SELECT 2834, 39, 11, 7, 'Emergency', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 2835, 34, 24, 8, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 1, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2836, 13, 1, 5, 'Inpatient', DATEADD(DAY, -31, CURRENT_DATE()), NULL, 4, 'Stroke', 'Active'
UNION ALL SELECT 2837, 27, 2, 7, 'Inpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 6, 'Appendicitis', 'Completed'
UNION ALL SELECT 2838, 45, 10, 4, 'Emergency', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 3, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2839, 8, 22, 1, 'Emergency', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 3, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2840, 13, 11, 3, 'Outpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2841, 3, 21, 8, 'Inpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 4, 'Diabetes management', 'Completed'
UNION ALL SELECT 2842, 30, 14, 6, 'Inpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 3, 'Leukemia', 'Completed'
UNION ALL SELECT 2843, 36, 18, 6, 'Inpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 4, 'Breast cancer', 'Completed'
UNION ALL SELECT 2844, 5, 5, 6, 'Outpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2845, 41, 18, 7, 'Inpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 4, 'Croup', 'Completed'
UNION ALL SELECT 2846, 49, 10, 2, 'Emergency', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 2, 'Severe trauma', 'Completed'
UNION ALL SELECT 2847, 16, 12, 8, 'Outpatient', DATEADD(DAY, -30, CURRENT_DATE()), DATEADD(DAY, -30, CURRENT_DATE()), 0, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2848, 12, 4, 5, 'Emergency', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2849, 31, 17, 1, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 8, 'Laceration', 'Completed'
UNION ALL SELECT 2850, 50, 11, 5, 'Emergency', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 3, 'Epilepsy', 'Completed'
UNION ALL SELECT 2851, 14, 24, 3, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 5, 'Heart failure', 'Completed'
UNION ALL SELECT 2852, 20, 2, 1, 'Emergency', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 1, 'Overdose', 'Active'
UNION ALL SELECT 2853, 2, 19, 5, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 7, 'Neuropathy', 'Completed'
UNION ALL SELECT 2854, 19, 9, 4, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 2, 'Ankle fracture', 'Active'
UNION ALL SELECT 2855, 11, 9, 3, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 4, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2856, 35, 12, 4, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 1, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2857, 37, 8, 5, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 4, 'Epilepsy', 'Completed'
UNION ALL SELECT 2858, 4, 5, 8, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 4, 'Pneumonia', 'Active'
UNION ALL SELECT 2859, 6, 14, 1, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 3, 'Seizure', 'Completed'
UNION ALL SELECT 2860, 40, 12, 8, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 1, 'Cellulitis', 'Completed'
UNION ALL SELECT 2861, 49, 25, 2, 'Inpatient', DATEADD(DAY, -29, CURRENT_DATE()), NULL, 0, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 2862, 7, 15, 8, 'Emergency', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 2, 'Cellulitis', 'Completed'
UNION ALL SELECT 2863, 10, 20, 4, 'Outpatient', DATEADD(DAY, -29, CURRENT_DATE()), DATEADD(DAY, -29, CURRENT_DATE()), 0, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2864, 21, 15, 6, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 3, 'Lymphoma', 'Completed'
UNION ALL SELECT 2865, 11, 10, 8, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 1, 'DVT', 'Completed'
UNION ALL SELECT 2866, 21, 18, 2, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 2, 'Severe trauma', 'Completed'
UNION ALL SELECT 2867, 16, 20, 7, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), NULL, 2, 'Bronchiolitis', 'Active'
UNION ALL SELECT 2868, 45, 19, 4, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 2, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2869, 12, 22, 4, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 8, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2870, 8, 19, 8, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), NULL, 0, 'Hypertension crisis', 'Active'
UNION ALL SELECT 2871, 12, 10, 8, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 1, 'Anemia', 'Completed'
UNION ALL SELECT 2872, 21, 16, 7, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2873, 49, 5, 1, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 3, 'Laceration', 'Completed'
UNION ALL SELECT 2874, 14, 22, 4, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 5, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 2875, 46, 12, 7, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2876, 19, 2, 3, 'Outpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 2877, 46, 18, 1, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), NULL, 2, 'Shortness of breath', 'Active'
UNION ALL SELECT 2878, 45, 19, 7, 'Emergency', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 2, 'Dehydration', 'Completed'
UNION ALL SELECT 2879, 43, 6, 4, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 3, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2880, 27, 5, 6, 'Outpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), 0, 'Colon cancer', 'Completed'
UNION ALL SELECT 2881, 1, 3, 3, 'Inpatient', DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 7, 'Heart failure', 'Completed'
UNION ALL SELECT 2882, 9, 21, 2, 'Emergency', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 3, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2883, 40, 6, 7, 'Emergency', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 2, 'Dehydration', 'Completed'
UNION ALL SELECT 2884, 12, 14, 4, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 3, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2885, 27, 18, 5, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 14, 'Parkinson disease', 'Completed'
UNION ALL SELECT 2886, 8, 19, 6, 'Outpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 0, 'Lymphoma', 'Completed'
UNION ALL SELECT 2887, 30, 17, 5, 'Emergency', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 1, 'Stroke', 'Completed'
UNION ALL SELECT 2888, 44, 21, 2, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), NULL, 2, 'Cardiac arrest recovery', 'Active'
UNION ALL SELECT 2889, 35, 25, 6, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 3, 'Breast cancer', 'Completed'
UNION ALL SELECT 2890, 27, 12, 6, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 1, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2891, 47, 19, 5, 'Inpatient', DATEADD(DAY, -27, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 3, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2892, 48, 20, 5, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), NULL, 0, 'Stroke', 'Active'
UNION ALL SELECT 2893, 18, 9, 2, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 2894, 39, 6, 2, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 4, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2895, 17, 23, 3, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 5, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2896, 6, 5, 6, 'Outpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -26, CURRENT_DATE()), 0, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2897, 49, 14, 8, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 2898, 37, 24, 4, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 4, 'ACL repair', 'Completed'
UNION ALL SELECT 2899, 4, 6, 2, 'Inpatient', DATEADD(DAY, -26, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2900, 25, 22, 4, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 2901, 1, 10, 7, 'Emergency', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 3, 'Croup', 'Completed'
UNION ALL SELECT 2902, 7, 18, 1, 'Outpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 0, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2903, 22, 9, 5, 'Outpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -25, CURRENT_DATE()), 0, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 2904, 30, 25, 7, 'Emergency', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 3, 'Fracture', 'Completed'
UNION ALL SELECT 2905, 44, 23, 6, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), NULL, 0, 'Lung cancer', 'Active'
UNION ALL SELECT 2906, 5, 1, 1, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 1, 'Seizure', 'Completed'
UNION ALL SELECT 2907, 47, 10, 4, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), NULL, 0, 'Spinal stenosis', 'Active'
UNION ALL SELECT 2908, 4, 20, 2, 'Emergency', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 3, 'Severe trauma', 'Completed'
UNION ALL SELECT 2909, 6, 20, 2, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 5, 'Septic shock', 'Completed'
UNION ALL SELECT 2910, 8, 23, 3, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2911, 18, 25, 8, 'Emergency', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 2912, 18, 25, 2, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), NULL, 2, 'Respiratory failure', 'Active'
UNION ALL SELECT 2913, 12, 15, 5, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 8, 'Stroke', 'Completed'
UNION ALL SELECT 2914, 42, 16, 3, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 5, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2915, 29, 23, 2, 'Inpatient', DATEADD(DAY, -25, CURRENT_DATE()), NULL, 0, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2916, 50, 15, 5, 'Outpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 2917, 3, 22, 1, 'Emergency', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 2918, 31, 14, 8, 'Outpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 2919, 35, 8, 2, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 4, 'Respiratory failure', 'Completed'
UNION ALL SELECT 2920, 37, 18, 2, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), NULL, 2, 'Multi-organ failure', 'Active'
UNION ALL SELECT 2921, 24, 18, 2, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 3, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2922, 12, 18, 4, 'Outpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 2923, 45, 13, 5, 'Emergency', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 1, 'Stroke', 'Completed'
UNION ALL SELECT 2924, 48, 7, 8, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), NULL, 0, 'Diabetes management', 'Active'
UNION ALL SELECT 2925, 32, 13, 4, 'Emergency', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 2, 'Hip fracture', 'Completed'
UNION ALL SELECT 2926, 2, 2, 8, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), NULL, 5, 'DVT', 'Active'
UNION ALL SELECT 2927, 14, 21, 2, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 10, 'Severe trauma', 'Completed'
UNION ALL SELECT 2928, 48, 19, 3, 'Outpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 0, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 2929, 32, 21, 3, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), NULL, 8, 'Heart failure', 'Active'
UNION ALL SELECT 2930, 1, 6, 3, 'Outpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -24, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 2931, 30, 20, 2, 'Emergency', DATEADD(DAY, -24, CURRENT_DATE()), NULL, 1, 'Septic shock', 'Active'
UNION ALL SELECT 2932, 5, 7, 4, 'Inpatient', DATEADD(DAY, -24, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 6, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 2933, 8, 22, 6, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 2, 'Prostate cancer', 'Completed'
UNION ALL SELECT 2934, 49, 2, 4, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), NULL, 0, 'Ankle fracture', 'Active'
UNION ALL SELECT 2935, 10, 25, 5, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 2, 'Migraine', 'Completed'
UNION ALL SELECT 2936, 38, 2, 4, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 6, 'Knee replacement', 'Completed'
UNION ALL SELECT 2937, 2, 16, 3, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), NULL, 1, 'Atrial fibrillation', 'Active'
UNION ALL SELECT 2938, 27, 23, 5, 'Emergency', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 2939, 34, 15, 5, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2940, 46, 16, 3, 'Emergency', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 2941, 13, 4, 4, 'Outpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 0, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2942, 30, 25, 4, 'Emergency', DATEADD(DAY, -23, CURRENT_DATE()), NULL, 1, 'Carpal tunnel', 'Active'
UNION ALL SELECT 2943, 44, 16, 3, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), NULL, 4, 'Pericarditis', 'Active'
UNION ALL SELECT 2944, 19, 7, 6, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 4, 'Lymphoma', 'Completed'
UNION ALL SELECT 2945, 3, 4, 8, 'Outpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -23, CURRENT_DATE()), 0, 'Pneumonia', 'Completed'
UNION ALL SELECT 2946, 32, 17, 1, 'Inpatient', DATEADD(DAY, -23, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 2947, 27, 7, 6, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Leukemia', 'Completed'
UNION ALL SELECT 2948, 15, 4, 6, 'Emergency', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Lung cancer', 'Completed'
UNION ALL SELECT 2949, 31, 19, 2, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2950, 12, 13, 8, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 5, 'DVT', 'Completed'
UNION ALL SELECT 2951, 13, 11, 5, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 3, 'Epilepsy', 'Completed'
UNION ALL SELECT 2952, 30, 15, 2, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2953, 41, 20, 3, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 2954, 34, 16, 7, 'Outpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 0, 'Croup', 'Completed'
UNION ALL SELECT 2955, 18, 1, 8, 'Emergency', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 2956, 38, 5, 4, 'Outpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 0, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2957, 3, 16, 1, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 3, 'Head injury', 'Completed'
UNION ALL SELECT 2958, 29, 16, 2, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 5, 'Septic shock', 'Completed'
UNION ALL SELECT 2959, 14, 5, 7, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), NULL, 4, 'Appendicitis', 'Active'
UNION ALL SELECT 2960, 43, 10, 8, 'Emergency', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 3, 'Diabetes management', 'Completed'
UNION ALL SELECT 2961, 30, 25, 8, 'Outpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -22, CURRENT_DATE()), 0, 'Diabetes management', 'Completed'
UNION ALL SELECT 2962, 41, 15, 6, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), NULL, 7, 'Leukemia', 'Active'
UNION ALL SELECT 2963, 34, 2, 6, 'Inpatient', DATEADD(DAY, -22, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 2964, 44, 3, 4, 'Outpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 0, 'Ankle fracture', 'Completed'
UNION ALL SELECT 2965, 33, 22, 1, 'Emergency', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 2, 'Shortness of breath', 'Completed'
UNION ALL SELECT 2966, 24, 12, 1, 'Emergency', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 3, 'Laceration', 'Completed'
UNION ALL SELECT 2967, 9, 11, 4, 'Emergency', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 3, 'Knee replacement', 'Completed'
UNION ALL SELECT 2968, 49, 24, 4, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 2, 'ACL repair', 'Completed'
UNION ALL SELECT 2969, 18, 2, 7, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 2970, 31, 23, 2, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2971, 44, 23, 6, 'Outpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 0, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2972, 30, 3, 4, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 1, 'Hip fracture', 'Completed'
UNION ALL SELECT 2973, 7, 6, 2, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 1, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 2974, 34, 21, 4, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 10, 'Hip fracture', 'Completed'
UNION ALL SELECT 2975, 31, 12, 3, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 4, 'Valve disease', 'Completed'
UNION ALL SELECT 2976, 2, 8, 2, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 2977, 32, 19, 6, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 6, 'Leukemia', 'Completed'
UNION ALL SELECT 2978, 37, 5, 5, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 5, 'Neuropathy', 'Completed'
UNION ALL SELECT 2979, 19, 25, 6, 'Inpatient', DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 2, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 2980, 46, 18, 3, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 1, 'Arrhythmia', 'Completed'
UNION ALL SELECT 2981, 11, 8, 3, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), NULL, 2, 'Atrial fibrillation', 'Active'
UNION ALL SELECT 2982, 24, 6, 5, 'Emergency', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 2, 'Epilepsy', 'Completed'
UNION ALL SELECT 2983, 24, 15, 3, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), NULL, 1, 'Chest pain evaluation', 'Active'
UNION ALL SELECT 2984, 50, 5, 8, 'Outpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -20, CURRENT_DATE()), 0, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 2985, 42, 23, 6, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 2986, 37, 24, 3, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 1, 'Pericarditis', 'Completed'
UNION ALL SELECT 2987, 9, 22, 1, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), NULL, 0, 'Head injury', 'Active'
UNION ALL SELECT 2988, 29, 12, 4, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 4, 'Hip fracture', 'Completed'
UNION ALL SELECT 2989, 50, 9, 4, 'Inpatient', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 3, 'Knee replacement', 'Completed'
UNION ALL SELECT 2990, 33, 13, 2, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 4, 'Septic shock', 'Completed'
UNION ALL SELECT 2991, 43, 12, 1, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 7, 'Seizure', 'Completed'
UNION ALL SELECT 2992, 1, 10, 6, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 14, 'Colon cancer', 'Completed'
UNION ALL SELECT 2993, 14, 24, 2, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 2994, 47, 14, 3, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 3, 'Valve disease', 'Active'
UNION ALL SELECT 2995, 20, 16, 4, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 3, 'ACL repair', 'Completed'
UNION ALL SELECT 2996, 1, 14, 2, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 3, 'Severe trauma', 'Completed'
UNION ALL SELECT 2997, 13, 6, 3, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 3, 'Valve disease', 'Completed'
UNION ALL SELECT 2998, 38, 10, 5, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 2999, 17, 10, 3, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 4, 'Pericarditis', 'Completed'
UNION ALL SELECT 3000, 32, 23, 3, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 5, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 3001, 39, 24, 2, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 3, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3002, 45, 4, 8, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 2, 'DVT', 'Completed'
UNION ALL SELECT 3003, 10, 11, 1, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 1, 'Burns', 'Active'
UNION ALL SELECT 3004, 27, 21, 6, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 3005, 33, 7, 2, 'Inpatient', DATEADD(DAY, -19, CURRENT_DATE()), NULL, 0, 'Severe trauma', 'Active'
UNION ALL SELECT 3006, 35, 11, 3, 'Outpatient', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), 0, 'Angina', 'Completed'
UNION ALL SELECT 3007, 18, 22, 5, 'Emergency', DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 3, 'TIA', 'Completed'
UNION ALL SELECT 3008, 9, 17, 1, 'Emergency', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 3009, 7, 7, 3, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 6, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 3010, 27, 15, 2, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), NULL, 1, 'Respiratory failure', 'Active'
UNION ALL SELECT 3011, 20, 23, 6, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 3012, 12, 23, 6, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 6, 'Colon cancer', 'Completed'
UNION ALL SELECT 3013, 45, 8, 3, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), NULL, 1, 'Arrhythmia', 'Active'
UNION ALL SELECT 3014, 5, 1, 2, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), NULL, 0, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 3015, 3, 22, 2, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3016, 5, 10, 1, 'Emergency', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 3, 'Chest pain', 'Completed'
UNION ALL SELECT 3017, 12, 22, 4, 'Inpatient', DATEADD(DAY, -18, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 1, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 3018, 23, 6, 6, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 5, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 3019, 7, 19, 2, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 5, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3020, 49, 18, 3, 'Outpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -17, CURRENT_DATE()), 0, 'Heart failure', 'Completed'
UNION ALL SELECT 3021, 33, 23, 4, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 3, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 3022, 12, 12, 2, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 3, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3023, 8, 15, 6, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 3, 'Breast cancer', 'Completed'
UNION ALL SELECT 3024, 36, 24, 5, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 3, 'Stroke', 'Completed'
UNION ALL SELECT 3025, 39, 24, 8, 'Emergency', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 1, 'Cellulitis', 'Completed'
UNION ALL SELECT 3026, 28, 7, 5, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 6, 'Neuropathy', 'Completed'
UNION ALL SELECT 3027, 12, 1, 6, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 1, 'Leukemia', 'Completed'
UNION ALL SELECT 3028, 8, 5, 2, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), NULL, 3, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 3029, 5, 12, 3, 'Inpatient', DATEADD(DAY, -17, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 3, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 3030, 28, 24, 4, 'Inpatient', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 5, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 3031, 49, 21, 5, 'Inpatient', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 4, 'Migraine', 'Completed'
UNION ALL SELECT 3032, 33, 9, 8, 'Emergency', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 3033, 41, 5, 4, 'Inpatient', DATEADD(DAY, -16, CURRENT_DATE()), NULL, 0, 'Hip fracture', 'Active'
UNION ALL SELECT 3034, 32, 22, 2, 'Outpatient', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -16, CURRENT_DATE()), 0, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3035, 10, 10, 6, 'Inpatient', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 5, 'Prostate cancer', 'Completed'
UNION ALL SELECT 3036, 30, 7, 8, 'Emergency', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 2, 'Cellulitis', 'Completed'
UNION ALL SELECT 3037, 49, 2, 1, 'Emergency', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 3038, 29, 15, 7, 'Inpatient', DATEADD(DAY, -16, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3039, 32, 14, 3, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 2, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 3040, 43, 18, 8, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 7, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 3041, 17, 16, 7, 'Outpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -15, CURRENT_DATE()), 0, 'Febrile seizure', 'Completed'
UNION ALL SELECT 3042, 50, 10, 6, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 3, 'Colon cancer', 'Active'
UNION ALL SELECT 3043, 23, 24, 6, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 7, 'Prostate cancer', 'Completed'
UNION ALL SELECT 3044, 28, 12, 2, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 0, 'Multi-organ failure', 'Active'
UNION ALL SELECT 3045, 16, 8, 4, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 0, 'Carpal tunnel', 'Active'
UNION ALL SELECT 3046, 20, 4, 2, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 3, 'Multi-organ failure', 'Active'
UNION ALL SELECT 3047, 37, 17, 7, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 4, 'Dehydration', 'Completed'
UNION ALL SELECT 3048, 25, 19, 6, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), NULL, 0, 'Lymphoma', 'Active'
UNION ALL SELECT 3049, 7, 23, 8, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 3, 'COPD', 'Completed'
UNION ALL SELECT 3050, 11, 20, 6, 'Inpatient', DATEADD(DAY, -15, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 3051, 19, 9, 4, 'Inpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 3, 'Hip fracture', 'Completed'
UNION ALL SELECT 3052, 46, 19, 2, 'Inpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3053, 28, 7, 8, 'Emergency', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'DVT', 'Completed'
UNION ALL SELECT 3054, 28, 22, 5, 'Inpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'Parkinson disease', 'Completed'
UNION ALL SELECT 3055, 43, 25, 8, 'Outpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -14, CURRENT_DATE()), 0, 'Diabetes management', 'Completed'
UNION ALL SELECT 3056, 37, 16, 3, 'Emergency', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 3057, 37, 24, 7, 'Inpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 3058, 10, 24, 4, 'Emergency', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 3059, 41, 7, 2, 'Inpatient', DATEADD(DAY, -14, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3060, 26, 8, 4, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), NULL, 0, 'Hip fracture', 'Active'
UNION ALL SELECT 3061, 30, 16, 5, 'Outpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 0, 'Parkinson disease', 'Completed'
UNION ALL SELECT 3062, 13, 6, 1, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 3063, 42, 2, 3, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 1, 'Pericarditis', 'Completed'
UNION ALL SELECT 3064, 5, 14, 5, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 2, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 3065, 16, 4, 3, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 6, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 3066, 32, 3, 5, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 2, 'Epilepsy', 'Completed'
UNION ALL SELECT 3067, 48, 24, 7, 'Outpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 0, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3068, 12, 7, 2, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 2, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3069, 35, 12, 8, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 2, 'UTI', 'Completed'
UNION ALL SELECT 3070, 10, 12, 5, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 3071, 48, 22, 1, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 1, 'Chest pain', 'Completed'
UNION ALL SELECT 3072, 20, 21, 7, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), NULL, 6, 'Fracture', 'Active'
UNION ALL SELECT 3073, 29, 13, 4, 'Outpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 0, 'Hip fracture', 'Completed'
UNION ALL SELECT 3074, 20, 3, 5, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 3075, 50, 21, 6, 'Emergency', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 1, 'Lymphoma', 'Completed'
UNION ALL SELECT 3076, 31, 24, 8, 'Outpatient', DATEADD(DAY, -13, CURRENT_DATE()), DATEADD(DAY, -13, CURRENT_DATE()), 0, 'Anemia', 'Completed'
UNION ALL SELECT 3077, 7, 6, 7, 'Inpatient', DATEADD(DAY, -13, CURRENT_DATE()), NULL, 0, 'Fracture', 'Active'
UNION ALL SELECT 3078, 30, 23, 6, 'Emergency', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 3079, 1, 13, 3, 'Emergency', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 1, 'Myocardial infarction', 'Active'
UNION ALL SELECT 3080, 34, 23, 4, 'Outpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 0, 'ACL repair', 'Completed'
UNION ALL SELECT 3081, 21, 15, 7, 'Outpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -12, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 3082, 44, 19, 3, 'Emergency', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 2, 'Angina', 'Completed'
UNION ALL SELECT 3083, 25, 19, 7, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 0, 'Bronchiolitis', 'Active'
UNION ALL SELECT 3084, 6, 15, 4, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 7, 'Knee replacement', 'Active'
UNION ALL SELECT 3085, 39, 9, 7, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3086, 1, 23, 2, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 8, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3087, 8, 8, 8, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 7, 'COPD', 'Completed'
UNION ALL SELECT 3088, 48, 16, 5, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 7, 'Migraine', 'Completed'
UNION ALL SELECT 3089, 47, 22, 5, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), NULL, 2, 'Epilepsy', 'Active'
UNION ALL SELECT 3090, 17, 8, 5, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 1, 'Parkinson disease', 'Completed'
UNION ALL SELECT 3091, 6, 1, 8, 'Inpatient', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 2, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 3092, 46, 13, 4, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 3, 'Carpal tunnel', 'Active'
UNION ALL SELECT 3093, 4, 11, 1, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 3, 'Allergic reaction', 'Completed'
UNION ALL SELECT 3094, 1, 9, 1, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 2, 'Head injury', 'Completed'
UNION ALL SELECT 3095, 36, 2, 3, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 3096, 9, 3, 8, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 2, 'DVT', 'Active'
UNION ALL SELECT 3097, 9, 16, 1, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 2, 'Abdominal pain', 'Completed'
UNION ALL SELECT 3098, 40, 25, 5, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 1, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 3099, 49, 5, 8, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 1, 'Hypertension crisis', 'Completed'
UNION ALL SELECT 3100, 31, 9, 1, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 2, 'Laceration', 'Active'
UNION ALL SELECT 3101, 46, 18, 6, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 1, 'Lymphoma', 'Completed'
UNION ALL SELECT 3102, 8, 12, 3, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 3103, 37, 22, 5, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 14, 'Parkinson disease', 'Active'
UNION ALL SELECT 3104, 27, 3, 3, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 2, 'Myocardial infarction', 'Active'
UNION ALL SELECT 3105, 26, 12, 2, 'Emergency', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 2, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3106, 30, 23, 2, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 4, 'Severe trauma', 'Completed'
UNION ALL SELECT 3107, 22, 2, 1, 'Outpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -11, CURRENT_DATE()), 0, 'Overdose', 'Completed'
UNION ALL SELECT 3108, 14, 2, 3, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), NULL, 0, 'Arrhythmia', 'Active'
UNION ALL SELECT 3109, 36, 20, 2, 'Inpatient', DATEADD(DAY, -11, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 2, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3110, 2, 7, 2, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Septic shock', 'Completed'
UNION ALL SELECT 3111, 8, 10, 3, 'Outpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 0, 'Pericarditis', 'Completed'
UNION ALL SELECT 3112, 44, 20, 5, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), NULL, 0, 'Epilepsy', 'Active'
UNION ALL SELECT 3113, 33, 7, 6, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Lymphoma', 'Completed'
UNION ALL SELECT 3114, 6, 25, 7, 'Outpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -10, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 3115, 41, 14, 7, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3116, 42, 22, 4, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 3, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 3117, 19, 15, 2, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 6, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3118, 44, 10, 3, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), NULL, 2, 'Myocardial infarction', 'Active'
UNION ALL SELECT 3119, 3, 17, 2, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3120, 23, 9, 5, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), NULL, 3, 'Parkinson disease', 'Active'
UNION ALL SELECT 3121, 12, 6, 8, 'Inpatient', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Anemia', 'Completed'
UNION ALL SELECT 3122, 38, 24, 6, 'Emergency', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 2, 'Lymphoma', 'Completed'
UNION ALL SELECT 3123, 14, 6, 3, 'Emergency', DATEADD(DAY, -10, CURRENT_DATE()), NULL, 3, 'Atrial fibrillation', 'Active'
UNION ALL SELECT 3124, 1, 13, 1, 'Inpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 4, 'Fracture', 'Completed'
UNION ALL SELECT 3125, 43, 24, 7, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 3, 'Febrile seizure', 'Completed'
UNION ALL SELECT 3126, 20, 3, 7, 'Inpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 1, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3127, 2, 7, 4, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 2, 'Rotator cuff tear', 'Completed'
UNION ALL SELECT 3128, 6, 10, 4, 'Inpatient', DATEADD(DAY, -9, CURRENT_DATE()), NULL, 3, 'ACL repair', 'Active'
UNION ALL SELECT 3129, 10, 24, 3, 'Outpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 0, 'Pericarditis', 'Completed'
UNION ALL SELECT 3130, 38, 8, 8, 'Inpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 6, 'COPD', 'Completed'
UNION ALL SELECT 3131, 1, 4, 6, 'Outpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -9, CURRENT_DATE()), 0, 'Leukemia', 'Completed'
UNION ALL SELECT 3132, 32, 24, 7, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), NULL, 2, 'Febrile seizure', 'Active'
UNION ALL SELECT 3133, 32, 17, 7, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 2, 'Febrile seizure', 'Completed'
UNION ALL SELECT 3134, 34, 1, 1, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 3135, 31, 4, 7, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 2, 'Dehydration', 'Completed'
UNION ALL SELECT 3136, 11, 10, 1, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 3, 'Allergic reaction', 'Completed'
UNION ALL SELECT 3137, 39, 23, 6, 'Inpatient', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 7, 'Leukemia', 'Completed'
UNION ALL SELECT 3138, 27, 22, 7, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 3139, 45, 24, 5, 'Emergency', DATEADD(DAY, -9, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 1, 'Stroke', 'Completed'
UNION ALL SELECT 3140, 27, 16, 2, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 3, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3141, 17, 12, 6, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 6, 'Leukemia', 'Completed'
UNION ALL SELECT 3142, 5, 11, 1, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 1, 'Seizure', 'Completed'
UNION ALL SELECT 3143, 17, 11, 8, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 3, 'DVT', 'Completed'
UNION ALL SELECT 3144, 45, 17, 3, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 2, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 3145, 7, 20, 2, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, --2, CURRENT_DATE()), 10, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3146, 33, 4, 1, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 3147, 46, 15, 5, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 1, 'Neuropathy', 'Completed'
UNION ALL SELECT 3148, 22, 5, 6, 'Outpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 0, 'Breast cancer', 'Completed'
UNION ALL SELECT 3149, 50, 25, 7, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 6, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3150, 6, 9, 3, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 3, 'Angina', 'Completed'
UNION ALL SELECT 3151, 49, 25, 3, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 2, 'Valve disease', 'Completed'
UNION ALL SELECT 3152, 30, 17, 7, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), NULL, 2, 'Croup', 'Active'
UNION ALL SELECT 3153, 46, 17, 1, 'Inpatient', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 2, 'Fracture', 'Completed'
UNION ALL SELECT 3154, 28, 2, 3, 'Emergency', DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 3, 'Valve disease', 'Completed'
UNION ALL SELECT 3155, 41, 23, 1, 'Outpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 0, 'Head injury', 'Completed'
UNION ALL SELECT 3156, 47, 24, 5, 'Outpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), 0, 'Multiple sclerosis', 'Completed'
UNION ALL SELECT 3157, 34, 20, 5, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 1, 'Epilepsy', 'Completed'
UNION ALL SELECT 3158, 45, 12, 8, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), NULL, 1, 'Anemia', 'Active'
UNION ALL SELECT 3159, 25, 24, 6, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Leukemia', 'Completed'
UNION ALL SELECT 3160, 33, 18, 2, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 5, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3161, 35, 19, 1, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 3162, 47, 2, 2, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), NULL, 3, 'Multi-organ failure', 'Active'
UNION ALL SELECT 3163, 29, 10, 2, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3164, 23, 10, 4, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 3165, 34, 24, 7, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3166, 30, 4, 6, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), NULL, 1, 'Lung cancer', 'Active'
UNION ALL SELECT 3167, 9, 16, 7, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3168, 17, 19, 7, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 3, 'Dehydration', 'Completed'
UNION ALL SELECT 3169, 47, 14, 8, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 1, 'Diabetes management', 'Completed'
UNION ALL SELECT 3170, 46, 17, 3, 'Emergency', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 1, 'Atrial fibrillation', 'Completed'
UNION ALL SELECT 3171, 8, 20, 6, 'Inpatient', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 1, 'Pancreatic cancer', 'Completed'
UNION ALL SELECT 3172, 8, 12, 3, 'Outpatient', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 0, 'Arrhythmia', 'Completed'
UNION ALL SELECT 3173, 2, 5, 8, 'Emergency', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 3174, 12, 24, 4, 'Inpatient', DATEADD(DAY, -6, CURRENT_DATE()), NULL, 3, 'Rotator cuff tear', 'Active'
UNION ALL SELECT 3175, 27, 16, 1, 'Emergency', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 2, 'Overdose', 'Completed'
UNION ALL SELECT 3176, 47, 20, 8, 'Emergency', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 2, 'Diabetes management', 'Completed'
UNION ALL SELECT 3177, 10, 24, 8, 'Inpatient', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 4, 'DVT', 'Completed'
UNION ALL SELECT 3178, 15, 13, 7, 'Emergency', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 2, 'Appendicitis', 'Completed'
UNION ALL SELECT 3179, 11, 23, 2, 'Inpatient', DATEADD(DAY, -6, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 5, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3180, 42, 18, 2, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 4, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3181, 37, 17, 1, 'Emergency', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 1, 'Allergic reaction', 'Active'
UNION ALL SELECT 3182, 2, 9, 3, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 5, 'Myocardial infarction', 'Completed'
UNION ALL SELECT 3183, 6, 18, 8, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 0, 'DVT', 'Active'
UNION ALL SELECT 3184, 22, 14, 1, 'Emergency', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 2, 'Laceration', 'Completed'
UNION ALL SELECT 3185, 8, 4, 2, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 1, 'Cardiac arrest recovery', 'Completed'
UNION ALL SELECT 3186, 10, 10, 2, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), NULL, 0, 'Post-surgical monitoring', 'Active'
UNION ALL SELECT 3187, 12, 1, 6, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 2, 'Leukemia', 'Completed'
UNION ALL SELECT 3188, 21, 9, 7, 'Outpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 0, 'Dehydration', 'Completed'
UNION ALL SELECT 3189, 13, 8, 1, 'Emergency', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 3, 'Overdose', 'Completed'
UNION ALL SELECT 3190, 18, 2, 2, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 2, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3191, 41, 8, 7, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, --5, CURRENT_DATE()), 10, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3192, 49, 18, 4, 'Emergency', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 2, 'Carpal tunnel', 'Completed'
UNION ALL SELECT 3193, 10, 12, 4, 'Outpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -5, CURRENT_DATE()), 0, 'Ankle fracture', 'Completed'
UNION ALL SELECT 3194, 36, 15, 7, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 3, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3195, 42, 6, 5, 'Inpatient', DATEADD(DAY, -5, CURRENT_DATE()), DATEADD(DAY, --3, CURRENT_DATE()), 8, 'Stroke', 'Completed'
UNION ALL SELECT 3196, 23, 21, 7, 'Emergency', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 1, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3197, 20, 3, 2, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, --2, CURRENT_DATE()), 6, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3198, 28, 7, 5, 'Emergency', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 3, 'Parkinson disease', 'Completed'
UNION ALL SELECT 3199, 49, 23, 5, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 4, 'Migraine', 'Completed'
UNION ALL SELECT 3200, 30, 20, 4, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 4, 'Spinal stenosis', 'Completed'
UNION ALL SELECT 3201, 39, 16, 1, 'Outpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 0, 'Chest pain', 'Completed'
UNION ALL SELECT 3202, 36, 23, 7, 'Emergency', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 1, 'Fracture', 'Completed'
UNION ALL SELECT 3203, 35, 1, 2, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 1, 'Severe trauma', 'Completed'
UNION ALL SELECT 3204, 39, 12, 7, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 5, 'Dehydration', 'Completed'
UNION ALL SELECT 3205, 8, 15, 1, 'Outpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 0, 'Shortness of breath', 'Completed'
UNION ALL SELECT 3206, 48, 1, 4, 'Inpatient', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, --4, CURRENT_DATE()), 8, 'ACL repair', 'Completed'
UNION ALL SELECT 3207, 40, 21, 2, 'Emergency', DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 2, 'Multi-organ failure', 'Completed'
UNION ALL SELECT 3208, 32, 23, 5, 'Emergency', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 3, 'TIA', 'Completed'
UNION ALL SELECT 3209, 37, 17, 5, 'Inpatient', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), 1, 'Migraine', 'Completed'
UNION ALL SELECT 3210, 5, 19, 3, 'Emergency', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 3, 'Chest pain evaluation', 'Completed'
UNION ALL SELECT 3211, 13, 22, 5, 'Outpatient', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 0, 'Stroke', 'Completed'
UNION ALL SELECT 3212, 44, 18, 5, 'Inpatient', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 2, 'Migraine', 'Completed'
UNION ALL SELECT 3213, 21, 14, 1, 'Emergency', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 2, 'Seizure', 'Completed'
UNION ALL SELECT 3214, 47, 8, 1, 'Emergency', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 2, 'Chest pain', 'Completed'
UNION ALL SELECT 3215, 13, 11, 7, 'Outpatient', DATEADD(DAY, -3, CURRENT_DATE()), DATEADD(DAY, -3, CURRENT_DATE()), 0, 'Asthma exacerbation', 'Completed'
UNION ALL SELECT 3216, 5, 8, 7, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 2, 'Bronchiolitis', 'Completed'
UNION ALL SELECT 3217, 2, 16, 2, 'Emergency', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 3, 'Post-surgical monitoring', 'Completed'
UNION ALL SELECT 3218, 16, 4, 5, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), NULL, 2, 'Migraine', 'Active'
UNION ALL SELECT 3219, 34, 8, 6, 'Emergency', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 1, 'Breast cancer', 'Completed'
UNION ALL SELECT 3220, 6, 2, 2, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, --5, CURRENT_DATE()), 7, 'Respiratory failure', 'Completed'
UNION ALL SELECT 3221, 4, 15, 3, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), NULL, 4, 'Heart failure', 'Active'
UNION ALL SELECT 3222, 36, 2, 1, 'Emergency', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 3, 'Abdominal pain', 'Completed'
UNION ALL SELECT 3223, 39, 22, 4, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 2, 'Ankle fracture', 'Completed'
UNION ALL SELECT 3224, 22, 21, 2, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 3, 'Severe trauma', 'Completed'
UNION ALL SELECT 3225, 7, 4, 4, 'Emergency', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 1, 'Hip fracture', 'Completed'
UNION ALL SELECT 3226, 41, 17, 3, 'Inpatient', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 3, 'Arrhythmia', 'Completed'
UNION ALL SELECT 3227, 9, 2, 4, 'Inpatient', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --2, CURRENT_DATE()), 3, 'Hip fracture', 'Completed'
UNION ALL SELECT 3228, 20, 19, 6, 'Emergency', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 2, 'Prostate cancer', 'Completed'
UNION ALL SELECT 3229, 24, 1, 5, 'Emergency', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, -0, CURRENT_DATE()), 1, 'Parkinson disease', 'Completed'
UNION ALL SELECT 3230, 28, 12, 1, 'Outpatient', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 0, 'Allergic reaction', 'Completed'
UNION ALL SELECT 3231, 5, 11, 4, 'Emergency', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 2, 'Knee replacement', 'Completed'
UNION ALL SELECT 3232, 38, 19, 6, 'Inpatient', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 2, 'Colon cancer', 'Completed'
UNION ALL SELECT 3233, 3, 16, 8, 'Outpatient', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, -1, CURRENT_DATE()), 0, 'COPD', 'Completed'
UNION ALL SELECT 3234, 30, 20, 4, 'Inpatient', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --4, CURRENT_DATE()), 5, 'Knee replacement', 'Completed'
UNION ALL SELECT 3235, 48, 13, 6, 'Inpatient', DATEADD(DAY, -1, CURRENT_DATE()), NULL, 6, 'Lung cancer', 'Active'
UNION ALL SELECT 3236, 5, 12, 1, 'Emergency', DATEADD(DAY, -1, CURRENT_DATE()), DATEADD(DAY, --1, CURRENT_DATE()), 2, 'Chest pain', 'Completed';


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
