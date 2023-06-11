	
/*
 úkol 3 - která kategorie potravin zdražuje nejpomaleji
 */

/*
 * vytvoření podhledu s nárůstem cen všech potravin
 */
CREATE VIEW v_zuz_vih_price_increase AS 
SELECT DISTINCT 
tzvpspf.price_value ,
tzvpspf2 .price_value AS previous_value,
round((tzvpspf.price_value-tzvpspf2.price_value)/tzvpspf2.price_value *100,2) AS yearly_percentual_increase,
tzvpspf.price_category_code ,
tzvpspf.price_category_name ,
tzvpspf .`year`  
 FROM t_zuzana_vihanova_project_sql_primary_final AS tzvpspf 
LEFT JOIN t_zuzana_vihanova_project_sql_primary_final AS tzvpspf2  ON tzvpspf.`year`  = tzvpspf2.`year`  +1
	AND tzvpspf.price_category_code = tzvpspf2 .price_category_code 
GROUP BY tzvpspf .price_category_code, tzvpspf .`year`  
ORDER BY tzvpspf .price_category_code ,round((tzvpspf.price_value-tzvpspf2.price_value)/tzvpspf2 .price_value *100,2)


/*
 * potraviny s nejnižším nárůstem ceny
 */

SELECT
round(sum(yearly_percentual_increase)/12, 2) AS avg_yearly_increase_2006_to_2018,
price_category_code ,
price_category_name   
FROM v_zuz_vih_price_increase AS vzvpi 
GROUP BY price_category_code 
ORDER BY sum(yearly_percentual_increase);
