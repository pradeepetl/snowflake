create or replace stage population;

PUT file:///workspace/snowflake/Module-2/Snowflake-stages/Data/Practice_data/countries/a* @population/countries_a/;

list @population;