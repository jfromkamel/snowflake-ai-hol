USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE INDUSTRIAL_HOL_WH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.PRODUCTION_LINES VALUES
(1, 'Assembly Line A', 1, 'Automotive Parts', 120, 'Running', '2025-03-15'),
(2, 'Assembly Line B', 1, 'Automotive Parts', 100, 'Running', '2025-02-20'),
(3, 'Assembly Line C', 1, 'Heavy Equipment', 60, 'Maintenance', '2025-01-10'),
(4, 'Refinery Unit 1', 2, 'Chemical Processing', 500, 'Running', '2025-04-01'),
(5, 'Refinery Unit 2', 2, 'Chemical Processing', 500, 'Running', '2025-03-28'),
(6, 'Refinery Unit 3', 2, 'Polymer Production', 300, 'Idle', '2024-12-15'),
(7, 'Fab Line Alpha', 4, 'Metal Components', 200, 'Running', '2025-04-10'),
(8, 'Fab Line Beta', 4, 'Metal Components', 200, 'Running', '2025-03-05'),
(9, 'Pack Line 1', 5, 'Consumer Goods', 800, 'Running', '2025-04-15'),
(10, 'Pack Line 2', 5, 'Consumer Goods', 600, 'Running', '2025-03-20'),
(11, 'Pack Line 3', 5, 'Industrial Goods', 400, 'Maintenance', '2025-01-25'),
(12, 'R&D Prototype Line', 6, 'Prototypes', 20, 'Running', '2025-04-18');

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.EQUIPMENT VALUES
(1, 'Robotic Arm RA-101', 'Robotic Arm', 1, 1, 'FANUC', 'M-20iD', '2019-06-15', '2025-04-10', 90, 'Operational', 'High', 85000.00),
(2, 'Robotic Arm RA-102', 'Robotic Arm', 1, 1, 'FANUC', 'M-20iD', '2019-06-15', '2025-05-15', 90, 'Operational', 'High', 85000.00),
(3, 'CNC Mill MC-201', 'CNC Machine', 1, 2, 'Haas', 'VF-4SS', '2018-03-20', '2025-03-20', 60, 'Overdue', 'High', 125000.00),
(4, 'CNC Lathe CL-202', 'CNC Machine', 1, 2, 'Haas', 'ST-30Y', '2020-01-10', '2025-05-10', 60, 'Operational', 'High', 110000.00),
(5, 'Hydraulic Press HP-301', 'Press', 1, 3, 'Beckwood', 'TMP-200', '2015-09-01', '2025-02-15', 120, 'Overdue', 'Critical', 250000.00),
(6, 'Conveyor Belt CB-101', 'Conveyor', 1, 1, 'Dorner', '3200 Series', '2021-04-20', '2025-06-20', 180, 'Operational', 'Medium', 35000.00),
(7, 'Pump Station PS-401', 'Pump', 2, 4, 'Grundfos', 'CR 95', '2016-02-28', '2025-04-28', 90, 'Operational', 'Critical', 45000.00),
(8, 'Pump Station PS-402', 'Pump', 2, 4, 'Grundfos', 'CR 95', '2016-02-28', '2025-03-15', 90, 'Overdue', 'Critical', 45000.00),
(9, 'Heat Exchanger HX-501', 'Heat Exchanger', 2, 5, 'Alfa Laval', 'T50-MFG', '2014-08-10', '2025-08-10', 365, 'Operational', 'High', 180000.00),
(10, 'Compressor CP-601', 'Compressor', 2, 4, 'Atlas Copco', 'GA 160', '2017-11-15', '2025-04-15', 120, 'Operational', 'High', 92000.00),
(11, 'Reactor Vessel RV-701', 'Reactor', 2, 5, 'Pfaudler', 'RA Series', '2012-05-20', '2025-05-20', 180, 'Operational', 'Critical', 350000.00),
(12, 'Boiler BL-801', 'Boiler', 2, NULL, 'Cleaver-Brooks', 'CB 700', '2010-03-01', '2025-01-30', 180, 'Overdue', 'Critical', 420000.00),
(13, 'Forklift FK-101', 'Forklift', 3, NULL, 'Toyota', '8FBE20U', '2022-01-15', '2025-07-15', 180, 'Operational', 'Medium', 32000.00),
(14, 'Forklift FK-102', 'Forklift', 3, NULL, 'Toyota', '8FBE20U', '2022-01-15', '2025-07-15', 180, 'Operational', 'Medium', 32000.00),
(15, 'Conveyor System CS-301', 'Conveyor', 3, NULL, 'Hytrol', 'ProSort 400', '2020-06-10', '2025-06-10', 120, 'Operational', 'High', 75000.00),
(16, 'Laser Cutter LC-401', 'Laser Cutter', 4, 7, 'Trumpf', 'TruLaser 5030', '2021-09-01', '2025-03-01', 60, 'Overdue', 'High', 280000.00),
(17, 'Laser Cutter LC-402', 'Laser Cutter', 4, 8, 'Trumpf', 'TruLaser 5030', '2021-09-01', '2025-06-01', 60, 'Operational', 'High', 280000.00),
(18, 'Welding Robot WR-501', 'Welding Robot', 4, 7, 'Lincoln Electric', 'Flextec 650X', '2020-03-15', '2025-04-15', 90, 'Operational', 'High', 95000.00),
(19, 'Press Brake PB-601', 'Press Brake', 4, 8, 'Amada', 'HFE3i', '2019-07-20', '2025-07-20', 120, 'Operational', 'Medium', 150000.00),
(20, 'Packaging Machine PM-101', 'Packaging', 5, 9, 'Bosch', 'CUC 3001', '2022-05-01', '2025-05-01', 90, 'Operational', 'High', 120000.00),
(21, 'Packaging Machine PM-102', 'Packaging', 5, 10, 'Bosch', 'CUC 3001', '2022-05-01', '2025-04-01', 90, 'Overdue', 'High', 120000.00),
(22, 'Shrink Wrapper SW-201', 'Packaging', 5, 9, 'Cryovac', 'VS70TT', '2023-02-10', '2025-08-10', 180, 'Operational', 'Medium', 65000.00),
(23, 'Labeling Machine LM-301', 'Labeling', 5, 10, 'Videojet', '7510', '2023-06-15', '2025-06-15', 120, 'Operational', 'Low', 28000.00),
(24, 'AGV Transport AGV-101', 'AGV', 3, NULL, 'KUKA', 'KMP 1500', '2023-11-01', '2025-05-01', 180, 'Operational', 'Medium', 95000.00),
(25, 'Quality Scanner QS-101', 'Inspection', 4, 7, 'Keyence', 'XG-X Series', '2022-08-20', '2025-08-20', 365, 'Operational', 'High', 45000.00),
(26, 'Cooling Tower CT-901', 'HVAC', 2, NULL, 'Marley', 'NC Series', '2008-04-15', '2025-04-15', 180, 'Operational', 'High', 220000.00),
(27, '3D Printer PR-101', 'Additive Manufacturing', 6, 12, 'Stratasys', 'F900', '2023-01-10', '2025-07-10', 180, 'Operational', 'Medium', 350000.00),
(28, 'CNC Router CR-701', 'CNC Machine', 4, 8, 'Biesse', 'Rover A', '2020-11-20', '2025-05-20', 90, 'Operational', 'Medium', 95000.00),
(29, 'Paint Booth PB-801', 'Finishing', 1, NULL, 'Global Finishing', 'Spray Booth', '2017-06-01', '2025-06-01', 365, 'Operational', 'Medium', 75000.00),
(30, 'Air Handler AH-101', 'HVAC', 1, NULL, 'Trane', 'IntelliPak', '2015-10-15', '2025-04-15', 180, 'Operational', 'Medium', 48000.00),
(31, 'Generator GN-101', 'Power', 2, NULL, 'Caterpillar', 'C32', '2013-09-01', '2025-03-01', 180, 'Overdue', 'Critical', 520000.00),
(32, 'Transformer TR-201', 'Power', 1, NULL, 'ABB', 'Distribution', '2011-04-20', '2025-10-20', 365, 'Operational', 'Critical', 180000.00),
(33, 'Water Treatment WT-101', 'Treatment', 2, NULL, 'Evoqua', 'MEMCOR', '2016-07-15', '2025-07-15', 365, 'Operational', 'High', 135000.00),
(34, 'Overhead Crane OC-101', 'Crane', 1, NULL, 'Konecranes', 'CXT', '2014-12-01', '2025-06-01', 365, 'Operational', 'High', 95000.00),
(35, 'Vacuum Pump VP-101', 'Pump', 4, 7, 'Busch', 'R5', '2021-03-10', '2025-03-10', 90, 'Overdue', 'Medium', 18000.00);

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.WORK_ORDERS VALUES
(1, 1, 3, 1, 'Preventive', 'Medium', 'Quarterly lubrication and calibration of robotic arm', '2025-01-05', '2025-01-10', '2025-01-10', 'Completed', 4.0, 3.5, 250.00, 227.50),
(2, 3, 1, 1, 'Preventive', 'High', 'Bi-monthly spindle inspection and alignment', '2025-01-15', '2025-01-20', NULL, 'Overdue', 6.0, NULL, NULL, NULL),
(3, 5, 1, 1, 'Corrective', 'Critical', 'Hydraulic seal replacement - pressure loss detected', '2025-01-22', '2025-01-23', '2025-01-24', 'Completed', 8.0, 10.0, 1800.00, 550.00),
(4, 7, 4, 2, 'Preventive', 'High', 'Pump impeller inspection and bearing check', '2025-01-28', '2025-02-01', '2025-02-01', 'Completed', 5.0, 4.5, 320.00, 270.00),
(5, 8, 6, 2, 'Corrective', 'Critical', 'Pump cavitation - emergency repair', '2025-02-05', '2025-02-05', '2025-02-06', 'Completed', 6.0, 8.0, 2200.00, 456.00),
(6, 10, 7, 2, 'Preventive', 'High', 'Compressor oil change and valve inspection', '2025-02-10', '2025-02-15', '2025-02-15', 'Completed', 4.0, 4.0, 450.00, 272.00),
(7, 12, 18, 2, 'Corrective', 'Critical', 'Boiler tube leak - emergency shutdown required', '2025-02-18', '2025-02-18', '2025-02-20', 'Completed', 16.0, 22.0, 8500.00, 1188.00),
(8, 16, 10, 4, 'Preventive', 'High', 'Laser optics cleaning and realignment', '2025-02-25', '2025-03-01', NULL, 'Overdue', 3.0, NULL, NULL, NULL),
(9, 15, 20, 3, 'Preventive', 'Medium', 'Conveyor belt tension and roller inspection', '2025-03-01', '2025-03-05', '2025-03-05', 'Completed', 3.0, 2.5, 180.00, 127.50),
(10, 20, 13, 5, 'Preventive', 'High', 'Quarterly packaging machine calibration', '2025-03-05', '2025-03-08', '2025-03-08', 'Completed', 4.0, 4.0, 200.00, 200.00),
(11, 21, 15, 5, 'Corrective', 'High', 'Packaging machine jam - conveyor belt misalignment', '2025-03-10', '2025-03-10', '2025-03-11', 'Completed', 3.0, 4.5, 350.00, 238.50),
(12, 2, 3, 1, 'Preventive', 'Medium', 'Robotic arm joint calibration', '2025-03-12', '2025-03-15', '2025-03-15', 'Completed', 4.0, 3.0, 150.00, 195.00),
(13, 18, 11, 4, 'Preventive', 'Medium', 'Welding robot tip replacement and calibration', '2025-03-15', '2025-03-18', '2025-03-18', 'Completed', 2.0, 2.0, 420.00, 124.00),
(14, 9, 4, 2, 'Preventive', 'High', 'Annual heat exchanger cleaning and inspection', '2025-03-20', '2025-03-25', '2025-03-26', 'Completed', 12.0, 14.0, 1500.00, 840.00),
(15, 26, 7, 2, 'Preventive', 'Medium', 'Cooling tower fill media inspection', '2025-03-28', '2025-04-01', '2025-04-01', 'Completed', 6.0, 5.0, 800.00, 340.00),
(16, 31, 7, 2, 'Preventive', 'Critical', 'Generator load bank test and oil analysis', '2025-03-01', '2025-03-05', NULL, 'Overdue', 8.0, NULL, NULL, NULL),
(17, 4, 2, 1, 'Corrective', 'High', 'CNC lathe spindle vibration anomaly', '2025-04-02', '2025-04-03', '2025-04-04', 'Completed', 6.0, 7.0, 1200.00, 406.00),
(18, 35, 12, 4, 'Preventive', 'Medium', 'Vacuum pump oil change and seal check', '2025-03-10', '2025-03-12', NULL, 'Overdue', 2.0, NULL, NULL, NULL),
(19, 11, 4, 2, 'Preventive', 'Critical', 'Reactor vessel inspection and pressure test', '2025-04-10', '2025-04-15', '2025-04-16', 'Completed', 16.0, 18.0, 2800.00, 1080.00),
(20, 24, 9, 3, 'Corrective', 'Medium', 'AGV navigation sensor recalibration', '2025-04-12', '2025-04-14', '2025-04-14', 'Completed', 3.0, 3.0, 650.00, 108.00),
(21, 5, 1, 1, 'Preventive', 'Critical', 'Hydraulic press annual certification', '2025-02-01', '2025-02-15', NULL, 'Overdue', 12.0, NULL, NULL, NULL),
(22, 8, 6, 2, 'Preventive', 'Critical', 'Pump station quarterly service', '2025-03-01', '2025-03-15', NULL, 'Overdue', 5.0, NULL, NULL, NULL),
(23, 27, 16, 6, 'Preventive', 'Medium', '3D printer nozzle replacement and calibration', '2025-04-15', '2025-04-18', '2025-04-18', 'Completed', 2.0, 1.5, 800.00, 105.00),
(24, 6, 3, 1, 'Corrective', 'Low', 'Conveyor belt tracking adjustment', '2025-04-18', '2025-04-22', NULL, 'Scheduled', 2.0, NULL, NULL, NULL),
(25, 30, 2, 1, 'Preventive', 'Medium', 'Air handler filter replacement and coil cleaning', '2025-04-15', '2025-04-20', NULL, 'Scheduled', 4.0, NULL, NULL, NULL),
(26, 17, 19, 4, 'Preventive', 'High', 'Laser cutter lens cleaning and gas flow check', '2025-04-20', '2025-04-25', NULL, 'Scheduled', 3.0, NULL, NULL, NULL),
(27, 19, 12, 4, 'Preventive', 'Medium', 'Press brake ram alignment verification', '2025-04-22', '2025-04-28', NULL, 'Scheduled', 4.0, NULL, NULL, NULL),
(28, 34, 1, 1, 'Preventive', 'High', 'Overhead crane annual load test', '2025-05-01', '2025-05-05', NULL, 'Scheduled', 8.0, NULL, NULL, NULL);

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.DOWNTIME_EVENTS VALUES
(1, 5, 1, 3, 'Unplanned', 'Hydraulic seal failure', '2025-01-22 06:00:00', '2025-01-24 14:00:00', 56.0, 3360, 168000.00),
(2, 8, 2, 4, 'Unplanned', 'Pump cavitation damage', '2025-02-05 02:30:00', '2025-02-06 18:00:00', 39.5, 19750, 98750.00),
(3, 12, 2, NULL, 'Unplanned', 'Boiler tube leak', '2025-02-18 11:00:00', '2025-02-20 16:00:00', 53.0, 0, 245000.00),
(4, 3, 1, 2, 'Planned', 'Scheduled spindle maintenance', '2025-01-20 06:00:00', '2025-01-20 14:00:00', 8.0, 800, 8000.00),
(5, 21, 5, 10, 'Unplanned', 'Conveyor belt jam', '2025-03-10 09:15:00', '2025-03-11 07:00:00', 21.8, 13050, 39150.00),
(6, 16, 4, 7, 'Planned', 'Laser optics maintenance', '2025-03-01 06:00:00', '2025-03-01 12:00:00', 6.0, 1200, 6000.00),
(7, 4, 1, 2, 'Unplanned', 'Spindle vibration anomaly', '2025-04-02 14:00:00', '2025-04-04 10:00:00', 44.0, 4400, 44000.00),
(8, 1, 1, 1, 'Planned', 'Quarterly calibration', '2025-01-10 06:00:00', '2025-01-10 10:00:00', 4.0, 480, 2400.00),
(9, 11, 2, 5, 'Planned', 'Reactor vessel inspection', '2025-04-15 06:00:00', '2025-04-16 18:00:00', 36.0, 18000, 90000.00),
(10, 31, 2, NULL, 'Unplanned', 'Generator failure during storm', '2025-02-28 22:00:00', '2025-03-01 08:00:00', 10.0, 0, 125000.00),
(11, 10, 2, 4, 'Planned', 'Compressor oil change', '2025-02-15 06:00:00', '2025-02-15 10:00:00', 4.0, 2000, 5000.00),
(12, 20, 5, 9, 'Planned', 'Quarterly calibration', '2025-03-08 06:00:00', '2025-03-08 10:00:00', 4.0, 3200, 4800.00),
(13, 15, 3, NULL, 'Unplanned', 'Roller bearing failure', '2025-03-20 11:30:00', '2025-03-20 16:00:00', 4.5, 0, 12000.00),
(14, 24, 3, NULL, 'Unplanned', 'Navigation sensor drift', '2025-04-12 08:00:00', '2025-04-14 12:00:00', 52.0, 0, 8500.00),
(15, 18, 4, 7, 'Planned', 'Welding tip replacement', '2025-03-18 06:00:00', '2025-03-18 08:00:00', 2.0, 400, 1200.00);

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.MAINTENANCE_LOGS VALUES
(1, 1, 1, 3, '2025-01-10', 'Lubricated all 6 joint axes, calibrated TCP position', 'Robot Joint Lubricant x2', 'Good', 'Excellent', 'All axes within tolerance'),
(2, 3, 5, 1, '2025-01-24', 'Replaced main cylinder seals, bled hydraulic system', 'Hydraulic Seal Kit x2', 'Failed', 'Good', 'Seal failure caused by age and pressure cycling'),
(3, 4, 7, 4, '2025-02-01', 'Inspected impeller for cavitation damage, replaced bearings', 'Pump Impeller Assembly x1', 'Fair', 'Excellent', 'Minor pitting found on impeller'),
(4, 5, 8, 6, '2025-02-06', 'Emergency pump repair, replaced impeller and mechanical seal', 'Pump Impeller Assembly x1', 'Failed', 'Good', 'Severe cavitation damage, root cause: air entrainment'),
(5, 6, 10, 7, '2025-02-15', 'Oil change, valve inspection, belt tension check', 'Compressor Oil Filter x1', 'Good', 'Excellent', 'No issues found'),
(6, 7, 12, 18, '2025-02-20', 'Replaced 3 boiler tubes, hydrostatic test passed', 'Boiler Tube Bundle x1', 'Failed', 'Good', 'Tube thinning from corrosion, recommend full inspection in 6mo'),
(7, 9, 15, 20, '2025-03-05', 'Adjusted belt tension, replaced 2 worn rollers', 'Conveyor Belt Section x1', 'Fair', 'Good', 'Belt tracking now centered'),
(8, 10, 20, 13, '2025-03-08', 'Calibrated fill sensors, adjusted sealing pressure', 'None', 'Good', 'Excellent', 'All parameters within spec'),
(9, 11, 21, 15, '2025-03-11', 'Cleared jam, realigned infeed conveyor', 'Conveyor Belt Section x1', 'Failed', 'Good', 'Misalignment caused by worn guide rail'),
(10, 12, 2, 3, '2025-03-15', 'Calibrated all joint axes, checked cable routing', 'None', 'Good', 'Excellent', 'No issues found'),
(11, 13, 18, 11, '2025-03-18', 'Replaced welding tips, calibrated wire feed', 'Welding Wire Spool x2', 'Fair', 'Excellent', 'Tips showed normal wear'),
(12, 14, 9, 4, '2025-03-26', 'Cleaned tube bundle, replaced gaskets, pressure tested', 'Heat Exchanger Gasket Set x1', 'Fair', 'Excellent', 'Minor scale buildup removed'),
(13, 15, 26, 7, '2025-04-01', 'Inspected fill media, cleaned distribution nozzles', 'None', 'Good', 'Good', 'Fill media in acceptable condition'),
(14, 17, 4, 2, '2025-04-04', 'Replaced spindle bearings, balanced spindle assembly', 'Spindle Bearing Set x1', 'Failed', 'Excellent', 'Bearing failure caused vibration anomaly'),
(15, 19, 11, 4, '2025-04-16', 'Full vessel inspection, pressure test to 150% working pressure', 'Heat Exchanger Gasket Set x1', 'Good', 'Excellent', 'All welds and seams passed inspection'),
(16, 20, 24, 9, '2025-04-14', 'Recalibrated LIDAR sensors, updated navigation map', 'None', 'Fair', 'Good', 'Sensor drift caused by floor reflectivity changes'),
(17, 23, 27, 16, '2025-04-18', 'Replaced print nozzle, leveled build platform', '3D Printer Nozzle x1', 'Good', 'Excellent', 'Routine replacement per schedule');

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

