-- Create emp table.

 create or replace table emp (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

-- Remove files from staging area.

copy into emp
from @my_s3_stage
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv'
ON_ERROR='CONTINUE'
FORCE = TRUE;