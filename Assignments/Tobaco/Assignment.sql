CREATE OR REPLACE TRANSIENT TABLE TOBACCO

(

        Year	NUMBER	,
        Quarter	NUMBER(1,0)	,
        LocationAbbr	VARCHAR(2)	,
        LocationDesc	VARCHAR(50)	,
        TopicDesc	VARCHAR	,
        MeasureDesc	VARCHAR(50)	,
        DataSource	VARCHAR(3)	,
        ProvisionGroupDesc	VARCHAR(50)	,
        ProvisionDesc	VARCHAR(50)	,
        ProvisionValue	VARCHAR	,
        Citation	VARCHAR	,
        ProvisionAltValue	NUMBER	,
        DataType	VARCHAR	,
        Comments	VARCHAR	,
        Enacted_Date	DATE	,
        Effective_Date	DATE	,
        GeoLocation	ARRAY	,
        DisplayOrder	NUMBER	,
        TopicTypeId	VARCHAR(3)	,
        TopicId	VARCHAR(100)	,
        MeasureId	VARCHAR(20)	,
        ProvisionGroupID	VARCHAR(10)	,
        ProvisionID	NUMBER	


)


-- STEP 3:

        -- Create file format
        
           create or replace file format control_db.file_formats.my_csv_format
           type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true;
           
        -- create or replace stage control_db.internal_stages.My_internal_stage
            file_format = control_db.file_formats.my_csv_format;
            
            
-- STEP 4 :

           snowsql -a <your-account-id>.us-east-1
           
           
            put file:///Users/phchannappa/Downloads/CDC_STATE_System_Tobacco_Legislation_-_Smokefree_Indoor_Air.csv @control_db.internal_stages.My_internal_stage/Tobacco/;
                                  
           
           
-- STEP 5 :

          select t.$1, t.$2, t.$3, t.$4,t.$5 from @control_db.internal_stages.My_internal_stage/Tobacco/ t


          select count(*) from @control_db.internal_stages.My_internal_stage/Tobacco/ t
          
          
-- STEP 6 :

          Copy into demo_db.public.tobaco
          from (select $1,
                        $2,
                        iif($3=='GU','GK'),
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
                        $17,
                        $18,
                        $19,
                        $20,
                        $21,
                        $22,
                        $23
from
@control_db.internal_stages.My_internal_stage/Tobacco/)  --- you will see error.


       -- alter the stage object.
       
       
        alter stage  control_db.internal_stages.My_internal_stage
        set copy_options = (on_error='continue');
        
    -- execute copy command again.
    
         -- You will see few records getting loaded but most of the records will not load.
         
         -- Reason for this is,
         
            For column, ProvisionValue we have some values like , "Any Peace Officer, any employee of the Department of Public Health and Social Services and Guam Environmental Protection Agency when so authorized, and any citizen."
            
            with in value you have `,` hence snowflake is not able to ignore `,` with in qoutes.
            
            alter the file format using the below command,
            
                alter file format control_db.file_formats.my_csv_format set
                FIELD_OPTIONALLY_ENCLOSED_BY='\"';
            
            
            
 -- execute copy command again.
 
           
            -- for GeoLocation column you will see error. To fix it you need to use array_construct function.
            
                      Copy into demo_db.public.TOBACCO
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
                        @control_db.internal_stages.My_internal_stage/Tobacco/);
            
             select * from demo_db.public.TOBACCO;
          