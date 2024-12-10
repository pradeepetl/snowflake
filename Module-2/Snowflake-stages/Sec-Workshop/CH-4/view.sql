/*******************************************************************************/

create or replace file format aws_csv_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true;


create or replace stage aws_myopen_data
url ='s3://snowflakesmpdata/Nyc/'
file_format = aws_csv_format


SELECT 
$1	vendor_id	,
$2	pickup_datetime	,
$3	dropoff_datetime	,
$4	passenger_count	,
$5	trip_distance	,
$6	pickup_longitude	,
$7	pickup_latitude	,
$8	rate_code	,
$9	store_and_fwd_flag	,
$10	dropoff_longitude	,
$11	dropoff_latitude	,
$12	payment_type	,
$13	fare_amount	,
$14	surcharge	,
$15	mta_tax	,
$16	tip_amount	,
$17	tolls_amount	,
$18	total_amount	
FROM @DEMO_DB.PUBLIC.aws_myopen_data
(file_format => DEMO_DB.PUBLIC.aws_csv_format)

