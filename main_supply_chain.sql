select * from supply_chain_clean limit 100;

CREATE VIEW country_drill_performance AS
SELECT 
    market,
    order_region,
    order_country,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(sales)::numeric, 2) AS gross_sales,
    ROUND(SUM(order_item_total)::numeric, 2) AS net_sales,
    ROUND(SUM(order_profit_per_order)::numeric, 2) AS total_profit,
    ROUND(SUM(CASE WHEN order_profit_per_order < 0 THEN order_profit_per_order ELSE 0 END)::numeric, 2) AS financial_loss,
    ROUND(((SUM(order_profit_per_order) / NULLIF(SUM(sales), 0)) * 100)::numeric, 2) AS profit_margin_pct,
    ROUND(((SUM(CASE WHEN is_delayed = 1 THEN 1 ELSE 0 END)::numeric / COUNT(*)) * 100)::numeric, 2) AS late_delivery_rate_pct,
    ROUND(AVG(delivery_delay_days)::numeric, 2) AS avg_delay_days
FROM supply_chain_clean
GROUP BY market, order_region,order_country
ORDER BY late_delivery_rate_pct DESC;

select * from country_drill_performance;

create view shipping_efficiency as
select shipping_mode,
    count(distinct order_id) as total_order_done,
    count(*) as total_items_sold,
    round(sum(sales)::numeric,2) as net_gross_shipping,
    round(sum(order_item_total)::numeric,2) as net_sales_shipping,
    round(sum(order_profit_per_order)::numeric,2) as net_profit_shipping,
    round(sum(case when order_profit_per_order<0 then order_profit_per_order else 0 end)::numeric,2) as total_financial_loss_shipping,
    round(((sum(order_profit_per_order)/nullif(sum(sales),0))*100)::numeric,2) as profit_margin_pct,
    round(((SUM(CASE WHEN is_delayed = 1 THEN 1 ELSE 0 END)::numeric / COUNT(*)) * 100)::numeric, 2) AS late_delivery_rate_pct_shipping,
    round(AVG(delivery_delay_days)::numeric, 2) AS avg_delay_days_shipping
FROM supply_chain_clean
group by shipping_mode
order by late_delivery_rate_pct_shipping;

select *from shipping_efficiency;


create view category_analysis as
with category_summary as(
    select category_name,
        count(distinct order_id) as total_order_done,
        count(*) as total_items_sold,
        round(sum(sales)::numeric,2) as net_gross_category,
        round(sum(order_item_total)::numeric,2) as net_sales_category,
        round(sum(order_profit_per_order)::numeric,2) as net_profit_category
    from supply_chain_clean
    group by category_name)

    ,pareto_calculation as(select category_name,
        total_order_done,
        total_items_sold,
        net_gross_category,
        net_sales_category,
        net_profit_category,
        sum(net_gross_category) over() as total_gross,
        sum(net_gross_category) over(order by net_gross_category desc) as running_gross
    from category_summary)

select category_name,
    total_order_done,
    total_items_sold,
    net_gross_category,
    net_sales_category,
    net_profit_category,
    ROUND(((net_gross_category/ NULLIF(total_gross, 0)) * 100)::numeric, 2) AS sales_share_pct,
    ROUND(((running_gross/ NULLIF(total_gross, 0)) * 100)::numeric, 2) AS cumulative_sales_pct,
    case
        when round((running_gross::numeric/total_gross)*100,2)<=80.00 then 'A'
        when round((running_gross::numeric/total_gross)*100,2)<=95 then 'B'
        else 'C'
    end as abc_class
from pareto_calculation;


select * from category_analysis;