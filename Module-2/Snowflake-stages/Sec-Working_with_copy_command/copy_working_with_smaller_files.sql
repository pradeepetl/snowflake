Data link : https://www.kaggle.com/datasets/crailtap/taxi-trajectory

copy into TAXI_DRIVE from   
(select t.$1 , t.$2 , iff(t.$3='',null,t.$3) , iff(t.$4='',null,t.$4) , t.$5 , t.$6 , t.$7, t.$8, t.$9 from '@READER_SALES.PUBLIC.%TAXI_DRIVE' t)
 file_format = (FORMAT_NAME='taxi_csv_format' field_optionally_enclosed_by='"')
 ON_ERROR='CONTINUE' -- 1m 48s
 
 
CREATE OR REPLACE TRANSIENT TABLE TAXI_DRIVE_SMALL_FILES
(
TRIP_ID NUMBER,
CALL_TYPE VARCHAR(2),
ORIGIN_CALL NUMBER,
ORIGIN_STAND NUMBER,
TAXI_ID NUMBER,
TIMESTAMP NUMBER,
DAY_TYPE VARCHAR(1),
MISSING_DATA BOOLEAN,
POLYLINE ARRAY
);

put file:///Users/phchannappa/Downloads/Snowfalke_udemy/Workingwithcopycommand/split/train* @READER_SALES.PUBLIC.%TAXI_DRIVE_SMALL_FILES;

split -b 50000000  train.csv split/train_split_

copy into TAXI_DRIVE_SMALL_FILES from   
(select t.$1 , t.$2 , iff(t.$3='',null,t.$3) , iff(t.$4='',null,t.$4) , t.$5 , t.$6 , t.$7, t.$8, t.$9 
 from '@READER_SALES.PUBLIC.%TAXI_DRIVE_SMALL_FILES' t)
 file_format = (FORMAT_NAME='taxi_csv_format' field_optionally_enclosed_by='"')
 ON_ERROR='CONTINUE' -- 32 s
