create or replace file format demo_db.public.my_csv_format;

alter file format demo_db.public.my_csv_format
set skip_header=1

desc file format demo_db.public.my_csv_format;

copy into demo_db.public.population
from '@population/countries_a/afghanistan-population.csv.gz'
file_format = my_csv_format

