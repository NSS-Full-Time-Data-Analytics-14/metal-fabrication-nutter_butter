-- *** oml_sales_order_id count equals oml_part_id count.

-- SELECT
-- distinct oml_sales_order_line_id,count(oml_sales_order_id),count(oml_part_id)
-- FROM sales_order_lines
-- GROUP BY oml_sales_order_line_id

-- *** multiple source_method_id per jmp_source_method_id

-- with p AS (SELECT
-- jmp_job_id,count(jmp_source_method_id) AS count_source_mthod_id
-- FROM jobs
-- LEFT JOIN part_assemblies
-- ON jobs.jmp_source_method_id = part_assemblies.ima_source_method_id
-- GROUP BY jmp_job_id
-- ORDER BY count_source_mthod_id DESC)
-- SELECT*
-- FROM p


-- *** for every jmp_job_id is 1 jmp_part_id.

-- SELECT jmp_source_method_id,
-- count(jmp_job_id) AS jmp_job_id, 
-- count(jmp_part_id) AS jmp_part_id, 
-- count(ujmp_nest_name) AS ujmp_nest_name
-- FROM jobs
-- GROUP BY jmp_source_method_id

-- *** There are multiple ima_part_id for each ima_method_id

-- SELECT ima_method_id, count(ima_part_id)
-- FROM part_assemblies
-- GROUP BY ima_method_id
-- ORDER BY ima_method_id
-- 27548

-- *** highest subtotal that have zero hours.

-- SELECT
-- omj_sales_order_id,omp_full_order_subtotal_base,jmp_job_date
-- FROM sales_order_job_links AS s
-- LEFT JOIN jobs AS j ON s.omj_job_id = j.jmp_job_id
-- LEFT JOIN sales_orders ON s.omj_sales_order_id = sales_orders.omp_sales_order_id

-- SELECT
-- omp_sales_order_id,omp_full_order_subtotal_base
-- FROM sales_orders

-- *** Lydia's code to find the total production hours for top 10 revenue generating jobs.

-- SELECT  sojl.omj_sales_order_id, SUM(jo23.jmo_completed_production_hours) AS hours_2023, SUM(jo24.jmo_completed_production_hours) AS hours_2024
-- FROM sales_order_job_links AS sojl
-- 	FULL JOIN jobs AS j
-- 	ON sojl.omj_job_id = j.jmp_job_id
-- 		FULL JOIN job_operations_2023 AS jo23 
-- 		ON j.jmp_job_id= jo23.jmo_job_id
-- 			FULL JOIN job_operations_2024 AS jo24 
-- 			ON j.jmp_job_id= jo24.jmo_job_id
-- WHERE omj_sales_order_id IN (35134,28331,33156,35121,32385,30226,34011,27598,29126,32796,32557,32386)
-- GROUP BY omj_sales_order_id;

-- *** this is how Uma found calculating the omp_full_order_subtotal_base from the quantity delivered and unit price. both are equal.

-- select ol.oml_sales_order_id,
-- o.omp_full_order_subtotal_base,
-- round((sum(ol.oml_full_unit_price_base*ol.oml_delivery_quantity_total))::numeric,2)
-- from sales_order_lines  ol inner join sales_orders o
-- on ol.oml_sales_order_id=o.omp_sales_order_id
-- group by 1,2;

-- top item org id Y002-YNGTC

-- Top customers by revenue

SELECT
omp_customer_organization_id,sum(omp_full_order_subtotal_base) AS total_revenue_earned
FROM sales_orders
LEFT JOIN sales_order_job_links ON sales_orders.omp_sales_order_id  = sales_order_job_links.omj_sales_order_id
LEFT JOIN jobs ON sales_order_job_links.omj_job_id = jobs.jmp_job_id
WHERE jmp_production_complete = True 
GROUP BY omp_customer_organization_id
ORDER BY total_revenue_earned DESC

