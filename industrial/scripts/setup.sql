USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS INDUSTRIAL_HOL_WH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE;

CREATE OR REPLACE DATABASE INDUSTRIAL_HOL_DB;
CREATE OR REPLACE SCHEMA INDUSTRIAL_HOL_DB.OPERATIONS;
CREATE OR REPLACE SCHEMA INDUSTRIAL_HOL_DB.ENERGY;

CREATE OR REPLACE ROLE INDUSTRIAL_HOL_ROLE;
GRANT USAGE ON WAREHOUSE INDUSTRIAL_HOL_WH TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON DATABASE INDUSTRIAL_HOL_DB TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON ALL SCHEMAS IN DATABASE INDUSTRIAL_HOL_DB TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ROLE INDUSTRIAL_HOL_ROLE TO ROLE ACCOUNTADMIN;

USE DATABASE INDUSTRIAL_HOL_DB;
USE SCHEMA OPERATIONS;
USE WAREHOUSE INDUSTRIAL_HOL_WH;

CREATE OR REPLACE STAGE INDUSTRIAL_HOL_DB.OPERATIONS.PDF_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE STAGE INDUSTRIAL_HOL_DB.OPERATIONS.SEMANTIC_MODELS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.FACILITIES (
  FACILITY_ID INTEGER,
  FACILITY_NAME VARCHAR(100),
  LOCATION VARCHAR(100),
  FACILITY_TYPE VARCHAR(50),
  SQUARE_FOOTAGE INTEGER,
  YEAR_BUILT INTEGER,
  STATUS VARCHAR(20)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.FACILITIES VALUES
(1, 'Detroit Assembly Plant', 'Detroit, MI', 'Assembly', 450000, 2005, 'Active'),
(2, 'Houston Refinery Complex', 'Houston, TX', 'Processing', 620000, 1998, 'Active'),
(3, 'Chicago Distribution Hub', 'Chicago, IL', 'Warehouse', 280000, 2012, 'Active'),
(4, 'Phoenix Fabrication Center', 'Phoenix, AZ', 'Fabrication', 350000, 2015, 'Active'),
(5, 'Atlanta Packaging Facility', 'Atlanta, GA', 'Packaging', 180000, 2018, 'Active'),
(6, 'Seattle R&D Lab', 'Seattle, WA', 'Research', 95000, 2020, 'Active');

CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.PRODUCTION_LINES (
  LINE_ID INTEGER,
  LINE_NAME VARCHAR(100),
  FACILITY_ID INTEGER,
  PRODUCT_TYPE VARCHAR(50),
  CAPACITY_UNITS_PER_HOUR INTEGER,
  STATUS VARCHAR(20),
  LAST_CALIBRATION_DATE DATE
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.PRODUCTION_LINES
SELECT 1, 'Assembly Line A', 1, 'Automotive Parts', 120, 'Running', DATEADD(DAY, -38, CURRENT_DATE())
UNION ALL SELECT 2, 'Assembly Line B', 1, 'Automotive Parts', 100, 'Running', DATEADD(DAY, -61, CURRENT_DATE())
UNION ALL SELECT 3, 'Assembly Line C', 1, 'Heavy Equipment', 60, 'Maintenance', DATEADD(DAY, -102, CURRENT_DATE())
UNION ALL SELECT 4, 'Refinery Unit 1', 2, 'Chemical Processing', 500, 'Running', DATEADD(DAY, -21, CURRENT_DATE())
UNION ALL SELECT 5, 'Refinery Unit 2', 2, 'Chemical Processing', 500, 'Running', DATEADD(DAY, -25, CURRENT_DATE())
UNION ALL SELECT 6, 'Refinery Unit 3', 2, 'Polymer Production', 300, 'Idle', DATEADD(DAY, -128, CURRENT_DATE())
UNION ALL SELECT 7, 'Fab Line Alpha', 4, 'Metal Components', 200, 'Running', DATEADD(DAY, -12, CURRENT_DATE())
UNION ALL SELECT 8, 'Fab Line Beta', 4, 'Metal Components', 200, 'Running', DATEADD(DAY, -48, CURRENT_DATE())
UNION ALL SELECT 9, 'Pack Line 1', 5, 'Consumer Goods', 800, 'Running', DATEADD(DAY, -7, CURRENT_DATE())
UNION ALL SELECT 10, 'Pack Line 2', 5, 'Consumer Goods', 600, 'Running', DATEADD(DAY, -33, CURRENT_DATE())
UNION ALL SELECT 11, 'Pack Line 3', 5, 'Industrial Goods', 400, 'Maintenance', DATEADD(DAY, -87, CURRENT_DATE())
UNION ALL SELECT 12, 'R&D Prototype Line', 6, 'Prototypes', 20, 'Running', DATEADD(DAY, -4, CURRENT_DATE());


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.TECHNICIANS (
  TECHNICIAN_ID INTEGER,
  FIRST_NAME VARCHAR(50),
  LAST_NAME VARCHAR(50),
  FACILITY_ID INTEGER,
  SPECIALIZATION VARCHAR(50),
  CERTIFICATION_LEVEL VARCHAR(20),
  HIRE_DATE DATE,
  HOURLY_RATE NUMBER(6,2),
  STATUS VARCHAR(20)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.TECHNICIANS VALUES
(1, 'Marcus', 'Johnson', 1, 'Mechanical', 'Senior', '2012-03-15', 55.00, 'Active'),
(2, 'Sarah', 'Chen', 1, 'Electrical', 'Senior', '2014-07-01', 58.00, 'Active'),
(3, 'David', 'Williams', 1, 'PLC/Automation', 'Lead', '2010-01-20', 65.00, 'Active'),
(4, 'Maria', 'Garcia', 2, 'Chemical Systems', 'Senior', '2015-05-10', 60.00, 'Active'),
(5, 'James', 'Brown', 2, 'Mechanical', 'Junior', '2022-09-01', 38.00, 'Active'),
(6, 'Linda', 'Martinez', 2, 'Instrumentation', 'Senior', '2013-11-15', 57.00, 'Active'),
(7, 'Robert', 'Taylor', 2, 'Electrical', 'Lead', '2008-06-30', 68.00, 'Active'),
(8, 'Jennifer', 'Anderson', 3, 'HVAC', 'Senior', '2016-02-28', 52.00, 'Active'),
(9, 'Michael', 'Thomas', 3, 'Mechanical', 'Junior', '2023-04-15', 36.00, 'Active'),
(10, 'Patricia', 'Jackson', 4, 'CNC/Machining', 'Senior', '2017-08-20', 56.00, 'Active'),
(11, 'Christopher', 'White', 4, 'Welding', 'Lead', '2011-10-05', 62.00, 'Active'),
(12, 'Amanda', 'Harris', 4, 'Mechanical', 'Senior', '2018-01-12', 54.00, 'Active'),
(13, 'Daniel', 'Clark', 5, 'Packaging Systems', 'Senior', '2019-06-01', 50.00, 'Active'),
(14, 'Michelle', 'Lewis', 5, 'Electrical', 'Junior', '2024-01-15', 35.00, 'Active'),
(15, 'Kevin', 'Robinson', 5, 'Mechanical', 'Senior', '2016-09-10', 53.00, 'Active'),
(16, 'Laura', 'Walker', 6, 'Electronics', 'Lead', '2020-03-20', 70.00, 'Active'),
(17, 'Brian', 'Hall', 1, 'Hydraulics', 'Senior', '2015-12-01', 55.00, 'On Leave'),
(18, 'Stephanie', 'Allen', 2, 'Mechanical', 'Senior', '2017-04-15', 54.00, 'Active'),
(19, 'Andrew', 'Young', 4, 'Electrical', 'Junior', '2023-08-01', 37.00, 'Active'),
(20, 'Nicole', 'King', 3, 'Conveyor Systems', 'Senior', '2018-11-20', 51.00, 'Active');

CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.EQUIPMENT (
  EQUIPMENT_ID INTEGER,
  EQUIPMENT_NAME VARCHAR(100),
  EQUIPMENT_TYPE VARCHAR(50),
  FACILITY_ID INTEGER,
  LINE_ID INTEGER,
  MANUFACTURER VARCHAR(100),
  MODEL VARCHAR(50),
  INSTALL_DATE DATE,
  NEXT_SERVICE_DATE DATE,
  SERVICE_INTERVAL_DAYS INTEGER,
  STATUS VARCHAR(20),
  CRITICALITY VARCHAR(10),
  REPLACEMENT_COST NUMBER(12,2)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.EQUIPMENT
SELECT 1, 'Robotic Arm RA-101', 'Robotic Arm', 1, 1, 'FANUC', 'M-20iD', '2019-06-15', DATEADD(DAY, -12, CURRENT_DATE()), 90, 'Operational', 'High', 85000.00
UNION ALL SELECT 2, 'Robotic Arm RA-102', 'Robotic Arm', 1, 1, 'FANUC', 'M-20iD', '2019-06-15', DATEADD(DAY, 23, CURRENT_DATE()), 90, 'Operational', 'High', 85000.00
UNION ALL SELECT 3, 'CNC Mill MC-201', 'CNC Machine', 1, 2, 'Haas', 'VF-4SS', '2018-03-20', DATEADD(DAY, -33, CURRENT_DATE()), 60, 'Overdue', 'High', 125000.00
UNION ALL SELECT 4, 'CNC Lathe CL-202', 'CNC Machine', 1, 2, 'Haas', 'ST-30Y', '2020-01-10', DATEADD(DAY, 18, CURRENT_DATE()), 60, 'Operational', 'High', 110000.00
UNION ALL SELECT 5, 'Hydraulic Press HP-301', 'Press', 1, 3, 'Beckwood', 'TMP-200', '2015-09-01', DATEADD(DAY, -66, CURRENT_DATE()), 120, 'Overdue', 'Critical', 250000.00
UNION ALL SELECT 6, 'Conveyor Belt CB-101', 'Conveyor', 1, 1, 'Dorner', '3200 Series', '2021-04-20', DATEADD(DAY, 59, CURRENT_DATE()), 180, 'Operational', 'Medium', 35000.00
UNION ALL SELECT 7, 'Pump Station PS-401', 'Pump', 2, 4, 'Grundfos', 'CR 95', '2016-02-28', DATEADD(DAY, 6, CURRENT_DATE()), 90, 'Operational', 'Critical', 45000.00
UNION ALL SELECT 8, 'Pump Station PS-402', 'Pump', 2, 4, 'Grundfos', 'CR 95', '2016-02-28', DATEADD(DAY, -38, CURRENT_DATE()), 90, 'Overdue', 'Critical', 45000.00
UNION ALL SELECT 9, 'Heat Exchanger HX-501', 'Heat Exchanger', 2, 5, 'Alfa Laval', 'T50-MFG', '2014-08-10', DATEADD(DAY, 110, CURRENT_DATE()), 365, 'Operational', 'High', 180000.00
UNION ALL SELECT 10, 'Compressor CP-601', 'Compressor', 2, 4, 'Atlas Copco', 'GA 160', '2017-11-15', DATEADD(DAY, -7, CURRENT_DATE()), 120, 'Operational', 'High', 92000.00
UNION ALL SELECT 11, 'Reactor Vessel RV-701', 'Reactor', 2, 5, 'Pfaudler', 'RA Series', '2012-05-20', DATEADD(DAY, 28, CURRENT_DATE()), 180, 'Operational', 'Critical', 350000.00
UNION ALL SELECT 12, 'Boiler BL-801', 'Boiler', 2, NULL, 'Cleaver-Brooks', 'CB 700', '2010-03-01', DATEADD(DAY, -82, CURRENT_DATE()), 180, 'Overdue', 'Critical', 420000.00
UNION ALL SELECT 13, 'Forklift FK-101', 'Forklift', 3, NULL, 'Toyota', '8FBE20U', '2022-01-15', DATEADD(DAY, 84, CURRENT_DATE()), 180, 'Operational', 'Medium', 32000.00
UNION ALL SELECT 14, 'Forklift FK-102', 'Forklift', 3, NULL, 'Toyota', '8FBE20U', '2022-01-15', DATEADD(DAY, 84, CURRENT_DATE()), 180, 'Operational', 'Medium', 32000.00
UNION ALL SELECT 15, 'Conveyor System CS-301', 'Conveyor', 3, NULL, 'Hytrol', 'ProSort 400', '2020-06-10', DATEADD(DAY, 49, CURRENT_DATE()), 120, 'Operational', 'High', 75000.00
UNION ALL SELECT 16, 'Laser Cutter LC-401', 'Laser Cutter', 4, 7, 'Trumpf', 'TruLaser 5030', '2021-09-01', DATEADD(DAY, -52, CURRENT_DATE()), 60, 'Overdue', 'High', 280000.00
UNION ALL SELECT 17, 'Laser Cutter LC-402', 'Laser Cutter', 4, 8, 'Trumpf', 'TruLaser 5030', '2021-09-01', DATEADD(DAY, 40, CURRENT_DATE()), 60, 'Operational', 'High', 280000.00
UNION ALL SELECT 18, 'Welding Robot WR-501', 'Welding Robot', 4, 7, 'Lincoln Electric', 'Flextec 650X', '2020-03-15', DATEADD(DAY, -7, CURRENT_DATE()), 90, 'Operational', 'High', 95000.00
UNION ALL SELECT 19, 'Press Brake PB-601', 'Press Brake', 4, 8, 'Amada', 'HFE3i', '2019-07-20', DATEADD(DAY, 89, CURRENT_DATE()), 120, 'Operational', 'Medium', 150000.00
UNION ALL SELECT 20, 'Packaging Machine PM-101', 'Packaging', 5, 9, 'Bosch', 'CUC 3001', '2022-05-01', DATEADD(DAY, 9, CURRENT_DATE()), 90, 'Operational', 'High', 120000.00
UNION ALL SELECT 21, 'Packaging Machine PM-102', 'Packaging', 5, 10, 'Bosch', 'CUC 3001', '2022-05-01', DATEADD(DAY, -21, CURRENT_DATE()), 90, 'Overdue', 'High', 120000.00
UNION ALL SELECT 22, 'Shrink Wrapper SW-201', 'Packaging', 5, 9, 'Cryovac', 'VS70TT', '2023-02-10', DATEADD(DAY, 110, CURRENT_DATE()), 180, 'Operational', 'Medium', 65000.00
UNION ALL SELECT 23, 'Labeling Machine LM-301', 'Labeling', 5, 10, 'Videojet', '7510', '2023-06-15', DATEADD(DAY, 54, CURRENT_DATE()), 120, 'Operational', 'Low', 28000.00
UNION ALL SELECT 24, 'AGV Transport AGV-101', 'AGV', 3, NULL, 'KUKA', 'KMP 1500', '2023-11-01', DATEADD(DAY, 9, CURRENT_DATE()), 180, 'Operational', 'Medium', 95000.00
UNION ALL SELECT 25, 'Quality Scanner QS-101', 'Inspection', 4, 7, 'Keyence', 'XG-X Series', '2022-08-20', DATEADD(DAY, 120, CURRENT_DATE()), 365, 'Operational', 'High', 45000.00
UNION ALL SELECT 26, 'Cooling Tower CT-901', 'HVAC', 2, NULL, 'Marley', 'NC Series', '2008-04-15', DATEADD(DAY, -7, CURRENT_DATE()), 180, 'Operational', 'High', 220000.00
UNION ALL SELECT 27, '3D Printer PR-101', 'Additive Manufacturing', 6, 12, 'Stratasys', 'F900', '2023-01-10', DATEADD(DAY, 79, CURRENT_DATE()), 180, 'Operational', 'Medium', 350000.00
UNION ALL SELECT 28, 'CNC Router CR-701', 'CNC Machine', 4, 8, 'Biesse', 'Rover A', '2020-11-20', DATEADD(DAY, 28, CURRENT_DATE()), 90, 'Operational', 'Medium', 95000.00
UNION ALL SELECT 29, 'Paint Booth PB-801', 'Finishing', 1, NULL, 'Global Finishing', 'Spray Booth', '2017-06-01', DATEADD(DAY, 40, CURRENT_DATE()), 365, 'Operational', 'Medium', 75000.00
UNION ALL SELECT 30, 'Air Handler AH-101', 'HVAC', 1, NULL, 'Trane', 'IntelliPak', '2015-10-15', DATEADD(DAY, -7, CURRENT_DATE()), 180, 'Operational', 'Medium', 48000.00
UNION ALL SELECT 31, 'Generator GN-101', 'Power', 2, NULL, 'Caterpillar', 'C32', '2013-09-01', DATEADD(DAY, -52, CURRENT_DATE()), 180, 'Overdue', 'Critical', 520000.00
UNION ALL SELECT 32, 'Transformer TR-201', 'Power', 1, NULL, 'ABB', 'Distribution', '2011-04-20', DATEADD(DAY, 181, CURRENT_DATE()), 365, 'Operational', 'Critical', 180000.00
UNION ALL SELECT 33, 'Water Treatment WT-101', 'Treatment', 2, NULL, 'Evoqua', 'MEMCOR', '2016-07-15', DATEADD(DAY, 84, CURRENT_DATE()), 365, 'Operational', 'High', 135000.00
UNION ALL SELECT 34, 'Overhead Crane OC-101', 'Crane', 1, NULL, 'Konecranes', 'CXT', '2014-12-01', DATEADD(DAY, 40, CURRENT_DATE()), 365, 'Operational', 'High', 95000.00
UNION ALL SELECT 35, 'Vacuum Pump VP-101', 'Pump', 4, 7, 'Busch', 'R5', '2021-03-10', DATEADD(DAY, -43, CURRENT_DATE()), 90, 'Overdue', 'Medium', 18000.00;


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.WORK_ORDERS (
  WORK_ORDER_ID INTEGER,
  EQUIPMENT_ID INTEGER,
  TECHNICIAN_ID INTEGER,
  FACILITY_ID INTEGER,
  ORDER_TYPE VARCHAR(30),
  PRIORITY VARCHAR(10),
  DESCRIPTION VARCHAR(300),
  CREATED_DATE DATE,
  SCHEDULED_DATE DATE,
  COMPLETED_DATE DATE,
  STATUS VARCHAR(20),
  ESTIMATED_HOURS NUMBER(5,1),
  ACTUAL_HOURS NUMBER(5,1),
  PARTS_COST NUMBER(10,2),
  LABOR_COST NUMBER(10,2)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.WORK_ORDERS
SELECT 1, 1, 3, 1, 'Preventive', 'Medium', 'Quarterly lubrication and calibration of robotic arm', DATEADD(DAY, -107, CURRENT_DATE()), DATEADD(DAY, -102, CURRENT_DATE()), DATEADD(DAY, -102, CURRENT_DATE()), 'Completed', 4.0, 3.5, 250.00, 227.50
UNION ALL SELECT 2, 3, 1, 1, 'Preventive', 'High', 'Bi-monthly spindle inspection and alignment', DATEADD(DAY, -97, CURRENT_DATE()), DATEADD(DAY, -92, CURRENT_DATE()), NULL, 'Overdue', 6.0, NULL, NULL, NULL
UNION ALL SELECT 3, 5, 1, 1, 'Corrective', 'Critical', 'Hydraulic seal replacement - pressure loss detected', DATEADD(DAY, -90, CURRENT_DATE()), DATEADD(DAY, -89, CURRENT_DATE()), DATEADD(DAY, -88, CURRENT_DATE()), 'Completed', 8.0, 10.0, 1800.00, 550.00
UNION ALL SELECT 4, 7, 4, 2, 'Preventive', 'High', 'Pump impeller inspection and bearing check', DATEADD(DAY, -84, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -80, CURRENT_DATE()), 'Completed', 5.0, 4.5, 320.00, 270.00
UNION ALL SELECT 5, 8, 6, 2, 'Corrective', 'Critical', 'Pump cavitation - emergency repair', DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -76, CURRENT_DATE()), DATEADD(DAY, -75, CURRENT_DATE()), 'Completed', 6.0, 8.0, 2200.00, 456.00
UNION ALL SELECT 6, 10, 7, 2, 'Preventive', 'High', 'Compressor oil change and valve inspection', DATEADD(DAY, -71, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), 'Completed', 4.0, 4.0, 450.00, 272.00
UNION ALL SELECT 7, 12, 18, 2, 'Corrective', 'Critical', 'Boiler tube leak - emergency shutdown required', DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -63, CURRENT_DATE()), DATEADD(DAY, -61, CURRENT_DATE()), 'Completed', 16.0, 22.0, 8500.00, 1188.00
UNION ALL SELECT 8, 16, 10, 4, 'Preventive', 'High', 'Laser optics cleaning and realignment', DATEADD(DAY, -56, CURRENT_DATE()), DATEADD(DAY, -52, CURRENT_DATE()), NULL, 'Overdue', 3.0, NULL, NULL, NULL
UNION ALL SELECT 9, 15, 20, 3, 'Preventive', 'Medium', 'Conveyor belt tension and roller inspection', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), 'Completed', 3.0, 2.5, 180.00, 127.50
UNION ALL SELECT 10, 20, 13, 5, 'Preventive', 'High', 'Quarterly packaging machine calibration', DATEADD(DAY, -48, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), DATEADD(DAY, -45, CURRENT_DATE()), 'Completed', 4.0, 4.0, 200.00, 200.00
UNION ALL SELECT 11, 21, 15, 5, 'Corrective', 'High', 'Packaging machine jam - conveyor belt misalignment', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -42, CURRENT_DATE()), 'Completed', 3.0, 4.5, 350.00, 238.50
UNION ALL SELECT 12, 2, 3, 1, 'Preventive', 'Medium', 'Robotic arm joint calibration', DATEADD(DAY, -41, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), 'Completed', 4.0, 3.0, 150.00, 195.00
UNION ALL SELECT 13, 18, 11, 4, 'Preventive', 'Medium', 'Welding robot tip replacement and calibration', DATEADD(DAY, -38, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), DATEADD(DAY, -35, CURRENT_DATE()), 'Completed', 2.0, 2.0, 420.00, 124.00
UNION ALL SELECT 14, 9, 4, 2, 'Preventive', 'High', 'Annual heat exchanger cleaning and inspection', DATEADD(DAY, -33, CURRENT_DATE()), DATEADD(DAY, -28, CURRENT_DATE()), DATEADD(DAY, -27, CURRENT_DATE()), 'Completed', 12.0, 14.0, 1500.00, 840.00
UNION ALL SELECT 15, 26, 7, 2, 'Preventive', 'Medium', 'Cooling tower fill media inspection', DATEADD(DAY, -25, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), DATEADD(DAY, -21, CURRENT_DATE()), 'Completed', 6.0, 5.0, 800.00, 340.00
UNION ALL SELECT 16, 31, 7, 2, 'Preventive', 'Critical', 'Generator load bank test and oil analysis', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -48, CURRENT_DATE()), NULL, 'Overdue', 8.0, NULL, NULL, NULL
UNION ALL SELECT 17, 4, 2, 1, 'Corrective', 'High', 'CNC lathe spindle vibration anomaly', DATEADD(DAY, -20, CURRENT_DATE()), DATEADD(DAY, -19, CURRENT_DATE()), DATEADD(DAY, -18, CURRENT_DATE()), 'Completed', 6.0, 7.0, 1200.00, 406.00
UNION ALL SELECT 18, 35, 12, 4, 'Preventive', 'Medium', 'Vacuum pump oil change and seal check', DATEADD(DAY, -43, CURRENT_DATE()), DATEADD(DAY, -41, CURRENT_DATE()), NULL, 'Overdue', 2.0, NULL, NULL, NULL
UNION ALL SELECT 19, 11, 4, 2, 'Preventive', 'Critical', 'Reactor vessel inspection and pressure test', DATEADD(DAY, -12, CURRENT_DATE()), DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -6, CURRENT_DATE()), 'Completed', 16.0, 18.0, 2800.00, 1080.00
UNION ALL SELECT 20, 24, 9, 3, 'Corrective', 'Medium', 'AGV navigation sensor recalibration', DATEADD(DAY, -10, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), DATEADD(DAY, -8, CURRENT_DATE()), 'Completed', 3.0, 3.0, 650.00, 108.00
UNION ALL SELECT 21, 5, 1, 1, 'Preventive', 'Critical', 'Hydraulic press annual certification', DATEADD(DAY, -80, CURRENT_DATE()), DATEADD(DAY, -66, CURRENT_DATE()), NULL, 'Overdue', 12.0, NULL, NULL, NULL
UNION ALL SELECT 22, 8, 6, 2, 'Preventive', 'Critical', 'Pump station quarterly service', DATEADD(DAY, -52, CURRENT_DATE()), DATEADD(DAY, -38, CURRENT_DATE()), NULL, 'Overdue', 5.0, NULL, NULL, NULL
UNION ALL SELECT 23, 27, 16, 6, 'Preventive', 'Medium', '3D printer nozzle replacement and calibration', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), DATEADD(DAY, -4, CURRENT_DATE()), 'Completed', 2.0, 1.5, 800.00, 105.00
UNION ALL SELECT 24, 6, 3, 1, 'Corrective', 'Low', 'Conveyor belt tracking adjustment', DATEADD(DAY, -4, CURRENT_DATE()), CURRENT_DATE(), NULL, 'Scheduled', 2.0, NULL, NULL, NULL
UNION ALL SELECT 25, 30, 2, 1, 'Preventive', 'Medium', 'Air handler filter replacement and coil cleaning', DATEADD(DAY, -7, CURRENT_DATE()), DATEADD(DAY, -2, CURRENT_DATE()), NULL, 'Scheduled', 4.0, NULL, NULL, NULL
UNION ALL SELECT 26, 17, 19, 4, 'Preventive', 'High', 'Laser cutter lens cleaning and gas flow check', DATEADD(DAY, -2, CURRENT_DATE()), DATEADD(DAY, 3, CURRENT_DATE()), NULL, 'Scheduled', 3.0, NULL, NULL, NULL
UNION ALL SELECT 27, 19, 12, 4, 'Preventive', 'Medium', 'Press brake ram alignment verification', CURRENT_DATE(), DATEADD(DAY, 6, CURRENT_DATE()), NULL, 'Scheduled', 4.0, NULL, NULL, NULL
UNION ALL SELECT 28, 34, 1, 1, 'Preventive', 'High', 'Overhead crane annual load test', DATEADD(DAY, 9, CURRENT_DATE()), DATEADD(DAY, 13, CURRENT_DATE()), NULL, 'Scheduled', 8.0, NULL, NULL, NULL;


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.DOWNTIME_EVENTS (
  EVENT_ID INTEGER,
  EQUIPMENT_ID INTEGER,
  FACILITY_ID INTEGER,
  LINE_ID INTEGER,
  EVENT_TYPE VARCHAR(30),
  CAUSE VARCHAR(100),
  START_TIME TIMESTAMP,
  END_TIME TIMESTAMP,
  DURATION_HOURS NUMBER(6,1),
  PRODUCTION_LOSS_UNITS INTEGER,
  COST_IMPACT NUMBER(10,2)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.DOWNTIME_EVENTS
SELECT 1, 5, 1, 3, 'Unplanned', 'Hydraulic seal failure', DATEADD(SECOND, 21600, DATEADD(DAY, -90, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 50400, DATEADD(DAY, -88, CURRENT_DATE())::TIMESTAMP_NTZ), 56.0, 3360, 168000.00
UNION ALL SELECT 2, 8, 2, 4, 'Unplanned', 'Pump cavitation damage', DATEADD(SECOND, 9000, DATEADD(DAY, -76, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 64800, DATEADD(DAY, -75, CURRENT_DATE())::TIMESTAMP_NTZ), 39.5, 19750, 98750.00
UNION ALL SELECT 3, 12, 2, NULL, 'Unplanned', 'Boiler tube leak', DATEADD(SECOND, 39600, DATEADD(DAY, -63, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 57600, DATEADD(DAY, -61, CURRENT_DATE())::TIMESTAMP_NTZ), 53.0, 0, 245000.00
UNION ALL SELECT 4, 3, 1, 2, 'Planned', 'Scheduled spindle maintenance', DATEADD(SECOND, 21600, DATEADD(DAY, -92, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 50400, DATEADD(DAY, -92, CURRENT_DATE())::TIMESTAMP_NTZ), 8.0, 800, 8000.00
UNION ALL SELECT 5, 21, 5, 10, 'Unplanned', 'Conveyor belt jam', DATEADD(SECOND, 33300, DATEADD(DAY, -43, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 25200, DATEADD(DAY, -42, CURRENT_DATE())::TIMESTAMP_NTZ), 21.8, 13050, 39150.00
UNION ALL SELECT 6, 16, 4, 7, 'Planned', 'Laser optics maintenance', DATEADD(SECOND, 21600, DATEADD(DAY, -52, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 43200, DATEADD(DAY, -52, CURRENT_DATE())::TIMESTAMP_NTZ), 6.0, 1200, 6000.00
UNION ALL SELECT 7, 4, 1, 2, 'Unplanned', 'Spindle vibration anomaly', DATEADD(SECOND, 50400, DATEADD(DAY, -20, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 36000, DATEADD(DAY, -18, CURRENT_DATE())::TIMESTAMP_NTZ), 44.0, 4400, 44000.00
UNION ALL SELECT 8, 1, 1, 1, 'Planned', 'Quarterly calibration', DATEADD(SECOND, 21600, DATEADD(DAY, -102, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 36000, DATEADD(DAY, -102, CURRENT_DATE())::TIMESTAMP_NTZ), 4.0, 480, 2400.00
UNION ALL SELECT 9, 11, 2, 5, 'Planned', 'Reactor vessel inspection', DATEADD(SECOND, 21600, DATEADD(DAY, -7, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 64800, DATEADD(DAY, -6, CURRENT_DATE())::TIMESTAMP_NTZ), 36.0, 18000, 90000.00
UNION ALL SELECT 10, 31, 2, NULL, 'Unplanned', 'Generator failure during storm', DATEADD(SECOND, 79200, DATEADD(DAY, -53, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 28800, DATEADD(DAY, -52, CURRENT_DATE())::TIMESTAMP_NTZ), 10.0, 0, 125000.00
UNION ALL SELECT 11, 10, 2, 4, 'Planned', 'Compressor oil change', DATEADD(SECOND, 21600, DATEADD(DAY, -66, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 36000, DATEADD(DAY, -66, CURRENT_DATE())::TIMESTAMP_NTZ), 4.0, 2000, 5000.00
UNION ALL SELECT 12, 20, 5, 9, 'Planned', 'Quarterly calibration', DATEADD(SECOND, 21600, DATEADD(DAY, -45, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 36000, DATEADD(DAY, -45, CURRENT_DATE())::TIMESTAMP_NTZ), 4.0, 3200, 4800.00
UNION ALL SELECT 13, 15, 3, NULL, 'Unplanned', 'Roller bearing failure', DATEADD(SECOND, 41400, DATEADD(DAY, -33, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 57600, DATEADD(DAY, -33, CURRENT_DATE())::TIMESTAMP_NTZ), 4.5, 0, 12000.00
UNION ALL SELECT 14, 24, 3, NULL, 'Unplanned', 'Navigation sensor drift', DATEADD(SECOND, 28800, DATEADD(DAY, -10, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 43200, DATEADD(DAY, -8, CURRENT_DATE())::TIMESTAMP_NTZ), 52.0, 0, 8500.00
UNION ALL SELECT 15, 18, 4, 7, 'Planned', 'Welding tip replacement', DATEADD(SECOND, 21600, DATEADD(DAY, -35, CURRENT_DATE())::TIMESTAMP_NTZ), DATEADD(SECOND, 28800, DATEADD(DAY, -35, CURRENT_DATE())::TIMESTAMP_NTZ), 2.0, 400, 1200.00;


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.SPARE_PARTS (
  PART_ID INTEGER,
  PART_NAME VARCHAR(100),
  PART_NUMBER VARCHAR(30),
  CATEGORY VARCHAR(50),
  COMPATIBLE_EQUIPMENT_TYPE VARCHAR(50),
  UNIT_COST NUMBER(10,2),
  QTY_ON_HAND INTEGER,
  REORDER_POINT INTEGER,
  LEAD_TIME_DAYS INTEGER,
  SUPPLIER_NAME VARCHAR(100)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.SPARE_PARTS VALUES
(1, 'Hydraulic Seal Kit', 'HSK-200', 'Seals', 'Press', 450.00, 3, 5, 14, 'Parker Hannifin'),
(2, 'Spindle Bearing Set', 'SBS-VF4', 'Bearings', 'CNC Machine', 680.00, 2, 3, 21, 'SKF Group'),
(3, 'Pump Impeller Assembly', 'PIA-CR95', 'Rotating Equipment', 'Pump', 1200.00, 1, 2, 28, 'Grundfos'),
(4, 'Robot Joint Motor', 'RJM-M20', 'Motors', 'Robotic Arm', 3500.00, 1, 1, 35, 'FANUC'),
(5, 'Conveyor Belt Section', 'CBS-3200', 'Belts', 'Conveyor', 850.00, 4, 3, 10, 'Dorner'),
(6, 'Laser Optics Kit', 'LOK-5030', 'Optics', 'Laser Cutter', 2800.00, 1, 2, 42, 'Trumpf'),
(7, 'Boiler Tube Bundle', 'BTB-700', 'Tubes', 'Boiler', 5500.00, 0, 1, 60, 'Cleaver-Brooks'),
(8, 'Compressor Oil Filter', 'COF-GA160', 'Filters', 'Compressor', 85.00, 12, 6, 7, 'Atlas Copco'),
(9, 'Welding Wire Spool', 'WWS-650X', 'Consumables', 'Welding Robot', 120.00, 25, 10, 5, 'Lincoln Electric'),
(10, 'PLC Control Module', 'PCM-S7', 'Electronics', 'PLC/Automation', 1800.00, 2, 2, 21, 'Siemens'),
(11, 'Heat Exchanger Gasket Set', 'HGS-T50', 'Seals', 'Heat Exchanger', 350.00, 4, 3, 14, 'Alfa Laval'),
(12, 'Packaging Film Roll', 'PFR-3001', 'Consumables', 'Packaging', 95.00, 50, 20, 3, 'Bosch Packaging'),
(13, 'CNC Tool Holder', 'CTH-BT40', 'Tooling', 'CNC Machine', 280.00, 8, 5, 10, 'Haas'),
(14, 'Generator Oil', 'GO-C32', 'Lubricants', 'Power', 220.00, 6, 4, 7, 'Caterpillar'),
(15, 'AGV Battery Pack', 'ABP-1500', 'Batteries', 'AGV', 4200.00, 1, 1, 45, 'KUKA'),
(16, 'Cooling Tower Fill', 'CTF-NC', 'Structural', 'HVAC', 1800.00, 2, 1, 30, 'Marley'),
(17, 'Press Brake Die Set', 'PBD-HFE3', 'Tooling', 'Press Brake', 950.00, 3, 2, 14, 'Amada'),
(18, 'HVAC Air Filter Set', 'AFS-IP', 'Filters', 'HVAC', 65.00, 20, 8, 5, 'Trane'),
(19, 'Vacuum Pump Vanes', 'VPV-R5', 'Rotating Equipment', 'Pump', 380.00, 2, 3, 14, 'Busch'),
(20, '3D Printer Nozzle', '3DN-F900', 'Consumables', 'Additive Manufacturing', 650.00, 3, 2, 21, 'Stratasys');

CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.MAINTENANCE_LOGS (
  LOG_ID INTEGER,
  WORK_ORDER_ID INTEGER,
  EQUIPMENT_ID INTEGER,
  TECHNICIAN_ID INTEGER,
  LOG_DATE DATE,
  ACTION_TAKEN VARCHAR(300),
  PARTS_USED VARCHAR(200),
  CONDITION_BEFORE VARCHAR(20),
  CONDITION_AFTER VARCHAR(20),
  NOTES VARCHAR(300)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.MAINTENANCE_LOGS
SELECT 1, 1, 1, 3, DATEADD(DAY, -102, CURRENT_DATE()), 'Lubricated all 6 joint axes, calibrated TCP position', 'Robot Joint Lubricant x2', 'Good', 'Excellent', 'All axes within tolerance'
UNION ALL SELECT 2, 3, 5, 1, DATEADD(DAY, -88, CURRENT_DATE()), 'Replaced main cylinder seals, bled hydraulic system', 'Hydraulic Seal Kit x2', 'Failed', 'Good', 'Seal failure caused by age and pressure cycling'
UNION ALL SELECT 3, 4, 7, 4, DATEADD(DAY, -80, CURRENT_DATE()), 'Inspected impeller for cavitation damage, replaced bearings', 'Pump Impeller Assembly x1', 'Fair', 'Excellent', 'Minor pitting found on impeller'
UNION ALL SELECT 4, 5, 8, 6, DATEADD(DAY, -75, CURRENT_DATE()), 'Emergency pump repair, replaced impeller and mechanical seal', 'Pump Impeller Assembly x1', 'Failed', 'Good', 'Severe cavitation damage, root cause: air entrainment'
UNION ALL SELECT 5, 6, 10, 7, DATEADD(DAY, -66, CURRENT_DATE()), 'Oil change, valve inspection, belt tension check', 'Compressor Oil Filter x1', 'Good', 'Excellent', 'No issues found'
UNION ALL SELECT 6, 7, 12, 18, DATEADD(DAY, -61, CURRENT_DATE()), 'Replaced 3 boiler tubes, hydrostatic test passed', 'Boiler Tube Bundle x1', 'Failed', 'Good', 'Tube thinning from corrosion, recommend full inspection in 6mo'
UNION ALL SELECT 7, 9, 15, 20, DATEADD(DAY, -48, CURRENT_DATE()), 'Adjusted belt tension, replaced 2 worn rollers', 'Conveyor Belt Section x1', 'Fair', 'Good', 'Belt tracking now centered'
UNION ALL SELECT 8, 10, 20, 13, DATEADD(DAY, -45, CURRENT_DATE()), 'Calibrated fill sensors, adjusted sealing pressure', 'None', 'Good', 'Excellent', 'All parameters within spec'
UNION ALL SELECT 9, 11, 21, 15, DATEADD(DAY, -42, CURRENT_DATE()), 'Cleared jam, realigned infeed conveyor', 'Conveyor Belt Section x1', 'Failed', 'Good', 'Misalignment caused by worn guide rail'
UNION ALL SELECT 10, 12, 2, 3, DATEADD(DAY, -38, CURRENT_DATE()), 'Calibrated all joint axes, checked cable routing', 'None', 'Good', 'Excellent', 'No issues found'
UNION ALL SELECT 11, 13, 18, 11, DATEADD(DAY, -35, CURRENT_DATE()), 'Replaced welding tips, calibrated wire feed', 'Welding Wire Spool x2', 'Fair', 'Excellent', 'Tips showed normal wear'
UNION ALL SELECT 12, 14, 9, 4, DATEADD(DAY, -27, CURRENT_DATE()), 'Cleaned tube bundle, replaced gaskets, pressure tested', 'Heat Exchanger Gasket Set x1', 'Fair', 'Excellent', 'Minor scale buildup removed'
UNION ALL SELECT 13, 15, 26, 7, DATEADD(DAY, -21, CURRENT_DATE()), 'Inspected fill media, cleaned distribution nozzles', 'None', 'Good', 'Good', 'Fill media in acceptable condition'
UNION ALL SELECT 14, 17, 4, 2, DATEADD(DAY, -18, CURRENT_DATE()), 'Replaced spindle bearings, balanced spindle assembly', 'Spindle Bearing Set x1', 'Failed', 'Excellent', 'Bearing failure caused vibration anomaly'
UNION ALL SELECT 15, 19, 11, 4, DATEADD(DAY, -6, CURRENT_DATE()), 'Full vessel inspection, pressure test to 150% working pressure', 'Heat Exchanger Gasket Set x1', 'Good', 'Excellent', 'All welds and seams passed inspection'
UNION ALL SELECT 16, 20, 24, 9, DATEADD(DAY, -8, CURRENT_DATE()), 'Recalibrated LIDAR sensors, updated navigation map', 'None', 'Fair', 'Good', 'Sensor drift caused by floor reflectivity changes'
UNION ALL SELECT 17, 23, 27, 16, DATEADD(DAY, -4, CURRENT_DATE()), 'Replaced print nozzle, leveled build platform', '3D Printer Nozzle x1', 'Good', 'Excellent', 'Routine replacement per schedule';


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.OPERATIONS.QUALITY_INSPECTIONS (
  INSPECTION_ID INTEGER,
  FACILITY_ID INTEGER,
  LINE_ID INTEGER,
  INSPECTOR_NAME VARCHAR(100),
  INSPECTION_DATE DATE,
  PRODUCT_TYPE VARCHAR(50),
  BATCH_SIZE INTEGER,
  DEFECTS_FOUND INTEGER,
  DEFECT_RATE NUMBER(5,2),
  PASS_FAIL VARCHAR(10),
  DEFECT_CATEGORY VARCHAR(50),
  NOTES VARCHAR(200)
);

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.QUALITY_INSPECTIONS
SELECT 1, 1, 1, 'Tom Baker', DATEADD(DAY, -97, CURRENT_DATE()), 'Automotive Parts', 500, 3, 0.60, 'Pass', 'Dimensional', 'Minor out-of-spec on 3 units'
UNION ALL SELECT 2, 1, 2, 'Tom Baker', DATEADD(DAY, -97, CURRENT_DATE()), 'Automotive Parts', 400, 8, 2.00, 'Pass', 'Surface Finish', 'Scratches on painted surface'
UNION ALL SELECT 3, 1, 1, 'Tom Baker', DATEADD(DAY, -80, CURRENT_DATE()), 'Automotive Parts', 500, 2, 0.40, 'Pass', 'Dimensional', 'Within acceptable limits'
UNION ALL SELECT 4, 1, 3, 'Jane Rivera', DATEADD(DAY, -71, CURRENT_DATE()), 'Heavy Equipment', 50, 4, 8.00, 'Fail', 'Welding', 'Porosity in 4 weld joints'
UNION ALL SELECT 5, 2, 4, 'Sam Peterson', DATEADD(DAY, -66, CURRENT_DATE()), 'Chemical Processing', 1000, 5, 0.50, 'Pass', 'Contamination', 'Trace impurities within spec'
UNION ALL SELECT 6, 2, 5, 'Sam Peterson', DATEADD(DAY, -53, CURRENT_DATE()), 'Chemical Processing', 1000, 3, 0.30, 'Pass', 'Contamination', 'All within tolerance'
UNION ALL SELECT 7, 4, 7, 'Lisa Wang', DATEADD(DAY, -52, CURRENT_DATE()), 'Metal Components', 800, 12, 1.50, 'Pass', 'Dimensional', 'CNC drift on 12 parts'
UNION ALL SELECT 8, 4, 8, 'Lisa Wang', DATEADD(DAY, -52, CURRENT_DATE()), 'Metal Components', 800, 5, 0.63, 'Pass', 'Surface Finish', 'Minor burrs on edges'
UNION ALL SELECT 9, 5, 9, 'Mike Chen', DATEADD(DAY, -43, CURRENT_DATE()), 'Consumer Goods', 2000, 15, 0.75, 'Pass', 'Packaging', 'Misaligned labels on 15 units'
UNION ALL SELECT 10, 5, 10, 'Mike Chen', DATEADD(DAY, -43, CURRENT_DATE()), 'Consumer Goods', 1500, 42, 2.80, 'Fail', 'Packaging', 'Seal integrity failure on 42 units'
UNION ALL SELECT 11, 1, 1, 'Tom Baker', DATEADD(DAY, -38, CURRENT_DATE()), 'Automotive Parts', 500, 1, 0.20, 'Pass', 'Dimensional', 'Best batch this quarter'
UNION ALL SELECT 12, 4, 7, 'Lisa Wang', DATEADD(DAY, -33, CURRENT_DATE()), 'Metal Components', 800, 6, 0.75, 'Pass', 'Dimensional', 'Improved after calibration'
UNION ALL SELECT 13, 2, 4, 'Sam Peterson', DATEADD(DAY, -28, CURRENT_DATE()), 'Chemical Processing', 1000, 2, 0.20, 'Pass', 'Contamination', 'Excellent batch quality'
UNION ALL SELECT 14, 5, 9, 'Mike Chen', DATEADD(DAY, -21, CURRENT_DATE()), 'Consumer Goods', 2000, 8, 0.40, 'Pass', 'Packaging', 'Improved after machine calibration'
UNION ALL SELECT 15, 1, 2, 'Jane Rivera', DATEADD(DAY, -17, CURRENT_DATE()), 'Automotive Parts', 400, 18, 4.50, 'Fail', 'Surface Finish', 'Paint booth contamination detected'
UNION ALL SELECT 16, 4, 8, 'Lisa Wang', DATEADD(DAY, -12, CURRENT_DATE()), 'Metal Components', 800, 4, 0.50, 'Pass', 'Surface Finish', 'Acceptable'
UNION ALL SELECT 17, 5, 10, 'Mike Chen', DATEADD(DAY, -10, CURRENT_DATE()), 'Consumer Goods', 1500, 10, 0.67, 'Pass', 'Packaging', 'Seal issue resolved'
UNION ALL SELECT 18, 2, 5, 'Sam Peterson', DATEADD(DAY, -7, CURRENT_DATE()), 'Chemical Processing', 1000, 4, 0.40, 'Pass', 'Contamination', 'Within limits'
UNION ALL SELECT 19, 1, 1, 'Tom Baker', DATEADD(DAY, -4, CURRENT_DATE()), 'Automotive Parts', 500, 2, 0.40, 'Pass', 'Dimensional', 'Consistent quality'
UNION ALL SELECT 20, 6, 12, 'Laura Kim', DATEADD(DAY, -2, CURRENT_DATE()), 'Prototypes', 10, 1, 10.00, 'Fail', 'Structural', 'Layer adhesion failure on prototype';


CREATE OR REPLACE TABLE INDUSTRIAL_HOL_DB.ENERGY.ENERGY_METERS (
  METER_ID INTEGER,
  FACILITY_ID INTEGER,
  METER_NAME VARCHAR(100),
  ENERGY_TYPE VARCHAR(20),
  MONTH VARCHAR(7),
  BUDGETED_KWH NUMBER(12,2),
  ACTUAL_KWH NUMBER(12,2),
  COST_PER_KWH NUMBER(6,4),
  TOTAL_COST NUMBER(10,2),
  PEAK_DEMAND_KW NUMBER(10,2)
);

INSERT INTO INDUSTRIAL_HOL_DB.ENERGY.ENERGY_METERS
SELECT 1, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -17, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 1008439.15, 0.0850, 85717.33, 3321.92
UNION ALL SELECT 2, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -16, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 890769.19, 0.0860, 76606.15, 2919.70
UNION ALL SELECT 3, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -15, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 867085.00, 0.0870, 75436.39, 2828.00
UNION ALL SELECT 4, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -14, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 821985.06, 0.0880, 72334.69, 2667.70
UNION ALL SELECT 5, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -13, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 739285.93, 0.0890, 65796.45, 2387.54
UNION ALL SELECT 6, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -12, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 740562.50, 0.0900, 66650.62, 2380.00
UNION ALL SELECT 7, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -11, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 807475.37, 0.0910, 73480.26, 2582.45
UNION ALL SELECT 8, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -10, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 773080.31, 0.0920, 71123.39, 2460.50
UNION ALL SELECT 9, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -9, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 919360.00, 0.0930, 85500.48, 2912.00
UNION ALL SELECT 10, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -8, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 945320.06, 0.0940, 88860.09, 2979.90
UNION ALL SELECT 11, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -7, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 1018523.54, 0.0950, 96759.74, 3195.37
UNION ALL SELECT 12, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -6, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 1113763.50, 0.0960, 106921.30, 3477.60
UNION ALL SELECT 13, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -5, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 977321.60, 0.0970, 94800.20, 3037.18
UNION ALL SELECT 14, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -4, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 1002338.06, 0.0980, 98229.13, 3100.30
UNION ALL SELECT 15, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -3, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 891310.00, 0.0990, 88239.69, 2744.00
UNION ALL SELECT 16, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -2, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 887479.69, 0.1000, 88747.97, 2719.50
UNION ALL SELECT 17, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -1, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 774785.85, 0.1010, 78253.37, 2363.18
UNION ALL SELECT 18, 1, 'Detroit Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -0, CURRENT_DATE()), 'YYYY-MM'), 850000.00, 799590.75, 0.1020, 81558.26, 2427.60
UNION ALL SELECT 19, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -17, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1423678.80, 0.0720, 102504.87, 4982.88
UNION ALL SELECT 20, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -16, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1257556.50, 0.0730, 91801.62, 4379.55
UNION ALL SELECT 21, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -15, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1224120.00, 0.0740, 90584.88, 4242.00
UNION ALL SELECT 22, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -14, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1160449.50, 0.0750, 87033.71, 4001.55
UNION ALL SELECT 23, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -13, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1043697.78, 0.0760, 79321.03, 3581.32
UNION ALL SELECT 24, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -12, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1045500.00, 0.0770, 80503.50, 3570.00
UNION ALL SELECT 25, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -11, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1139965.22, 0.0780, 88917.29, 3873.67
UNION ALL SELECT 26, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -10, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1091407.50, 0.0790, 86221.19, 3690.75
UNION ALL SELECT 27, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -9, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1297920.00, 0.0800, 103833.60, 4368.00
UNION ALL SELECT 28, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -8, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1334569.50, 0.0810, 108100.13, 4469.85
UNION ALL SELECT 29, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -7, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1437915.59, 0.0820, 117909.08, 4793.05
UNION ALL SELECT 30, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -6, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1572372.00, 0.0830, 130506.88, 5216.40
UNION ALL SELECT 31, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -5, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1379748.14, 0.0840, 115898.84, 4555.77
UNION ALL SELECT 32, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -4, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1415065.50, 0.0850, 120280.57, 4650.45
UNION ALL SELECT 33, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -3, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1258320.00, 0.0860, 108215.52, 4116.00
UNION ALL SELECT 34, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -2, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1252912.50, 0.0870, 109003.39, 4079.25
UNION ALL SELECT 35, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -1, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1093815.32, 0.0880, 96255.75, 3544.77
UNION ALL SELECT 36, 2, 'Houston Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -0, CURRENT_DATE()), 'YYYY-MM'), 1200000.00, 1128834.00, 0.0890, 100466.23, 3641.40
UNION ALL SELECT 37, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -17, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 415239.65, 0.0950, 39447.77, 1423.68
UNION ALL SELECT 38, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -16, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 366787.31, 0.0960, 35211.58, 1251.30
UNION ALL SELECT 39, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -15, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 357035.00, 0.0970, 34632.40, 1212.00
UNION ALL SELECT 40, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -14, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 338464.44, 0.0980, 33169.52, 1143.30
UNION ALL SELECT 41, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -13, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 304411.85, 0.0990, 30136.77, 1023.23
UNION ALL SELECT 42, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -12, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 304937.50, 0.1000, 30493.75, 1020.00
UNION ALL SELECT 43, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -11, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 332489.86, 0.1010, 33581.48, 1106.76
UNION ALL SELECT 44, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -10, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 318327.19, 0.1020, 32469.37, 1054.50
UNION ALL SELECT 45, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -9, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 378560.00, 0.1030, 38991.68, 1248.00
UNION ALL SELECT 46, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -8, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 389249.44, 0.1040, 40481.94, 1277.10
UNION ALL SELECT 47, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -7, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 419392.05, 0.1050, 44036.17, 1369.44
UNION ALL SELECT 48, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -6, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 458608.50, 0.1060, 48612.50, 1490.40
UNION ALL SELECT 49, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -5, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 402426.54, 0.1070, 43059.64, 1301.65
UNION ALL SELECT 50, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -4, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 412727.44, 0.1080, 44574.56, 1328.70
UNION ALL SELECT 51, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -3, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 367010.00, 0.1090, 40004.09, 1176.00
UNION ALL SELECT 52, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -2, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 365432.81, 0.1100, 40197.61, 1165.50
UNION ALL SELECT 53, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -1, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 319029.47, 0.1110, 35412.27, 1012.79
UNION ALL SELECT 54, 3, 'Chicago Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -0, CURRENT_DATE()), 'YYYY-MM'), 350000.00, 329243.25, 0.1120, 36875.24, 1040.40
UNION ALL SELECT 55, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -17, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 711839.40, 0.0800, 56947.15, 2372.80
UNION ALL SELECT 56, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -16, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 628778.25, 0.0810, 50931.04, 2085.50
UNION ALL SELECT 57, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -15, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 612060.00, 0.0820, 50188.92, 2020.00
UNION ALL SELECT 58, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -14, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 580224.75, 0.0830, 48158.65, 1905.50
UNION ALL SELECT 59, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -13, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 521848.89, 0.0840, 43835.31, 1705.39
UNION ALL SELECT 60, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -12, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 522750.00, 0.0850, 44433.75, 1700.00
UNION ALL SELECT 61, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -11, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 569982.61, 0.0860, 49018.50, 1844.60
UNION ALL SELECT 62, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -10, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 545703.75, 0.0870, 47476.23, 1757.50
UNION ALL SELECT 63, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -9, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 648960.00, 0.0880, 57108.48, 2080.00
UNION ALL SELECT 64, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -8, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 667284.75, 0.0890, 59388.34, 2128.50
UNION ALL SELECT 65, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -7, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 718957.79, 0.0900, 64706.20, 2282.41
UNION ALL SELECT 66, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -6, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 786186.00, 0.0910, 71542.93, 2484.00
UNION ALL SELECT 67, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -5, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 689874.07, 0.0920, 63468.41, 2169.42
UNION ALL SELECT 68, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -4, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 707532.75, 0.0930, 65800.55, 2214.50
UNION ALL SELECT 69, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -3, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 629160.00, 0.0940, 59141.04, 1960.00
UNION ALL SELECT 70, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -2, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 626456.25, 0.0950, 59513.34, 1942.50
UNION ALL SELECT 71, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -1, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 546907.66, 0.0960, 52503.14, 1687.99
UNION ALL SELECT 72, 4, 'Phoenix Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -0, CURRENT_DATE()), 'YYYY-MM'), 600000.00, 564417.00, 0.0970, 54748.45, 1734.00
UNION ALL SELECT 73, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -17, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 332191.72, 0.0880, 29232.87, 1127.08
UNION ALL SELECT 74, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -16, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 293429.85, 0.0890, 26115.26, 990.61
UNION ALL SELECT 75, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -15, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 285628.00, 0.0900, 25706.52, 959.50
UNION ALL SELECT 76, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -14, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 270771.55, 0.0910, 24640.21, 905.11
UNION ALL SELECT 77, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -13, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 243529.48, 0.0920, 22404.71, 810.06
UNION ALL SELECT 78, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -12, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 243950.00, 0.0930, 22687.35, 807.50
UNION ALL SELECT 79, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -11, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 265991.89, 0.0940, 25003.24, 876.19
UNION ALL SELECT 80, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -10, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 254661.75, 0.0950, 24192.87, 834.81
UNION ALL SELECT 81, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -9, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 302848.00, 0.0960, 29073.41, 988.00
UNION ALL SELECT 82, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -8, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 311399.55, 0.0970, 30205.76, 1011.04
UNION ALL SELECT 83, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -7, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 335513.64, 0.0980, 32880.34, 1084.14
UNION ALL SELECT 84, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -6, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 366886.80, 0.0990, 36321.79, 1179.90
UNION ALL SELECT 85, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -5, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 321941.23, 0.1000, 32194.12, 1030.47
UNION ALL SELECT 86, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -4, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 330181.95, 0.1010, 33348.38, 1051.89
UNION ALL SELECT 87, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -3, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 293608.00, 0.1020, 29948.02, 931.00
UNION ALL SELECT 88, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -2, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 292346.25, 0.1030, 30111.66, 922.69
UNION ALL SELECT 89, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -1, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 255223.58, 0.1040, 26543.25, 801.79
UNION ALL SELECT 90, 5, 'Atlanta Main Meter', 'Electric', TO_CHAR(DATEADD(MONTH, -0, CURRENT_DATE()), 'YYYY-MM'), 280000.00, 263394.60, 0.1050, 27656.43, 823.65;


GRANT ALL ON ALL TABLES IN SCHEMA INDUSTRIAL_HOL_DB.OPERATIONS TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON ALL TABLES IN SCHEMA INDUSTRIAL_HOL_DB.ENERGY TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON ALL STAGES IN SCHEMA INDUSTRIAL_HOL_DB.OPERATIONS TO ROLE INDUSTRIAL_HOL_ROLE;
