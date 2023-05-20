/*******************************************************************************************************/


create or replace file format my_csv_unload_format
type = csv field_delimiter = ',' skip_header = 0 null_if = ('NULL', 'null') 
empty_field_as_null = true compression = gzip;

alter storage integration s3_int set  
storage_allowed_locations=('s3://snowflakecrctest/emp/',
                           's3://snowflakecrctest/emp_unload/','s3://snowflakecrctest/zip_folder/')

desc integration s3_int

create or replace stage my_s3_unload_stage
  storage_integration = s3_int
  url = 's3://snowflakecrctest/emp_unload/'
  file_format = my_csv_unload_format;

copy into @my_s3_unload_stage
from
emp_ext_stage
overwrite = true

desc stage my_s3_unload_stage

select count(*) from @my_s3_unload_stage;
select count(*) from emp_ext_stage

select * from emp_ext_stage
minus
select t.$1  , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @my_s3_unload_stage t;


copy into @my_s3_unload_stage/select_
from
(
  select 
  first_name,
  email 
  from
  emp_ext_stage
)


copy into @my_s3_unload_stage/parquet_
from
emp_ext_stage
FILE_FORMAT=(TYPE='PARQUET' SNAPPY_COMPRESSION=TRUE)
