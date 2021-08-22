select crime.*, lga.geom
into dev_amit.lga_homicides_geom
from dev_amit.lga_homicides crime
         join dev_amit."LGA_2020_AUST" lga
              on LEFT(lga_name20, -4) = crime.lga;

create index lga_homicides_gidx on dev_amit.lga_homicides_geom using gist (geom);
analyse dev_amit.lga_homicides_geom;

drop table if exists dev_amit.lga_homicides_geom_poi;
select "POITYPE",
       count("POITYPE") as number_of_poi,
       lga.geom as geom,
       lga as lga_name,
       avg(lga."Rate") as lga_homicides_rate
into dev_amit.lga_homicides_geom_poi
from dev_amit.lga_homicides_geom lga
         join dev_amit.poi_nsw poi on st_within(poi.geom, st_transform(lga.geom, 4326))
group by poi."POITYPE", lga.geom, lga.lga;
