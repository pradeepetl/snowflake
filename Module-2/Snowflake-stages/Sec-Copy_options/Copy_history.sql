select *
from table(information_schema.copy_history(table_name=>'emp', start_time=> dateadd(hours, -5, current_timestamp())))
where error_count >0

select *
from table(information_schema.copy_history(table_name=>'emp'));