/*úkol 1 z vytvořené tabulky - rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 * 
 
 *
 **všechny obory v letech - nárůsty a poklesy mezd*/

SELECT DISTINCT 
	tzvpspf.salary_value ,
	tzvpspf2.salary_value AS previous_value,
	round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) AS increase_in_salary,
	tzvpspf.industry_branch_code ,
	tzvpspf.industry_name ,
	tzvpspf.payroll_year 
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2 
	ON tzvpspf. payroll_year = tzvpspf2.payroll_year + 1
	AND tzvpspf .industry_branch_code = tzvpspf2. industry_branch_code 
WHERE tzvpspf .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) DESC, tzvpspf.industry_branch_code 


/*obory s poklesem mzdy*/

SELECT DISTINCT 
	tzvpspf.salary_value ,
	tzvpspf2.salary_value AS previous_value,
	round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) AS increase_in_salary,
	tzvpspf.industry_branch_code ,
	tzvpspf.industry_name ,
	tzvpspf.payroll_year 
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2 
	ON tzvpspf. payroll_year = tzvpspf2.payroll_year + 1
	AND tzvpspf .industry_branch_code = tzvpspf2. industry_branch_code 
WHERE tzvpspf .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2), tzvpspf.industry_branch_code 
LIMIT 45

CREATE VIEW v_zuz_vih_salaries_2007_2018_decrease AS 
SELECT DISTINCT 
	tzvpspf.salary_value ,
	tzvpspf2.salary_value AS previous_value,
	round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) AS increase_in_salary,
	tzvpspf.industry_branch_code ,
	tzvpspf.industry_name ,
	tzvpspf.payroll_year 
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2 
	ON tzvpspf. payroll_year = tzvpspf2.payroll_year + 1
	AND tzvpspf .industry_branch_code = tzvpspf2. industry_branch_code 
WHERE tzvpspf .payroll_year BETWEEN 2007 AND 2018
ORDER BY round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2), tzvpspf.industry_branch_code 
LIMIT 45


/* v kterých oborech 2007-2018 nejčastější pokles?*/

SELECT
industry_branch_code ,
industry_name ,
count(1) AS occurence
FROM v_zuz_vih_salaries_2007_2018_decrease AS vzvsd 
GROUP BY industry_branch_code 
ORDER BY occurence DESC ;

/*ve kterých letech poklesy mezd?*/

SELECT
payroll_year,
count(1) AS occurence
FROM v_zuz_vih_salaries_2007_2018_decrease AS vzvsd 
GROUP BY payroll_year  
ORDER BY occurence DESC ;

/*první a poslední období u všech oborů - nárůst všude*/
SELECT DISTINCT 
tzvpspf.salary_value AS 2018_value , 
tzvpspf2.salary_value AS 2006_value,
round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) AS increase_in_salary,
tzvpspf.industry_branch_code ,
tzvpspf.industry_name ,
tzvpspf.payroll_year
FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf  
LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2  ON
	tzvpspf. payroll_year = tzvpspf2.payroll_year + 12
	AND tzvpspf .industry_branch_code = tzvpspf2. industry_branch_code 
WHERE tzvpspf .payroll_year = 2018
ORDER BY round ((tzvpspf.salary_value - tzvpspf2.salary_value)/tzvpspf2 .salary_value *100, 2) DESC , tzvpspf.industry_branch_code 


