Create or replace json_reject_records
As
select * from table(validate(BOOK_JSON_DATA , job_id=>'<query_id>'));