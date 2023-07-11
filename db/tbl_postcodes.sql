create table postcodes (
    postcode text,
    geom geometry(Point, 27700)
);

create unique index cuidx_postcodes_postcode on postcodes(postcode);
cluster postcodes using cuidx_postcodes_postcode;
create index idx_postcodes_geom on postcodes using gist(geom);
