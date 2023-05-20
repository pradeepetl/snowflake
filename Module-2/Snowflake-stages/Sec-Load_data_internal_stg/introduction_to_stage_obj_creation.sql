create or replace transient database control_db;

create or replace schema external_stages;

create or replace schema internal_stages;

create or replace schema file_formats;

-- Create external stage

create or replace stage control_db.external_stages.my_ext_stage 
url='s3://snowflake067/test/'
credentials=(aws_key_id='AKIAUIIPUVJBJMSPABKO' 
aws_secret_key='bgQb6b816dzQdGkT+JPVqeiQ561B');

DESC STAGE control_db.external_stages.my_ext_stage

alter stage control_db.external_stages.my_ext_stage set credentials=(aws_key_id='d4c3b2a1' aws_secret_key='z9y8x7w6');

-- Create internal stage

create or replace stage control_db.internal_stages.my_int_stage

DESC STAGE control_db.internal_stages.my_int_stage

-- Create file format

 create or replace file format control_db.file_formats.my_csv_format
 type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true compression = gzip;
 
 desc file format control_db.file_formats.my_csv_format
 
-- Execute copy command

copy into sales
from @my_ext_stage
file_format = (FORMAT_NAME='my_csv_format' error_on_column_count_mismatch=false )
on_error = 'skip_file';

copy into emp_basic_external 
from s3://snowflake067/test/ credentials=(aws_key_id='AKIAUIIPUVJBJMSPABKO' aws_secret_key='bgQb6b816dzQdG6OZs+JPVqeiQ561B') 
file_format = (type = csv field_optionally_enclosed_by='"');

copy into emp_basic_local
from (select metadata$filename, metadata$file_row_number, t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 from @emp_basic_local t)
file_format = (type = csv field_optionally_enclosed_by='"')
pattern = '.*employees0[1-5].csv.gz'
on_error = 'skip_file';