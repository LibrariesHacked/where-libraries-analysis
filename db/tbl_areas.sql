create table areas (
    gsscode character (9),
    name text,
    geom geometry(MultiPolygon, 27700)
);

create unique index cuidx_areas_gsscode_name on areas(gsscode, name);
cluster areas using cuidx_areas_gsscode_name;
create index idx_areas_gsscode on areas(gsscode);
create index idx_areas_name on areas(name);
create index idx_areas_geom on areas using gist(geom);
