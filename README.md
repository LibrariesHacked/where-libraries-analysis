# Missing libraries

An analysis of places where there are no libraries in England

## Data preparation

There are various open data sources used for this analysis. These needed some manual preparation, detailed here.

### Libraries dataset

Download from the [December 2022 file](https://www.artscouncil.org.uk/supporting-arts-museums-and-libraries/supporting-libraries) published on the Arts Council England website.

The data was filtered to include entries of type 'Static Library' (to exclude archives, mobile libraries), 'Open' (to include current libraries) and not those of type 'Independent Community Library' (as these are independent from statutory provision).

There were 5 libraries that were marked as Independent Community Libraries but also marked as part of the Library Services statutory provision. That seemed to be an error, so they were not included.

Overall there were 2564 static and statutory public libraries in England. CSV saved as `england_library_postcodes.csv`.

### Built up areas


### Built up areas to unitary and county authoritaries

A lookup published by the ONS. 

This isn't directly used in the end results other than to be an additional level of detail provided in the output file.


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
select a.name, a.auth_names, a.population, a.min_imd_decile
from vw_areas a
left join vw_libraries l
on st_intersects(l.geom, a.geom)
where l is null
and a.population is not null
order by a.population desc;
```


```sql
select a.name, a.auth_names, a.population, a.min_imd_decile
from vw_areas a
left join vw_libraries l
on st_intersects(l.geom, a.geom)
where l is null
and a.population <= 5000
and min_imd_decile <= 2
order by a.population desc;
```


