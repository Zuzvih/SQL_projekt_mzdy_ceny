/*
 *úkol 4 - existuje rok, ve kterém byl růst cen potravin výrazně vyšší, než růst mezd?
 */
	

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
ORDER BY (round(sum(tzvpspf .price_value),0)-round(sum(tzvpspf2 .price_value),0))/round(sum(tzvpspf2 .price_value),0)*100 - (sum(tzvpspf. salary_value)-sum(tzvpspf2. salary_value))/sum(tzvpspf2. salary_value)*100 DESC 


