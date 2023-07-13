create or replace view vw_oa_imd as
select
	oa21, min(imd_decile) as imd_decile
from oa11_oa21 oas21
left join oa11_lsoa11 lsoas11
on lsoas11.oa11 = oas21.oa11
left join imd i
on i.lsoa11 = lsoas11.lsoa11
group by oa21
order by oa21;