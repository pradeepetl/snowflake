/*****************************************************************************/

select * from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER


create stage data_stage;

copy into @data_stage/call_center
from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER;

select count(*) from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER;

select count(*) from @data_stage/call_center




copy into @data_stage/call_center/PARQUET_
from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER
       file_format=(type=parquet)

       
copy into @data_stage/call_center/XML_
from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER
       file_format=(type=XML)

copy into @data_stage/call_center/AVRO_
from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER
       file_format=(type=AVRO)

copy into @data_stage/call_center/JSON_
from
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER
       file_format=(type=JSON)


copy into @data_stage/call_center/JSON_
from
( select object_construct(*) from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER )
file_format=(type=JSON)



copy into @data_stage/call_center/select_/
from
(
  select
  cc_name,
  cc_class,
  cc_employees
  from
  SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CALL_CENTER
)


get @data_stage/call_center/select_/ file:///Users/pradeep/Downloads/

list @data_stage