select * from information_schema.load_history
  order by last_load_time desc
  
select * from information_schema.load_history
  where schema_name='PUBLIC' and
  table_name='EMP'