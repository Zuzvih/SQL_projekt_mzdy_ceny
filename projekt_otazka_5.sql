/* úkol 5 - vliv HDP na mzdy a ceny potravin
 */


SELECT 
	e.`year`, 
	e.GDP,
	e2.GDP AS previous_year_GDP,
	Round ((e.GDP - e2.GDP)/e2.GDP * 100,2)  AS percentual_increase
FROM economies AS e 
LEFT JOIN economies AS e2 
	ON e.`year` = e2.`year` +1
WHERE e.country = 'Czech Republic' AND e2.country = 'Czech Republic'
	AND e.`year` BETWEEN 2006 AND 2018
ORDER BY Round ((e.GDP - e2.GDP)/e2.GDP * 100,2) DESC 

CREATE VIEW v_zuz_vih_gdp_increase_2006_2018
AS SELECT  
	e.country ,
	e.`year`, 
	e.GDP,
	e2.GDP AS previous_year_GDP,
	Round ((e.GDP - e2.GDP)/e2.GDP * 100,2)  AS percentual_increase
FROM economies AS e 
LEFT JOIN economies AS e2 
	ON e.`year` = e2.`year` +1
WHERE e.country = 'Czech Republic' AND e2.country = 'Czech Republic'
AND e.`year` BETWEEN 2006 AND 2018

 

CREATE VIEW v_zuz_vih_prices_salaries_total_increase AS 	
SELECT
	round(sum(tzvpspf .price_value),0) AS total_price_sum_per_year,
	round(sum(tzvpspf2 .price_value),0) AS price_last_year,
	(round(sum(tzvpspf .price_value),0)-round(sum(tzvpspf2 .price_value),0))/round(sum(tzvpspf2 .price_value),0)*100 AS price_dif,
	sum(tzvpspf. salary_value) AS total_salary_sum_per_year,
	sum(tzvpspf2. salary_value) AS salary_last_year,
	(sum(tzvpspf. salary_value)-sum(tzvpspf2. salary_value))/sum(tzvpspf2. salary_value)*100 AS salary_dif,
	tzvpspf.`year`  
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
	LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2 ON 
	tzvpspf .`year`  = tzvpspf2 .`year`  +1
WHERE tzvpspf .`year`  BETWEEN 2007 AND 2018
	GROUP BY `year` 

	/* srovnání meziročních růstů platů, cen a hdp*/
	
	
SELECT 
vzvpsti.`year` ,
round (vzvpsti.price_dif ,2) AS price_dif,
round (vzvpsti.salary_dif ,2) AS salary_dif,
vzvgi.percentual_increase AS gdp_dif
FROM v_zuz_vih_prices_salaries_total_increase AS vzvpsti 
LEFT JOIN v_zuz_vih_gdp_increase_2006_2018 AS vzvgi 
	ON vzvpsti .`year` = vzvgi .`year`
ORDER BY vzvgi.percentual_increase desc	

	

	
