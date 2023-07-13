create table imd (
    lsoa11 character (9),
    imd_decile integer
);

create unique index cuidx_imd_lsoa11 on imd (lsoa11);
cluster imd using cuidx_imd_lsoa11;

create index idx_imd_lsoa11 on imd (lsoa11);
create index idx_imd_imd_decile on imd (imd_decile);
