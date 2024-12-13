----------------- METHOD 1 --------------------
-- Create database if not exist
create database demo_db;
use demo_db;

-- create file format to parse json file
create or replace file format JSON_FORMAT
type = JSON;

--drop stage MY_S3_UNLOAD_STAGE

-- Create stage objete to read s3 file.
create or replace stage MY_S3_UNLOAD_STAGE
url = 's3://semistructdata067'
file_format = JSON_FORMAT;

-- check if you are able to access the s3 file.
ls @MY_S3_UNLOAD_STAGE;


-- Before we go and read the data from s3 let's check for sample record
create or replace table book( v variant);

insert into book
select 
parse_json('{
   "_id":{
      "$oid":"595c2c59a7986c0872002043"
   },
   "mdate":"2017-05-24",
   "author":[
      "Injoon Hong",
      "Seongwook Park",
      "Junyoung Park",
      "Hoi-Jun Yoo"
   ],
   "ee":"https://doi.org/10.1109/ASSCC.2015.7387453",
   "booktitle":"A-SSCC",
   "title":"A 1.9nJ/pixel embedded deep neural network processor for high speed visual attention in a mobile vision recognition SoC.",
   "pages":"1-4",
   "url":"db/conf/asscc/asscc2015.html#HongPPY15",
   "year":"2015",
   "type":"inproceedings",
   "_key":"conf::asscc::HongPPY15",
   "crossref":[
      "conf::asscc::2015"
   ]
}');

select * from book;

-- We need to select these columns from the source.
--OID , AUTHOR , TITLE , BOOKTITLE , YEAR , TYPE 

select v:"_id":"$oid" as OID,v:"author"::array as AUTHOR , v:"title"::string as TITLE, v:"booktitle"::string as BOOKTITLE , v:"year"::int as YEAR, v:"type"::string as TYPE from book


-- Try to read the data from s3 directly,
-- Don't forget to use the limit clause!!
select $1 from
@MY_S3_UNLOAD_STAGE/bookdata/dblp.json
(file_format =>JSON_FORMAT)
limit 100

-- Create snowflake table to load data.

CREATE OR REPLACE TRANSIENT TABLE BOOK_JSON_RAW
(book variant);

-- Copy data to snowflake table from s3,

copy into BOOK_JSON_RAW
from
@MY_S3_UNLOAD_STAGE/bookdata/dblp.json
file_format =JSON_FORMAT;

-- select data from snwoflake table,
select * from BOOK_JSON_RAW limit 100;

select 
book:"_id":"$oid" as OID,
book:"author"::array as AUTHOR , 
book:"title"::string as TITLE,
book:"booktitle"::string as BOOKTITLE ,
book:"year"::string as YEAR,
book:"type"::string as TYPE
from BOOK_JSON_RAW;

-------------- METHOD 2 ----------------------
-- Create incremental table to store the json data.
CREATE OR REPLACE TRANSIENT TABLE BOOK_JSON_DATA
(
OID VARCHAR,
AUTHOR VARCHAR,
TITLE VARCHAR,
BOOKTITLE VARCHAR,
YEAR VARCHAR,
TYPE VARCHAR
);

INSERT INTO BOOK_JSON_DATA
select 
book:"_id":"$oid" as OID,
book:"author"::string as AUTHOR , 
book:"title"::string as TITLE,
book:"booktitle"::string as BOOKTITLE ,
book:"year"::int as YEAR,
book:"type"::string as TYPE
from BOOK_JSON_RAW;

select * from BOOK_JSON_DATA

---------------- METHOD 3 ---------------

copy into BOOK_JSON_DATA
from(
select 
$1:"_id":"$oid" as OID,
$1:"author"::array as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::int as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/bookdata/dblp.json
(file_format =>JSON_FORMAT)
)
ON_ERROR='CONTINUE';


copy into @%BOOK_JSON_DATA
from(
select 
$1:"_id":"$oid" as OID,
$1:"author"::string as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::string as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/bookdata/dblp.json
(file_format =>JSON_FORMAT)
);

ls @%BOOK_JSON_DATA;

copy into BOOK_JSON_DATA
from @%BOOK_JSON_DATA
file_format =(type='csv')
ON_ERROR='CONTINUE';

TRUNCATE TABLE BOOK_JSON_DATA;

copy into BOOK_JSON_DATA
from @%BOOK_JSON_DATA
file_format =(type='csv')
ON_ERROR='CONTINUE'
PURGE = TRUE;

