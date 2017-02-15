select CAST((CAST(LDLeader.Win as smallint)-View_Series.Win-LDLeader.Lose+View_Series.Lose )/2.0 as decimal(4,1)) as Pts,
View_Series.* from View_Series 
join (select DISTINCT View_Series.division, View_Series.series, View_Series.Win, View_Series.Lose from View_Series
join (select division, series, MAX(GA) as GA from View_Series group by division, series) as LDWP
on View_Series.division=LDWP.division and View_Series.series=LDWP.series and View_Series.GA=LDWP.GA)
as LDLeader on LDLeader.division=View_Series.division and LDLeader.series=View_Series.series 
and View_Series.division=1 and View_Series.series=1 order by View_Series.GA DESC, Pts ASC