INSERT INTO INDUSTRIAL_HOL_DB.OPERATIONS.QUALITY_INSPECTIONS VALUES
(1, 1, 1, 'Tom Baker', '2025-01-15', 'Automotive Parts', 500, 3, 0.60, 'Pass', 'Dimensional', 'Minor out-of-spec on 3 units'),
(2, 1, 2, 'Tom Baker', '2025-01-15', 'Automotive Parts', 400, 8, 2.00, 'Pass', 'Surface Finish', 'Scratches on painted surface'),
(3, 1, 1, 'Tom Baker', '2025-02-01', 'Automotive Parts', 500, 2, 0.40, 'Pass', 'Dimensional', 'Within acceptable limits'),
(4, 1, 3, 'Jane Rivera', '2025-02-10', 'Heavy Equipment', 50, 4, 8.00, 'Fail', 'Welding', 'Porosity in 4 weld joints'),
(5, 2, 4, 'Sam Peterson', '2025-02-15', 'Chemical Processing', 1000, 5, 0.50, 'Pass', 'Contamination', 'Trace impurities within spec'),
(6, 2, 5, 'Sam Peterson', '2025-02-28', 'Chemical Processing', 1000, 3, 0.30, 'Pass', 'Contamination', 'All within tolerance'),
(7, 4, 7, 'Lisa Wang', '2025-03-01', 'Metal Components', 800, 12, 1.50, 'Pass', 'Dimensional', 'CNC drift on 12 parts'),
(8, 4, 8, 'Lisa Wang', '2025-03-01', 'Metal Components', 800, 5, 0.63, 'Pass', 'Surface Finish', 'Minor burrs on edges'),
(9, 5, 9, 'Mike Chen', '2025-03-10', 'Consumer Goods', 2000, 15, 0.75, 'Pass', 'Packaging', 'Misaligned labels on 15 units'),
(10, 5, 10, 'Mike Chen', '2025-03-10', 'Consumer Goods', 1500, 42, 2.80, 'Fail', 'Packaging', 'Seal integrity failure on 42 units'),
(11, 1, 1, 'Tom Baker', '2025-03-15', 'Automotive Parts', 500, 1, 0.20, 'Pass', 'Dimensional', 'Best batch this quarter'),
(12, 4, 7, 'Lisa Wang', '2025-03-20', 'Metal Components', 800, 6, 0.75, 'Pass', 'Dimensional', 'Improved after calibration'),
(13, 2, 4, 'Sam Peterson', '2025-03-25', 'Chemical Processing', 1000, 2, 0.20, 'Pass', 'Contamination', 'Excellent batch quality'),
(14, 5, 9, 'Mike Chen', '2025-04-01', 'Consumer Goods', 2000, 8, 0.40, 'Pass', 'Packaging', 'Improved after machine calibration'),
(15, 1, 2, 'Jane Rivera', '2025-04-05', 'Automotive Parts', 400, 18, 4.50, 'Fail', 'Surface Finish', 'Paint booth contamination detected'),
(16, 4, 8, 'Lisa Wang', '2025-04-10', 'Metal Components', 800, 4, 0.50, 'Pass', 'Surface Finish', 'Acceptable'),
(17, 5, 10, 'Mike Chen', '2025-04-12', 'Consumer Goods', 1500, 10, 0.67, 'Pass', 'Packaging', 'Seal issue resolved'),
(18, 2, 5, 'Sam Peterson', '2025-04-15', 'Chemical Processing', 1000, 4, 0.40, 'Pass', 'Contamination', 'Within limits'),
(19, 1, 1, 'Tom Baker', '2025-04-18', 'Automotive Parts', 500, 2, 0.40, 'Pass', 'Dimensional', 'Consistent quality'),
(20, 6, 12, 'Laura Kim', '2025-04-20', 'Prototypes', 10, 1, 10.00, 'Fail', 'Structural', 'Layer adhesion failure on prototype');

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

