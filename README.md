# Where are there no libraries?

An analysis of where there are and are not libraries in England

### Libraries dataset

Extract from https://www.artscouncil.org.uk/supporting-arts-museums-and-libraries/supporting-libraries

Filter by: Static Library, Open, Not ICL.

There were 5 libraries marked as Independent Community Libraries but also marked as part of the Library Services statutory provision.

Overall there were 2564 libraries.

CSV saved.


select *
from vw_libraries l
left join areas a
on st_intersects(a.geom, l.geom)
where a is null


select *, st_area(a.geom) as size
from areas a
left join vw_libraries l
on st_intersects(l.geom, a.geom)
where l is null
and gsscode like 'E%'
order by size desc