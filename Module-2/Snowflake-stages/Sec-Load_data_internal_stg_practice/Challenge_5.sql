
create table demo_db.public.population
(
file_name varchar,
country	varchar,
Year	varchar,
Population	varchar,
Yearly_percentage_change	varchar,
Yearly_Change	varchar,
Migrants_net	varchar,
Median_Age	varchar,
Fertility_Rate	varchar,
Density_P_Km_sq	varchar,
Urban_Pop_percentage	varchar,
Urban_Population	varchar,
Country_Share_of_WorldPop	varchar,
World_Population	varchar,
Rank	varchar
);

copy into demo_db.public.population
from (select metadata$filename, t.$1,t.$2,t.$3,t.$4,t.$5,t.$6,t.$7,t.$8,t.$9,t.$10,t.$11,
t.$12,t.$13,t.$14
from @population/countries_a/ t)
file_format = my_csv_format


select * from demo_db.public.population;