/**************************************************************************/

/************** LOAD DATA FROM S3 TO SNOWFLAKE ******************/
--file_name string,
create or replace table demo_db.public.emp_ext_stage (
         --file_name string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

create or replace stage control_db.external_stages.my_s3_stage
  storage_integration = s3_int
  url = 's3://snowflakecrctest/emp/'
  file_format = control_db.file_formats.my_csv_format;
 

copy into demo_db.public.emp_ext_stage
from (select t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.external_stages.my_s3_stage/ t)
pattern = '.*employees0[1-5].csv'
on_error = 'CONTINUE';

copy into demo_db.public.emp_ext_stage
from (select  metadata$filename,t.$1  , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.external_stages.my_s3_stage/ t )
--pattern = '.*employees0[1-5].csv'
on_error = 'CONTINUE';

copy into demo_db.public.emp_ext_stage
from (select case when t.$1='Ron' then 'Gone' else t.$1 end , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.external_stages.my_s3_stage/ t )
--pattern = '.*employees0[1-5].csv'
on_error = 'CONTINUE';

TRUNCATE TABLE emp_ext_stage;

SELECT * FROM emp_ext_stage

select * from table(validate(emp_ext_stage, job_id=>'01a62908-3200-80f7-0001-4a360005d00a'));

