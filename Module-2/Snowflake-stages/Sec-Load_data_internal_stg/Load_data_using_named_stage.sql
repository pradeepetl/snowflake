-- Load data using named stage.

  create or replace table demo_db.public.emp_basic_named_stage 
 (
         file_name string,
         fie_row_number string,
         first_name string ,
         last_name string ,
         email string ,
         streetaddress string ,
         city string ,
         start_date date
);


create or replace stage control_db.internal_stages.my_int_stage;

desc stage control_db.internal_stages.my_int_stage

put file:///workspace/snowflake/Module-2/Snowflake-stages/Data/Employee/employees0*.csv @control_db.internal_stages.my_int_stage/emp_basic_named_stage;

TRUNCATE TABLE demo_db.public.emp_basic_local;

copy into demo_db.public.emp_basic_local
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.internal_stages.my_int_stage/emp_basic_named_stage t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';

TRUNCATE TABLE demo_db.public.emp_basic_named_stage;

copy into demo_db.public.emp_basic_named_stage
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @control_db.internal_stages.my_int_stage/emp_basic_named_stage t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';

select * from demo_db.public.emp_basic_named_stage;
