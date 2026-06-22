-- Add Primary Keys to main tables
ALTER TABLE public.customers ADD PRIMARY KEY (customer_id);
ALTER TABLE public.orders ADD PRIMARY KEY (order_id);
ALTER TABLE public.products ADD PRIMARY KEY (product_id);
ALTER TABLE public.sellers ADD PRIMARY KEY (seller_id);

-- Add Foreign Keys to connect the tables

-- Link orders to customers
ALTER TABLE public.orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES public.customers (customer_id);

-- Link order_items to orders, products, and sellers
ALTER TABLE public.order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id) REFERENCES public.orders (order_id);

ALTER TABLE public.order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id) REFERENCES public.products (product_id);

ALTER TABLE public.order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id) REFERENCES public.sellers (seller_id);

-- Link order_payments to orders
ALTER TABLE public.order_payments
ADD CONSTRAINT fk_order_payments_orders
FOREIGN KEY (order_id) REFERENCES public.orders (order_id);

-- Link order_reviews to orders
ALTER TABLE public.order_reviews
ADD CONSTRAINT fk_order_reviews_orders
FOREIGN KEY (order_id) REFERENCES public.orders (order_id);

INSERT INTO public.category_translation (product_category_name, product_category_name_english)
SELECT DISTINCT p.product_category_name, p.product_category_name
FROM public.products p
LEFT JOIN public.category_translation ct 
  ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL 
  AND ct.product_category_name IS NULL;

ALTER TABLE public.products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name) REFERENCES public.category_translation (product_category_name);



-- Convert timestamp to DATE for exact matching
ALTER TABLE dim_date ALTER COLUMN full_date TYPE DATE;
ALTER TABLE dim_weather ALTER COLUMN weather_date TYPE DATE;

-- Add Primary Key to dim_date
ALTER TABLE dim_date ADD PRIMARY KEY (full_date);