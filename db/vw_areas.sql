create or replace view vw_areas as
select 
    code,
    name,
    string_agg(ba.auth_name, '/') as auth_names,
    geom,
    population
from (
    select 
        a.gsscode as code,
        a.name as name,
        a.geom as geom,
        sum(p.population) as population
    from areas a
    left join oa_bua o
    on o.bua = a.gsscode
    left join oa_population p
    on p.oa = o.oa
    where a.gsscode like 'E%'
    group by a.gsscode, a.name, a.geom) ars
join bua_auth ba
on ba.bua = ars.code
group by code, name, geom, population;
