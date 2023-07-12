create table bua_auth (
    bua character (9),
    auth_code character (9),
    auth_name text
);

create unique index cuix_bua_auth_bua_authcode on bua_auth (bua, auth_code);
cluster bua_auth using cuix_bua_auth_bua_authcode;

create index ix_bua_auth_bua on bua_auth (bua);
create index ix_bua_auth_authcode on bua_auth (auth_code);
create index ix_bua_auth_authname on bua_auth (auth_name);
