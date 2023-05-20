/*****************************************************************************/

-- Copy zip files

create or replace stage my_s3_zip_stage
  storage_integration = s3_int
  url = 's3://snowflakecrctest/zip_folder/'
  file_format = control_db.file_formats.my_csv_format;
  
truncate table emp_ext_stage

select * from emp_ext_stage

copy into emp_ext_stage
from (select t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @my_s3_zip_stage/ t)
--pattern = '.*employees0[1-5].csv'
on_error = 'CONTINUE';

https://stackoverflow.com/questions/58513984/how-to-load-a-table-with-multiple-zip-files-in-snowflake

