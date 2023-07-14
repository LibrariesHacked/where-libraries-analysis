create or replace view vw_areas as
select 
    code,
    name,
    string_agg(ba.auth_name, '/') as auth_names,
    geom,
    population,
    classification,
    min(min_imd_decile) as min_imd_decile
from (
    select 
        a.gsscode as code,
        a.name as name,
        a.geom as geom,
        min(imd.imd_decile) as min_imd_decile,
        sum(p.population) as population,
        case
            when sum(p.population) is null then 'Villages and small communities'
            when sum(p.population) < 7500 then 'Villages and small communities'
            when sum(p.population) >= 7500 and sum(p.population) < 25000 then 'Small Towns'
            when sum(p.population) >= 25000 and sum(p.population) < 60000 then 'Medium Towns'
            when sum(p.population) >= 60000 and sum(p.population) < 175000 then 'Large Towns'
            when sum(p.population) >= 175000 and sum(p.population) < 500000 then 'Cities'
            when sum(p.population) >= 500000 then 'Core cities'
            else null 
        end as classification
    from areas a
    left join oa_bua o
    on o.bua = a.gsscode
    left join oa_population p
    on p.oa = o.oa
    left join vw_oa_imd imd
    on imd.oa21 = o.oa
    where a.gsscode like 'E%'
    group by a.gsscode, a.name, a.geom) ars
join bua_auth ba
on ba.bua = ars.code
group by code, name, geom, population, classification;
