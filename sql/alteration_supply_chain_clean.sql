copy supply_chain_clean
from 'C:\project placement\supply_chain_analysis\cleaned_file\supply_chain_clean.csv'
delimiter','
csv header;

select * from supply_chain_clean
limit 100;

select count(product_category_id) as ty1 ,count(*)
from supply_chain_clean
where product_category_id=category_id

ALTER TABLE supply_chain_clean 
DROP COLUMN order_item_product_price;

ALTER TABLE supply_chain_clean 
DROP COLUMN order_customer_id,
DROP COLUMN product_category_id,
DROP COLUMN customer_street,
DROP COLUMN customer_zipcode,
DROP COLUMN customer_city,
DROP COLUMN customer_state,
DROP COLUMN customer_country,
DROP COLUMN order_state;

