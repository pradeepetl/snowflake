/********************************************************************************/
truncate table HR_EMP_DATA

CREATE TABLE HR_EMP_DATA
(
Emp_ID	VARCHAR,
Name_Prefix	VARCHAR,
First_Name	VARCHAR,
Middle_Initial	VARCHAR,
Last_Name	VARCHAR,
Gender	VARCHAR,
E_Mail	VARCHAR,
Father_Name	VARCHAR,
Mother_Name	VARCHAR,
Mother_Maiden_Name	VARCHAR,
Date_of_Birth	VARCHAR,
Time_of_Birth	VARCHAR,
Age_in_Yrs	VARCHAR,
Weight_in_Kgs	VARCHAR,
Date_of_Joining	VARCHAR,
Quarter_of_Joining	VARCHAR,
Half_of_Joining	VARCHAR,
Year_of_Joining	VARCHAR,
Month_of_Joining	VARCHAR,
Month_Name_of_Joining	VARCHAR,
Short_Month	VARCHAR,
Day_of_Joining	VARCHAR,
DOW_of_Joining	VARCHAR,
Short_DOW	VARCHAR,
Age_in_Company	VARCHAR,
Salary	VARCHAR,
Last_Hike	VARCHAR,
SSN	VARCHAR,
Phone 	VARCHAR,
Place_Name	VARCHAR,
County	VARCHAR,
City	VARCHAR,
State	VARCHAR,
Zip	VARCHAR,
Region	VARCHAR,
User_Name	VARCHAR,
Password	VARCHAR
)


CREATE TABLE CREDIT_CARD
(
Date	VARCHAR,
Description	VARCHAR,
Deposits	VARCHAR,
Withdrawls	VARCHAR,
Balance	VARCHAR
)

put file:///Users/pradeep/Downloads/HR_CREDIT.csv @My_internal_stage/Hr_data/;


COPY INTO HR_EMP_DATA
      from @DEMO_DB.PUBLIC.My_internal_stage/Hr_data/
      file_format = (FORMAT_NAME ='my_csv_format'       
      ERROR_ON_COLUMN_COUNT_MISMATCH= TRUE  field_optionally_enclosed_by='"')
      ON_ERROR = 'CONTINUE'

select * from table(validate(CREDIT_CARD, job_id=>'01b033db-3200-ed71-0006-b09e00034056'));


COPY INTO  CREDIT_CARD
      from @DEMO_DB.PUBLIC.My_internal_stage/Hr_data/
      file_format = (FORMAT_NAME ='my_csv_format'
      ERROR_ON_COLUMN_COUNT_MISMATCH= TRUE  field_optionally_enclosed_by='"')
      ON_ERROR = 'CONTINUE'

      select * from credit_card







