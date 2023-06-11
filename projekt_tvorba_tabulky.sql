
/*vytváření tabulky spojením cen a mezd*/

CREATE VIEW v_zuz_vih_prices AS 
SELECT
	cp.value AS price_value,
	cp.category_code AS price_category_code,
	cpc.name AS price_category_name,
	YEAR (cp.date_from) AS year
FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code 
WHERE cp .region_code IS NULL 
GROUP BY YEAR (cp.date_from ), cp.category_code;


SELECT *
FROM v_zuz_vih_prices AS vzvp 


CREATE VIEW v_zuz_vih_salaries AS 
SELECT 
	cp.value AS salary_value,
	cp.industry_branch_code  ,
	cpib.name AS industry_name,
	cp.payroll_year 
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_industry_branch AS cpib ON cp.industry_branch_code = cpib.code  
WHERE value_type_code = 5958
	AND industry_branch_code IS NOT NULL
GROUP BY payroll_year , industry_branch_code;

SELECT *
FROM v_zuz_vih_prices AS vzvp   
LEFT JOIN v_zuz_vih_salaries AS vzvs ON vzvp .`year`  = vzvs .payroll_year ;

CREATE TABLE t_zuzana_vihanova_project_sql_primary_final AS 
SELECT *
FROM v_zuz_vih_prices AS vzvp  
LEFT JOIN v_zuz_vih_salaries AS vzvs ON vzvp .`year`  = vzvs .payroll_year ;


SELECT *
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf  
