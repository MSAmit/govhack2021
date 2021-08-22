drop table if exists dev_amit.poi_with_sa2;
select count(*) as count_poi_type,"POITYPE", sa2.sa2_16main,sa2.geom
    as sa2_geom
into dev_amit.poi_with_sa2
from dev_amit.poi_nsw poi
join admin_bdys_202102.abs_2016_sa2 sa2
on st_within(poi.geom,st_transform(sa2.geom,4326))
group by "POITYPE", sa2_16main,sa2.geom;

drop table if exists t1;
select *, count_poi_type::decimal/(obs_value) as pois_per_pop
into temp t1
from dev_amit.poi_with_sa2
join dev_amit.abs_pop_by_sa2_2019
on sa2_16main::text = region and obs_value > 0;

drop table if exists dev_amit.poi_per_pop_avg_nsw;
select avg(pois_per_pop), "POITYPE"
into dev_amit.poi_per_pop_avg_nsw
from t1
group by "POITYPE"
having avg(pois_per_pop) > 0;

select * from dev_amit.poi_per_pop_avg_nsw;

drop table if exists dev_amit.sa2_poi_pop_index_lookout;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_lookout
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Lookout';

drop table if exists dev_amit.sa2_poi_pop_index_camping_ground;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_camping_ground
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Camping Ground';

drop table if exists dev_amit.sa2_poi_pop_index_sports_field;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_sports_field
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Sports Field';

drop table if exists dev_amit.sa2_poi_pop_index_monument;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_monument
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Monument';

drop table if exists dev_amit.sa2_poi_pop_index_picnic_area;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_picnic_area
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Picnic Area';

drop table if exists dev_amit.sa2_poi_pop_index_park;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_park
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Park';

drop table if exists dev_amit.sa2_poi_pop_index_gog_track;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_gog_track
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Dog Track';

drop table if exists dev_amit.sa2_poi_pop_index_sports_centre;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_sports_centre
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Sports Centre';

drop table if exists dev_amit.sa2_poi_pop_index_cycling_track;
select t1.*, ((pois_per_pop - state_avg.avg)::decimal /(state_avg.avg)) * 100 as poi_index_sa2
into dev_amit.sa2_poi_pop_index_cycling_track
from t1 as t1
join dev_amit.poi_per_pop_avg_nsw state_avg
on t1."POITYPE" = state_avg."POITYPE" and state_avg."POITYPE" = 'Cycling Track';