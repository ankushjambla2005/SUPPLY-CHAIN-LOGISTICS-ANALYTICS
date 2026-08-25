create table supply_chain_clean(type varchar, days_for_shipping_real int , days_for_shipment_scheduled int,
       benefit_per_order double precision, sales_per_customer double precision, delivery_status varchar,
       late_delivery_risk int , category_id int, category_name varchar, customer_city varchar,
       customer_country varchar, customer_id int, customer_segment varchar, customer_state varchar,
       customer_street varchar, customer_zipcode float, department_id int,
       department_name varchar, latitude float, longitude  float , market varchar, order_city varchar,
       order_country varchar, order_customer_id int, order_id int,
       order_item_cardprod_id int, order_item_discount double precision,
       order_item_discount_rate double precision, order_item_id int, order_item_product_price double precision,
       order_item_profit_ratio double precision, order_item_quantity int, sales double precision,
       order_item_total double precision, order_profit_per_order double precision, order_region varchar,
       order_state varchar, order_status varchar, product_card_id bigint, product_category_id bigint,
       product_name varchar, product_price double precision, shipping_mode varchar, customer_full_name varchar,
       order_date timestamp, shipping_date timestamp, order_year int, order_month int, order_day varchar,
       order_hour int, delivery_delay_days int, is_delayed int, "profit_margin_%" double precision, customer_total_orders int
       );
       