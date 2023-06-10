SELECT *
FROM czechia_payroll AS cp ;


SELECT 
cp.value ,
cp.industry_branch_code  ,
cpib.name,
cp.payroll_year 
 FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_industry_branch AS cpib ON cp.industry_branch_code = cpib.code  
WHERE value_type_code = 5958
	AND industry_branch_code IS NOT NULL
GROUP BY industry_branch_code, payroll_year;

SELECT 
payroll_year ,
industry_branch_code ,
value ,
lag(value) OVER(PARTITION BY industry_branch_code ORDER BY payroll_year) AS previous_value,
value - lag(value) OVER(PARTITION BY industry_branch_code ORDER BY payroll_year) AS difference
FROM czechia_payroll AS cp 
WHERE value_type_code = 5958
	AND industry_branch_code IS NOT NULL
GROUP BY industry_branch_code, payroll_year;

SELECT 
payroll_year ,
industry_branch_code ,
value ,
lag(value) OVER(PARTITION BY industry_branch_code ORDER BY payroll_year) AS previous_value,
value - lag(value) OVER(PARTITION BY industry_branch_code ORDER BY payroll_year) AS difference
FROM czechia_payroll AS cp 
WHERE value_type_code = 5958
	AND industry_branch_code IS NOT NULL
GROUP BY industry_branch_code, payroll_year
ORDER BY value - lag(value) OVER(PARTITION BY industry_branch_code ORDER BY payroll_year)
LIMIT 75;

SELECT 
cp.payroll_year,
cp.industry_branch_code ,
cp.value,
cp2.value AS previous_year_value,
cp.value - cp2.value AS difference 
FROM czechia_payroll AS cp 
LEFT JOIN czechia_payroll AS cp2 
	ON cp.payroll_year = cp2 .payroll_year +1
		AND cp.industry_branch_code = cp2 .industry_branch_code 
WHERE cp.value_type_code = 5958
	AND cp.industry_branch_code IS NOT NULL 
	AND cp2.value_type_code = 5958
GROUP BY cp.industry_branch_code, cp.payroll_year
ORDER BY cp.value - cp2.value, cp.industry_branch_code 
LIMIT 60;

CREATE VIEW v_czechia_payroll_decrease AS 
SELECT 
cp.payroll_year,
cp.industry_branch_code ,
cp.value,
cp2.value AS previous_year_value,
cp.value - cp2.value AS difference 
FROM czechia_payroll AS cp 
LEFT JOIN czechia_payroll AS cp2 
	ON cp.payroll_year = cp2 .payroll_year +1
		AND cp.industry_branch_code = cp2 .industry_branch_code 
WHERE cp.value_type_code = 5958
	AND cp.industry_branch_code IS NOT NULL 
	AND cp2.value_type_code = 5958
GROUP BY cp.industry_branch_code, cp.payroll_year
ORDER BY cp.value - cp2.value, cp.industry_branch_code 
LIMIT 60;

SELECT *
FROM v_czechia_payroll_decrease AS vcpd ;

SELECT
industry_branch_code ,
count(1) AS occurence
FROM v_czechia_payroll_decrease AS vcpd 
GROUP BY industry_branch_code 
ORDER BY occurence DESC ;	

SELECT
payroll_year,
count(1) AS occurence
FROM v_czechia_payroll_decrease AS vcpd 
GROUP BY payroll_year  
ORDER BY occurence DESC ;

/*vytváření tabulky spojením cen a mezd*/
SELECT 
id,
value ,
category_code, 
YEAR (date_from)
FROM czechia_price AS cp
WHERE category_code IN  (111301,114201)
AND region_code IS NULL 
GROUP BY YEAR (date_from) , category_code 
ORDER BY YEAR (date_from) ;

SELECT *
FROM czechia_price_category AS cpc ;

SELECT
cp.value AS price_value,
cp.category_code AS price_category_code,
cpc.name AS category_name,
YEAR (cp.date_from) AS year
FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code 
WHERE cp .region_code IS NULL 
GROUP BY YEAR (cp.date_from ), cp.category_code 


CREATE VIEW v_czechia_price AS 
SELECT
cp.value AS price_value,
cp.category_code AS price_category_code,
cpc.name,
YEAR (cp.date_from)
FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code 
WHERE cp .region_code IS NULL 
GROUP BY YEAR (cp.date_from ), cp.category_code;

ALTER VIEW v_czechia_price AS 
SELECT
cp.value AS price_value,
cp.category_code AS price_category_code,
cpc.name AS category_name,
YEAR (cp.date_from) AS year
FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code 
WHERE cp .region_code IS NULL 
GROUP BY YEAR (cp.date_from ), cp.category_code 