INSERT INTO INDUSTRIAL_HOL_DB.ENERGY.ENERGY_METERS VALUES
(1, 1, 'Detroit Main Meter', 'Electric', '2025-01', 850000.00, 892000.00, 0.0850, 75820.00, 2800.00),
(2, 1, 'Detroit Main Meter', 'Electric', '2025-02', 850000.00, 878000.00, 0.0850, 74630.00, 2750.00),
(3, 1, 'Detroit Main Meter', 'Electric', '2025-03', 850000.00, 910000.00, 0.0870, 79170.00, 2900.00),
(4, 1, 'Detroit Main Meter', 'Electric', '2025-04', 850000.00, 1050000.00, 0.0870, 91350.00, 3200.00),
(5, 1, 'Detroit Gas Meter', 'Natural Gas', '2025-01', 120000.00, 145000.00, 0.0350, 5075.00, NULL),
(6, 1, 'Detroit Gas Meter', 'Natural Gas', '2025-02', 120000.00, 138000.00, 0.0350, 4830.00, NULL),
(7, 1, 'Detroit Gas Meter', 'Natural Gas', '2025-03', 100000.00, 105000.00, 0.0340, 3570.00, NULL),
(8, 2, 'Houston Main Meter', 'Electric', '2025-01', 1200000.00, 1180000.00, 0.0720, 84960.00, 4200.00),
(9, 2, 'Houston Main Meter', 'Electric', '2025-02', 1200000.00, 1350000.00, 0.0720, 97200.00, 4800.00),
(10, 2, 'Houston Main Meter', 'Electric', '2025-03', 1200000.00, 1220000.00, 0.0740, 90280.00, 4300.00),
(11, 2, 'Houston Main Meter', 'Electric', '2025-04', 1200000.00, 1480000.00, 0.0740, 109520.00, 5100.00),
(12, 2, 'Houston Gas Meter', 'Natural Gas', '2025-01', 500000.00, 520000.00, 0.0300, 15600.00, NULL),
(13, 2, 'Houston Gas Meter', 'Natural Gas', '2025-02', 500000.00, 580000.00, 0.0300, 17400.00, NULL),
(14, 3, 'Chicago Main Meter', 'Electric', '2025-01', 350000.00, 340000.00, 0.0950, 32300.00, 1200.00),
(15, 3, 'Chicago Main Meter', 'Electric', '2025-02', 350000.00, 355000.00, 0.0950, 33725.00, 1250.00),
(16, 3, 'Chicago Main Meter', 'Electric', '2025-03', 350000.00, 348000.00, 0.0960, 33408.00, 1220.00),
(17, 4, 'Phoenix Main Meter', 'Electric', '2025-01', 600000.00, 590000.00, 0.0800, 47200.00, 2000.00),
(18, 4, 'Phoenix Main Meter', 'Electric', '2025-02', 600000.00, 610000.00, 0.0800, 48800.00, 2100.00),
(19, 4, 'Phoenix Main Meter', 'Electric', '2025-03', 600000.00, 720000.00, 0.0820, 59040.00, 2500.00),
(20, 4, 'Phoenix Main Meter', 'Electric', '2025-04', 650000.00, 780000.00, 0.0820, 63960.00, 2600.00),
(21, 5, 'Atlanta Main Meter', 'Electric', '2025-01', 280000.00, 275000.00, 0.0880, 24200.00, 950.00),
(22, 5, 'Atlanta Main Meter', 'Electric', '2025-02', 280000.00, 282000.00, 0.0880, 24816.00, 980.00),
(23, 5, 'Atlanta Main Meter', 'Electric', '2025-03', 280000.00, 290000.00, 0.0900, 26100.00, 1000.00),
(24, 6, 'Seattle Main Meter', 'Electric', '2025-01', 80000.00, 78000.00, 0.0650, 5070.00, 320.00),
(25, 6, 'Seattle Main Meter', 'Electric', '2025-02', 80000.00, 82000.00, 0.0650, 5330.00, 340.00);

GRANT ALL ON ALL TABLES IN SCHEMA INDUSTRIAL_HOL_DB.OPERATIONS TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON ALL TABLES IN SCHEMA INDUSTRIAL_HOL_DB.ENERGY TO ROLE INDUSTRIAL_HOL_ROLE;
GRANT ALL ON ALL STAGES IN SCHEMA INDUSTRIAL_HOL_DB.OPERATIONS TO ROLE INDUSTRIAL_HOL_ROLE;
