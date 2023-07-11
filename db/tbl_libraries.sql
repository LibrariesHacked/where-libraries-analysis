create table libraries (
    authority text,
    name text,
    postcode text
);

create unique index cuidx_libraries_authority_name on libraries(authority, name);
cluster libraries using cuidx_libraries_authority_name;
create index idx_libraries_authority on libraries(authority);
create index idx_libraries_name on libraries(name);
create index idx_libraries_postcode on libraries(postcode);