SELECT *
FROM v_czechia_price AS vcp 

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

CREATE VIEW v_czechia_payroll_salary AS 
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
FROM v_czechia_price AS vcp 
LEFT JOIN v_czechia_payroll_salary AS vcps ON vcp.`year`  = vcps.payroll_year ;

CREATE TABLE t_project_price_and_salaries AS 
SELECT *
FROM v_czechia_price AS vcp 
LEFT JOIN v_czechia_payroll_salary AS vcps ON vcp.`year`  = vcps.payroll_year ;


SELECT *
FROM t_project_price_and_salaries AS tppas 

/*úkol 1 z vytvořené tabulky
 * 
 */

/*všechny obory v letech - nárůst mezd*/

SELECT DISTINCT 
tppas.salary_value ,
tppas2.salary_value AS previous_value,
round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) AS increase_in_salary,
tppas.industry_branch_code ,
tppas.industry_name ,
tppas.payroll_year 
FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON
	tppas. payroll_year = tppas2.payroll_year + 1
	AND tppas .industry_branch_code = tppas2. industry_branch_code 
WHERE tppas .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) DESC , tppas.industry_branch_code 


/*obory s poklesem mzdy*/

CREATE VIEW v_salaries_2007_2018_decrease AS 
SELECT DISTINCT 
tppas.salary_value ,
tppas2.salary_value AS previous_value,
round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) AS increase_in_salary,
tppas.industry_branch_code ,
tppas.industry_name ,
tppas.payroll_year 
FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON
	tppas. payroll_year = tppas2.payroll_year + 1
	AND tppas .industry_branch_code = tppas2. industry_branch_code 
WHERE tppas .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2), tppas.industry_branch_code 
LIMIT 45

SELECT *
FROM v_salaries_2007_2018_decrease AS vsd 

/* v kterých oborech 2007-2018 nejčastější pokles?*/

SELECT
industry_branch_code ,
industry_name ,
count(1) AS occurence
FROM v_salaries_2007_2018_decrease AS vsd 
GROUP BY industry_branch_code 
ORDER BY occurence DESC ;

/*ve kterých letech poklesy mezd?*/

SELECT
payroll_year,
count(1) AS occurence
FROM v_salaries_2007_2018_decrease AS vsd 
GROUP BY payroll_year  
ORDER BY occurence DESC ;

/*první a poslední období u všech oborů - nárůst všude*/
SELECT DISTINCT 
tppas.salary_value AS 2018_value , 
tppas2.salary_value AS 2006_value,
round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) AS increase_in_salary,
tppas.industry_branch_code ,
tppas.industry_name ,
tppas.payroll_year
FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON
	tppas. payroll_year = tppas2.payroll_year + 12
	AND tppas .industry_branch_code = tppas2. industry_branch_code 
WHERE tppas .payroll_year = 2018
ORDER BY round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) DESC , tppas.industry_branch_code 




/* úkol 2 - kolik mléka a chleba za první 
 * a poslední srovnatelné období
 * 
 */

/*v jednotlivých oborech*/

SELECT *,
round (salary_value/price_value,2) AS how_many_breads_or_milk
FROM t_project_price_and_salaries AS tppas 
WHERE price_category_code IN (111301,114201)
	AND `year`  IN (2006, 2018) 
ORDER BY industry_branch_code, price_category_code 


/* kolik chleba za první a poslední období - zprůměrovaná mzda*/

SELECT 
industry_branch_code ,
industry_name, 
salary_value ,
category_name 
price_value ,
round (salary_value/price_value,2) AS how_many_breads
FROM t_project_price_and_salaries AS tppas 
WHERE price_category_code = 111301
	AND `year`  = 2006 
ORDER BY industry_branch_code, price_category_code 

SELECT 
round ((sum (salary_value)/19)/price_value,0) AS how_many_breads
FROM t_project_price_and_salaries AS tppas 
	WHERE price_category_code = 111301
	AND `year`  = 2006 
	
SELECT 
round ((sum (salary_value)/19)/price_value,0) AS how_many_breads
FROM t_project_price_and_salaries AS tppas 
	WHERE price_category_code = 111301
	AND `year` = 2018
	

	
/*
 úkol 3
 */

SELECT DISTINCT 
tppas.price_value ,
tppas2 .price_value AS previous_value,
round((tppas.price_value-tppas2.price_value)/tppas2 .price_value *100,2) AS yearly_percentual_increase,
tppas.price_category_code ,
tppas.category_name ,
tppas .`year`  
 FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON tppas.`year`  = tppas2.`year`  +1
	AND tppas.price_category_code = tppas2 .price_category_code 
