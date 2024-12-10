ENFORCE_LENGTH = TRUE | FALSE
TRUNCATECOLUMNS = TRUE | FALSE

desc stage my_s3_stage

select * from emp

truncate table emp

copy into emp
from @my_s3_stage
file_format = (type = csv field_optionally_enclosed_by='"')
--pattern = '.*employees0[1-5].csv'
ON_ERROR='CONTINUE'
--TRUNCATECOLUMNS = TRUE
ENFORCE_LENGTH = FALSE