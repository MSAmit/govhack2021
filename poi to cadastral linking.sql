drop table if exists dev_amit.sa2_cadastral;
select lots.plan_label, lots.geom
into dev_amit.sa2_cadastral
from dla_consolidated_planning.cadastral_lot lots
join admin_bdys_202102.abs_2016_sa2 sa2 on st_distance(lots.geom::geography, sa2.geom::geography) < 15000
where sa2_16main = 125041493;

create index  cadastral_lot_gidx on dla_consolidated_planning.cadastral_lot using gist(geom);
analyse dla_consolidated_planning.cadastral_lot;

select lots.*, closest_poi.geom as poi_geom, closest_poi."POITYPE"
into dev_amit.closest_pois_from_lots
from dev_amit.sa2_cadastral lots
join lateral
    (select poi.geom, "POITYPE"
        from dev_amit.poi_nsw poi
        group by "POITYPE", poi.geom, lots.geom
        order by st_transform(poi.geom, 4283) <-> lots.geom
        limit 1) closest_poi on true
;

drop table if exists dev_amit.poi_with_households;
select count(plan_label), "POITYPE", poi_geom
into dev_amit.poi_with_households
from dev_amit.closest_pois_from_lots
group by "POITYPE", poi_geom;

drop table if exists dev_amit.poi_number_households;
select poi.*,poi_households.geom as lot_geom, plan_label
into dev_amit.poi_number_households
from dev_amit.poi_nsw poi
join lateral (
    select lots.geom, plan_label
    from dev_amit.sa2_cadastral lots
    order by st_transform(poi.geom, 4283) <-> lots.geom
    limit 1) poi_households on true
;

alter table dev_amit.poi_nsw
    ADD COLUMN geom_4283 geometry;

UPDATE dev_amit.poi_nsw
SET geom_4283 = st_transform(geom, 4283);

create index poi_nsw_gidx on dev_amit.poi_nsw using gist(geom_4283);
analyse dev_amit.poi_nsw;


select lots.*, closest_poi.geom as poi_geom, closest_poi."POITYPE"
into dev_amit.poi_closest_households
from dev_amit.sa2_cadastral lots
join lateral
    (select poi.geom, "POITYPE"
        from dev_amit.poi_nsw poi
        where poi."POITYPE" = 'Sports Centre'
        order by poi.geom_4283 <-> lots.geom
        limit 1) closest_poi on true
;

create index poi_parking_area_gidx on dev_amit.poi_parking_area using gist(geom);
analyse dev_amit.poi_parking_area

drop table if exists dev_amit.parking_within_1k_poi;
select parking.*
    into dev_amit.parking_within_1k_poi
        from dev_amit.poi_parking_area parking
join dev_amit.poi_closest_households poi
on st_distance(poi.geom::geography, st_transform(parking.geom, 4283)::geography) < 1000
where poi.plan_label = 'DP236393';