GROUP BY tppas .price_category_code, tppas .`year` 
ORDER BY tppas .price_category_code ,round((tppas.price_value-tppas2.price_value)/tppas2 .price_value *100,2)

ALTER VIEW v_price_increase AS 
SELECT DISTINCT 
tppas.price_value ,
tppas2 .price_value AS previous_value,
round((tppas.price_value-tppas2.price_value)/tppas2 .price_value *100,2) AS yearly_percentual_increase,
tppas.price_category_code ,
tppas.category_name ,
tppas .`year`  
 FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON tppas.`year`  = tppas2.`year`  +1
	AND tppas.price_category_code = tppas2 .price_category_code 
GROUP BY tppas .price_category_code, tppas .`year`  
ORDER BY tppas .price_category_code ,round((tppas.price_value-tppas2.price_value)/tppas2 .price_value *100,2)

	
SELECT
round(sum(yearly_percentual_increase)/12, 2) AS avg_yearly_increase_2006_to_2018,
price_category_code ,
category_name 
FROM v_price_increase AS vpi 
GROUP BY price_category_code 
ORDER BY sum(yearly_percentual_increase);

/*
 *úkol 4
 */
	
SELECT
round(sum(price_value),0) AS total_price_sum_per_year,
sum(salary_value) AS total_salary_sum_per_year,
`year` 
FROM t_project_price_and_salaries AS tppas 
GROUP BY `year` 

ALTER  VIEW v_total_prices_salaries AS 
SELECT
round(sum(price_value),0) AS total_price_sum_per_year,
sum(salary_value) AS total_salary_sum_per_year,
`year` 
FROM t_project_price_and_salaries AS tppas 
GROUP BY `year` 

SELECT
round(sum(price_value),0) AS total_price_sum_per_year,
sum(salary_value) AS total_salary_sum_per_year,
sum(salary_value) / round(sum(price_value),0) AS affordability,
`year` 
FROM t_project_price_and_salaries AS tppas 
GROUP BY `year` 
ORDER BY sum(salary_value) / round(sum(price_value),0) 

SELECT
round(sum(tppas .price_value),0) AS total_price_sum_per_year,
round(sum(tppas2 .price_value),0) AS price_last_year,
(round(sum(tppas .price_value),0)-round(sum(tppas2 .price_value),0))/round(sum(tppas2 .price_value),0)*100 AS price_dif,
sum(tppas. salary_value) AS total_salary_sum_per_year,
sum(tppas2. salary_value) AS salary_last_year,
(sum(tppas. salary_value)-sum(tppas2. salary_value))/sum(tppas2. salary_value)*100 AS salary_dif,
tppas .`year`  
FROM t_project_price_and_salaries AS tppas 
	LEFT JOIN t_project_price_and_salaries AS tppas2 ON 
	tppas .`year`  = tppas2 .`year`  +1
WHERE tppas .`year`  BETWEEN 2007 AND 2018
	GROUP BY `year` 

/* úkol 5
 */

SELECT 
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

SELECT 
e.`year`, 
e.GDP,
e2.`year` ,
e2.GDP ,
Round ((e.GDP - e2.GDP)/e2.GDP * 100,2)  AS percentual_increase
FROM economies AS e 
LEFT JOIN economies AS e2 
	ON e.`year` = e2.`year` +1
WHERE e.country = 'Czech Republic' AND e2.country = 'Czech Republic'
AND e.`year` BETWEEN 2006 AND 2018
ORDER BY Round ((e.GDP - e2.GDP)/e2.GDP * 100,2) DESC 

/*ve kterých letech nejnižší nárůst mezd?*/

SELECT
payroll_year,
count(1) AS occurence
FROM v_salaries_2007_2018_decrease AS vsd 
GROUP BY payroll_year  
ORDER BY occurence DESC ;

/*ve kterých letech nejvyšší nárůst mezd?*/
SELECT DISTINCT 
tppas.salary_value ,
tppas2.salary_value AS previous_value,
round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) AS increase_in_salary,
tppas.industry_branch_code ,
tppas.industry_name ,
tppas.payroll_year 
FROM t_project_price_and_salaries AS tppas 
LEFT JOIN t_project_price_and_salaries AS tppas2 ON
	tppas. payroll_year = tppas2.payroll_year + 1
	AND tppas .industry_branch_code = tppas2. industry_branch_code 
WHERE tppas .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tppas.salary_value - tppas2.salary_value)/tppas2 .salary_value *100, 2) DESC , tppas.industry_branch_code 
LIMIT 50

