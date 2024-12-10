/*** you will see error ****/
copy into demo_db.public.population
from '@population/countries_a/'
file_format = my_csv_format

alter file format my_csv_format
set error_on_column_count_mismatch=false


copy into demo_db.public.population
from '@population/countries_a/'
file_format = my_csv_format