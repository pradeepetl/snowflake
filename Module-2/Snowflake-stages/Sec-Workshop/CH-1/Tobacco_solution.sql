/**** Scenario-1 task 1 *****/
-- Create file format
        
create or replace file format my_csv_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true;

-- Create internal stage
create or replace stage My_internal_stage
file_format = my_csv_format;


CREATE OR REPLACE TRANSIENT TABLE TOBACCO
(
Year       NUMBER ,
Quarter NUMBER(1,0) ,
LocationAbbr VARCHAR(2) ,
LocationDesc VARCHAR(50) ,
TopicDesc VARCHAR ,
MeasureDesc VARCHAR(50) ,
DataSource VARCHAR(3) ,
ProvisionGroupDesc VARCHAR(50) ,
ProvisionDesc VARCHAR(50) ,
ProvisionValue VARCHAR ,
Citation VARCHAR ,
ProvisionAltValue NUMBER ,
DataType VARCHAR ,
Comments VARCHAR ,
Enacted_Date DATE ,
Effective_Date DATE ,
GeoLocation VARCHAR ,
DisplayOrder NUMBER ,
TopicTypeId VARCHAR(3) ,
TopicId VARCHAR(100) ,
MeasureId VARCHAR(20) ,
ProvisionGroupID VARCHAR(10) ,
ProvisionID NUMBER
);

snowsql -a cszyxhr-xr61722

put file:///Users/phchannappa/Downloads/CDC_STATE_System_Tobacco_Legislation_-_Smokefree_Indoor_Air.csv @control_db.internal_stages.My_internal_stage/Tobacco/;

list @My_internal_stage

truncate table demo_db.public.tobacco

select * from demo_db.public.tobacco limit 100

Copy into demo_db.public.tobacco
          from (select $1,
                        $2,
                        iff($3='GU','GK',$3),
                        $4,
                        $5,
                        $6,
                        $7,
                        $8,
                        $9,
                        $10,
                        $11,
                        $12,
                        $13,
                        $14,
                        $15,
                        $16,
                        array_construct($17),
                        $18,
                        $19,
                        $20,
                        $21,
                        $22,
                        $23
from
@My_internal_stage/Tobacco/) 


-- alter the stage object.
             
alter stage  My_internal_stage
set copy_options = (on_error='continue');

--desc stage My_internal_stage
--desc file format my_csv_format


select *  from table(validate(tobacco , job_id => '_last')) ;

alter file format my_csv_format set
FIELD_OPTIONALLY_ENCLOSED_BY=none;


                                  