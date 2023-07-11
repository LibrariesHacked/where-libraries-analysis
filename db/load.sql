create table postcodes_staging (
    geom text,
    postcode text
);


\copy postcodes_staging from 'data/england_postcodes.csv' csv header;

insert into postcodes(postcode, geom)
select postcode, st_transform(st_geomfromtext(geom, 4326), 27700)
from postcodes_staging;

drop table postcodes_staging;


create table areas_staging (
    gsscode text,
    name1_text text,
    name1_language text,
    name2_text text,
    name2_language text,
    areahectares numeric,
    geometry_area_m numeric,
    geom text
);

\copy areas_staging from 'data/built_up_areas.csv' csv header;

insert into areas(gsscode, name, geom) 
select gsscode, name1_text, st_geomfromtext(geom, 27700)
from areas_staging;

drop table areas_staging;


\copy libraries from 'data/england_library_postcodes.csv' csv header;

-- convert all library postcodes to uppercase
update libraries set postcode = upper(postcode);

-- remove trailing whitespace
update libraries set postcode = trim(postcode);

-- other postcode fixes
update libraries set postcode = 'B34 7AQ' where name = 'Shard End Library' and postcode = 'B34 7AG';
update libraries set postcode = 'BD16 1GL' where name = 'Bingley Library' and postcode = 'BD16 1AW';
update libraries set postcode = 'CA1 3SN' where name = 'Harraby Library Link' and postcode = 'CA1 3PP';
update libraries set postcode = 'SK22 3BR' where name = 'New Mills' and postcode = 'SK22 4AR';
update libraries set postcode = 'TN31 7JG' where name = 'Rye Library' and postcode = 'TN31 7JL';
update libraries set postcode = 'CM1 1GE' where name = 'Chelmsford Library' and postcode = 'CM1 1LH';
update libraries set postcode = 'GL50 3JT' where name = 'Cheltenham Children''s library' and postcode = 'GL50 3JY';
update libraries set postcode = 'WD19 7FD' where name = 'Oxhey Library (South Oxhey)' and postcode = 'WD19 7AG';
update libraries set postcode = 'CT12 6FA' where name = 'Newington Library' and postcode = 'CT12 6NB';
update libraries set postcode = 'SE27 9NS' where name = 'West Norwood' and postcode = 'SE27 9JX';
update libraries set postcode = 'PR1 2PP' where name = 'Preston Harris' and postcode = 'PR1 1HT';
update libraries set postcode = 'M19 3BP' where name = 'Arcadia library & Leisure Centre' and postcode = 'M19 3PH';
update libraries set postcode = 'NE5 4BR' where name = 'Newbiggin Hall Library' and postcode = 'NE5 4BZ';
update libraries set postcode = 'IP22 4DD' where name = 'Diss Library' and postcode = 'IP22 3DD';
update libraries set postcode = 'NN17 1PD' where name = 'Corby' and postcode = 'NN17 1QJ';
update libraries set postcode = 'NE12 7LJ' where name = 'Forest Hall Library' and postcode = 'NE12 0LJ';
update libraries set postcode = 'NG1 7FF' where name = 'Nottingham Central Library' and postcode = 'NG1 6HP';
update libraries set postcode = 'NG22 9TH' where name = 'Dukeries' and postcode = 'NG22 9TD';
update libraries set postcode = 'M35 0FH' where name = 'Failsworth Library' and postcode = 'M35 0FJ';
update libraries set postcode = 'OX4 6JZ' where name = 'Littlemore' and postcode = 'OX4 5JY';
update libraries set postcode = 'TS12 2HP' where name = 'Skelton Library' and postcode = 'TS12 2HN';
update libraries set postcode = 'M27 6FA' where name = 'Swinton Gateway Library' and postcode = 'M27 6BP';
update libraries set postcode = 'BS15 9AG' where name = 'Kingswood' and postcode = 'BS15 9TR';
update libraries set postcode = 'NE33 1JF' where name = 'The Word Library' and postcode = 'NE33 1DX';
update libraries set postcode = 'TS17 7EW' where name = 'Thornaby Central Library & Customer Service Centre' and postcode = 'TS17 9EU';
update libraries set postcode = 'CO10 0NH' where name = 'Great Cornard' and postcode = 'CO10 0JU';
update libraries set postcode = 'KT14 6LB' where name = 'West Byfleet' and postcode = 'KT14 6NY';
update libraries set postcode = 'SN3 2LZ' where name = 'Park Library' and postcode = 'SN3 2LP';
update libraries set postcode = 'WF1 2EB' where name = 'Wakefield One' and postcode = 'WF1 2DA';
update libraries set postcode = 'SW11 6RD' where name = 'Northcote Library' and postcode = 'SW11 6HW';
update libraries set postcode = 'M46 9JQ' where name = 'Atherton' and postcode = 'M46 9JH';
update libraries set postcode = 'NW9 4BR' where name = 'Colindale' and postcode = 'NW9 5XL';


-- load oa to bua lookup table

create table oa_bua_staging (
    OA21CD text,
    BUA22CD text,
    BUA22NM text,
    BUA22NMW text,
    LAD22CD text,
    LAD22NM text,
    LAD22NMW text,
    RGN22CD text,
    RGN22NM text,
    RGN22NMW text,
    ObjectId text
);

\copy oa_bua_staging from 'data/oa21_to_bua.csv' csv header;

insert into oa_bua(oa, bua)
select OA21CD, BUA22CD
from oa_bua_staging;

drop table oa_bua_staging;

-- load oa population data

create table oa_population_staging (
    date text,
    geography text,
    geography_code text,
    all_persons numeric,
    female numeric,
    male numeric
);

\copy oa_population_staging from 'data/census2021_ts008_oa.csv' csv header quote '"';

insert into oa_population(oa, population)
select geography_code, all_persons
from oa_population_staging;

drop table oa_population_staging;
