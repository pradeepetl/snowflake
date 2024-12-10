copy into demo_db.public.population
from (select split_part(metadata$filename,'/',2), t.$1,t.$2,t.$3,
replace(t.$4,'%',''),t.$5,t.$6,t.$7,t.$8,t.$9,t.$10,t.$11,
t.$12,t.$13,t.$14
from @population/countries_a/ t)
file_format = my_csv_format;