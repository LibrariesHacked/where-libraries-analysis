# Where are there no libraries?

An analysis of where there are and are not libraries in England

## Data preparation

### Libraries dataset

Download from the December 2022 file listed at https://www.artscouncil.org.uk/supporting-arts-museums-and-libraries/supporting-libraries

Filter by: Static Library, Open, Not ICL.

There were 5 libraries marked as Independent Community Libraries but also marked as part of the Library Services statutory provision. Filter those out.

Overall there were 2564 static and statutory public libraries in England. CSV saved as `england_library_postcodes.csv`.


## Data queries


```sql
select l.authority, l.name
from vw_libraries l
left join areas a
on st_intersects(a.geom, l.geom)
where a is null;
```


```sql
select *, st_area(a.geom) as size
from areas a
left join vw_libraries l
on st_intersects(l.geom, a.geom)
where l is null
and gsscode like 'E%'
order by size desc;
```


```sql
select a.name, a.auth_names
from vw_areas a
left join vw_libraries l
on st_intersects(l.geom, a.geom)
where l is null
order by a.population desc;
```

