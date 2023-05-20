--- AWS S3 Configuration.

USE ROLE ACCOUNTADMIN;

create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::579834220952:role/snowflake_crc_role'
  storage_allowed_locations = ('s3://snowflakecrctest/emp/');

DESC INTEGRATION s3_int;

