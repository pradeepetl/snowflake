/**************************************************************************************************************/
create database demo_db;
create database control_db;
create schema external_stages;
create schema file_formats;

--- AWS S3 Configuration.

create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::579834220952:role/snowflake_crc_role'
  storage_allowed_locations = ('s3://snowflakecrctest/emp/');

DESC INTEGRATION s3_int;

create or replace stage control_db.external_stages.my_s3_stage
  storage_integration = s3_int
  url = 's3://snowflakecrctest/emp/'
  file_format = control_db.file_formats.my_csv_format;

/*********** External tables in snowflake *******************/
             
/*********** Lecture: introduction to external tables *******************/

		CREATE OR REPLACE EXTERNAL TABLE ext_table
		 WITH LOCATION = @control_db.external_stages.my_s3_stage
		 FILE_FORMAT = (TYPE = CSV);


		desc table ext_table

		select * from ext_table

		select 
		value:c1::int as ID, 
		value:c2::varchar as name , 
		value:c3::int as dept from sample_ext;

		/*************** Create external table with column *****************/

		create or replace table demo_db.public.emp_ext_stage (
			 --file_name string,
			 first_name string ,
			 last_name string ,
			 email string ,
			 streetaddress string ,
			 city string ,
			 start_date date
		);
		create database demo_db;


		create or replace external table emp_ext_table
		(first_name string as  (value:c1::string), 
		last_name string(20) as ( value:c2::string), 
		email string as (value:c3::string))
		WITH LOCATION =  @control_db.external_stages.my_s3_stage
		 FILE_FORMAT = (TYPE = CSV);

		select * from emp_ext_table


/*************** Lecture: Why external tables.(Get metadata information) *****************/

		select *
		from table(information_schema.external_table_files(TABLE_NAME=>'emp_ext_table'));

		56329893e1a6437c1224835c5197881d
		0d17bceb5358bb37c7766e999b1e9e3b

		select *
		from table(information_schema.external_table_file_registration_history(TABLE_NAME=>'emp_ext_table'));


		ALTER EXTERNAL TABLE emp_ext_table REFRESH;


/*************** Lecture: Insert scenario (query ext table) *****************/
/*************** Lecture: Delete scenario (query ext table) *****************/
/*************** Lecture: Update scenario (query ext table) *****************/

		select * from emp_ext_table

		ALTER EXTERNAL TABLE emp_ext_table REFRESH;

/*************** Lecture: Partition in external tables.(Filter data) ************/

		select * from emp_ext_table where first_name='John'

		select * from emp_ext_table where file_name_part='employees03' and first_name in ('John','Chandru')

		/emp/employee01.csv

		employee03

		create or replace external table emp_ext_table
		(
		file_name_part varchar AS SUBSTR(metadata$filename,5,11),
		first_name string as  (value:c1::string), 
		last_name string(20) as ( value:c2::string), 
		email string as (value:c3::string))
		PARTITION BY (file_name_part)
		WITH LOCATION =  @control_db.external_stages.my_s3_stage
		FILE_FORMAT = (TYPE = CSV);

/*************** Lecture: Manual partition in external tables (Add partitions manually) ************/

		alter storage integration s3_int set  
		storage_allowed_locations=('s3://snowflakecrctest/emp/',
				           's3://snowflakecrctest/emp_unload/','s3://snowflakecrctest/zip_folder/',
				           's3://snowflakecrctest/emp_partitions/');

		create or replace stage control_db.external_stages.my_s3_stage_partition
		  storage_integration = s3_int
		  url = 's3://snowflakecrctest/emp_partitions/'
		  file_format = control_db.file_formats.my_csv_format;


		create or replace external table emp_ext_table_partitions
		(
		customer_type string as  (parse_json(metadata$external_table_partition)::string),
		first_name string as  (value:c1::string), 
		last_name string(20) as ( value:c2::string)
		)
		PARTITION BY (customer_type)
		PARTITION_TYPE = USER_SPECIFIED
		WITH LOCATION =  @control_db.external_stages.my_s3_stage_partition
		FILE_FORMAT = (TYPE = CSV)

		ALTER EXTERNAL TABLE emp_ext_table_partitions REFRESH;

		select * from emp_ext_table_partitions

		select * from emp_ext_table_partitions where customer_type='Gold_customer'

		ALTER EXTERNAL TABLE emp_ext_table_partitions ADD PARTITION (customer_type='Gold_customer') location 'Gold_customer/'

		ALTER EXTERNAL TABLE emp_ext_table_partitions ADD PARTITION (customer_type='platinum_customer') location 'platinum_customer/'


/********************** Lecture: Auto refresh metadata(Auto refresh) *********************/
		select * from emp_ext_table

		ALTER EXTERNAL TABLE emp_ext_table REFRESH;

		SHOW EXTERNAL TABLES;

		create or replace external table emp_ext_table
		(
		file_name_part varchar AS SUBSTR(metadata$filename,5,11),
		first_name string as  (value:c1::string), 
		last_name string(20) as ( value:c2::string), 
		email string as (value:c3::string))
		PARTITION BY (file_name_part)
		WITH LOCATION =  @control_db.external_stages.my_s3_stage
		FILE_FORMAT = (TYPE = CSV)
		auto_refresh=true;







