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
update libraries set postcode = 'TA24 8NP' where name = 'Porlock' and postcode = 'TA24 7HD';
update libraries set postcode = 'EX23 8LG' where name = 'Bude Library & Information Service' and postcode = 'EX23 9LG';
update libraries set postcode = 'DH6 2LW' where name = 'Shotton Library' and postcode = 'DL6 2LW';
update libraries set postcode = 'SY9 5AQ' where name = 'Bishop''s Castle' and postcode = 'SY5 9AQ';



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


-- load bua to ua/cty lookup table

create table bua_auth_staging (
    BUA22CD text,
    BUA22NM text,
    BUA22NMW text,
    BUA22NMG text,
    CTYUA22CD text,
    CTYUA22NM text,
    WHOLE_PART text,
    ObjectId text
);

\copy bua_auth_staging from 'data/bua_to_ua_cty.csv' csv header;

insert into bua_auth(bua, auth_code, auth_name)
select BUA22CD, CTYUA22CD, CTYUA22NM
from bua_auth_staging;

drop table bua_auth_staging;


-- load oa11 to oa21 lookup table

create table oa11_to_oa21_staging (
    ObjectId text,
    OA11CD text,
    OA21CD text,
    CHNGIND text,
    LAD22CD text,
    LAD22NM text,
    LAD22NMW text
);

\copy oa11_to_oa21_staging from 'data/oa11_to_oa21.csv' csv header;

insert into oa11_oa21(oa11, oa21)
select OA11CD, OA21CD
from oa11_to_oa21_staging;

drop table oa11_to_oa21_staging;

-- load oa11 to lsoa11 lookup table

create table oa11_to_lsoa11_staging (
    OA11CD text,
    LSOA11CD text,
    LSOA11NM text,
    MSOA11CD text,
    MSOA11NM text,
    LAD11CD text,
    LAD11NM text,
    LAD11NMW text,
    ObjectId text
);

\copy oa11_to_lsoa11_staging from 'data/oa11_to_lsoa11.csv' csv header;

insert into oa11_lsoa11(oa11, lsoa11)
select OA11CD, LSOA11CD
from oa11_to_lsoa11_staging;

drop table oa11_to_lsoa11_staging;

-- load imd table

create table imd_staging (
    "LSOA code (2011)" text,
    "LSOA name (2011)" text,
    "Local Authority District code (2019)" text,
    "Local Authority District name (2019)" text,
    "Index of Multiple Deprivation (IMD) Rank" text,
    "Index of Multiple Deprivation (IMD) Decile" integer
);

\copy imd_staging from 'data/imd.csv' csv header;

insert into imd(lsoa11, imd_decile)
select "LSOA code (2011)", "Index of Multiple Deprivation (IMD) Decile"
from imd_staging;

drop table imd_staging;
