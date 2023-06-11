/* úkol 2 - kolik mléka a chleba za první 
 * a poslední srovnatelné období
 * 
 */

/*v jednotlivých oborech*/

SELECT *,
round (salary_value/price_value,2) AS how_many_breads_or_milk
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf  
WHERE price_category_code IN (111301,114201)
	AND `year`  IN (2006, 2018) 
ORDER BY industry_branch_code, price_category_code 


/* kolik chleba za první a poslední období - zprůměrovaná mzda za všechny odvětví*/


SELECT 
round ((sum (salary_value)/19)/price_value,0) AS how_many_breads
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
	WHERE price_category_code = 111301
	AND `year`  = 2006 
	
SELECT 
round ((sum (salary_value)/19)/price_value,0) AS how_many_breads
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
	WHERE price_category_code = 111301
	AND `year` = 2018
	

	