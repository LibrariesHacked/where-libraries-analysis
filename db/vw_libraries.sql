create or replace view vw_libraries as
select 
    l.authority as authority,
    l.name as name,
    p.postcode as postcode,
    p.geom as geom
from libraries l
join postcodes p on l.postcode = p.postcode;
