/************************* Methods to load unstructured data **********************/


/*********************** Book data ******************************/

https://data.mendeley.com/datasets/ct8f9skv97/1


CREATE OR REPLACE  FILE FORMAT "DEMO_DB"."PUBLIC".JSON_FORMAT 
type=JSON

create or replace table book( v variant)

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
}')

select * from book

OID , AUTHOR , TITLE , BOOKTITLE , YEAR , TYPE 

select v:"_id":"$oid" as OID,v:"author"::array as AUTHOR , v:"title"::string as TITLE, v:"booktitle"::string as BOOKTITLE , v:"year"::int as YEAR, v:"type"::string as TYPE from book

create or replace stage MY_S3_UNLOAD_STAGE
storage_integration = s3_int
url = 's3://hartfordstar/'
file_format = my_csv_s3_format;

create or replace file format my_csv_s3_format
type = csv field_delimiter = ',' skip_header = 0 null_if = ('NULL', 'null') 
empty_field_as_null = true compression = gzip FIELD_OPTIONALLY_ENCLOSED_BY='"';

create or replace file format JSON_FORMAT
type = JSON

select $1 from
@MY_S3_UNLOAD_STAGE/dblp.json
(file_format =>JSON_FORMAT)

CREATE OR REPLACE TRANSIENT TABLE BOOK_JSON_RAW
(book variant)

copy into BOOK_JSON_RAW
from
@MY_S3_UNLOAD_STAGE/dblp.json
file_format =JSON_FORMAT

select * from BOOK_JSON_RAW

select 
book:"_id":"$oid" as OID,
book:"author"::array as AUTHOR , 
book:"title"::string as TITLE,
book:"booktitle"::string as BOOKTITLE ,
book:"year"::string as YEAR,
book:"type"::string as TYPE
from BOOK_JSON_RAW




CREATE OR REPLACE TRANSIENT TABLE BOOK_JSON_DATA
(
OID VARCHAR,
AUTHOR VARCHAR,
TITLE VARCHAR,
BOOKTITLE VARCHAR,
YEAR NUMBER,
TYPE VARCHAR
)

INSERT INTO BOOK_JSON_DATA
select 
book:"_id":"$oid" as OID,
book:"author"::string as AUTHOR , 
book:"title"::string as TITLE,
book:"booktitle"::string as BOOKTITLE ,
book:"year"::int as YEAR,
book:"type"::string as TYPE
from BOOK_JSON_RAW

select * from BOOK_JSON_DATA


select 
$1:"_id":"$oid" as OID,
$1:"author"::array as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::int as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/dblp.json
(file_format =>JSON_FORMAT)

select 
$1:"_id":"$oid" as OID,
$1:"author"::array as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::string as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/dblp.json
(file_format =>JSON_FORMAT)
where $1:"year"='["2013","2013"]'

select * from BOOK_JSON_DATA limit 10

copy into BOOK_JSON_DATA
from(
select 
$1:"_id":"$oid" as OID,
$1:"author"::array as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::int as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/dblp.json
(file_format =>JSON_FORMAT)
)
ON_ERROR='CONTINUE'





copy into @%BOOK_JSON_DATA
from(
select 
$1:"_id":"$oid" as OID,
$1:"author"::string as AUTHOR , 
$1:"title"::string as TITLE,
$1:"booktitle"::string as BOOKTITLE ,
$1:"year"::string as YEAR,
$1:"type"::string as TYPE 
from @MY_S3_UNLOAD_STAGE/dblp.json
(file_format =>JSON_FORMAT)
)

copy into BOOK_JSON_DATA
from @%BOOK_JSON_DATA
file_format =(type='csv')
ON_ERROR='CONTINUE'

TRUNCATE TABLE BOOK_JSON_DATA

copy into BOOK_JSON_DATA
from @%BOOK_JSON_DATA
file_format =(type='csv')
ON_ERROR='CONTINUE'
PURGE = TRUE

select * from BOOK_JSON_DATA

