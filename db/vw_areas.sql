create or replace view vw_areas as
select 
    a.gsscode as code,
    a.name as name,
    a.geom as geom,
    sum(p.population) as population
from areas a
join oa_bua o
on o.bua = a.gsscode
join oa_population p
on p.oa = o.oa
where a.gsscode like 'E%'
group by a.gsscode, a.name, a.geom;
