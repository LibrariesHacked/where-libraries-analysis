-- create the database
\i 'db/db_wherelibraries.sql';

-- switch to using the database
\c where_libraries;

-- setup any extensions
\i 'db/db_extensions.sql';

-- set client encoding
set client_encoding = 'UTF8';

-- create tables
\i 'db/tbl_areas.sql';
\i 'db/tbl_postcodes.sql';
\i 'db/tbl_libraries.sql';
\i 'db/tbl_oa_population.sql';
\i 'db/tbl_oa_bua.sql';

-- create views
\i 'db/vw_libraries.sql';
\i 'db/vw_areas.sql';

-- load in data
\i 'db/load.sql';

vacuum analyze;
