-- Create emp table.

 create or replace table emp (
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);

-- Load data into table ignoring rejected records.

copy into emp
from @my_s3_stage
file_format = (type = csv field_optionally_enclosed_by='"')
--pattern = '.*employees0[1-5].csv'
ON_ERROR='CONTINUE';

-- Check for rejected records.

select * from table(validate(emp, job_id=>'018ff817-0317-f8b7-0000-e5fd0001551e'));

-- Save rejected records to reprocess in future.

create table copy_rejects
as
select * from table(validate(emp, job_id=>'018ff817-0317-f8b7-0000-e5fd0001551e'));


-- Lessons learned.

1. How to load ingnore records while loading data into table.
2. How to retrieve rejected records.