--	bloco_B.sql - JOINs

	-- B1: Relatório com categoria do produto (traduzida), valor do item, cidade do vendedor.
		-- Esta query permite analisar quais tipos de produtos são comercializados em cada localidade.
select
		it.order_id,
		it.product_id,
		tr.product_category_name_english,
		it.price,
		s.seller_city
from olist_order_items_dataset it
inner join olist_products_dataset p
		on it.product_id = p.product_id 
inner join product_category_name_translation tr
		on p.product_category_name = tr.product_category_name 
inner join olist_sellers_dataset s
		on it.seller_id = s.seller_id;

	-- B2: Identificar pedidos com atraso na entrega, comparando data estimada com data real de entrega (join entre orders e customers).
		-- Esta query permite analisar atrasos de entrega e seu impacto operacional.
select
		o.order_id,
		c.customer_city,
		c.customer_state,
		o.order_delivered_customer_date,
		o.order_estimated_delivery_date
from olist_orders_dataset o
inner join olist_customers_dataset c
	on o.customer_id = c.customer_id
where o.order_delivered_customer_date > o.order_estimated_delivery_date;

		-- (Versão incluindo quantidade de dias de atraso)
select
   		o.order_id,
    	c.customer_city,
    	c.customer_state,
    	o.order_delivered_customer_date,
    	o.order_estimated_delivery_date,
    	(o.order_delivered_customer_date::date -
     	o.order_estimated_delivery_date::date) AS dias_atraso
from olist_orders_dataset o
inner join olist_customers_dataset c
    on o.customer_id = c.customer_id
where o.order_delivered_customer_date > o.order_estimated_delivery_date;

	-- B3: Listar pedidos e suas formas de pagamento, incluindo pedidos pagos em mais de uma parcela (join entre orders e order_payments).
		-- Esta query permite identificar compras parceladas e os meios de pagamento preferidos.
select
		o.order_id,
		o.order_status,
		p.payment_type,
		p.payment_installments,
		p.payment_value
from olist_orders_dataset o
inner join olist_order_payments_dataset p
	on o.order_id = p.order_id ;
	
	-- B4: Listar produtos junto com a categoria traduzida, incluindo produtos cuja categoria não possui tradução cadastrada (left join com product_category_name_translation).
		-- Esta query permite identificar categorias sem tradução cadastrada na tabela.
select
		p.product_id,
		p.product_category_name,
		t.product_category_name_english
from olist_products_dataset p
left join product_category_name_translation t
	on p.product_category_name = t.product_category_name;
		
		-- (Validação do left join onte product_category_name_english IS NULL)
select
   		p.product_id,
    	p.product_category_name,
    	t.product_category_name_english
from olist_products_dataset p
left join product_category_name_translation t
    on p.product_category_name = t.product_category_name
where t.product_category_name_english IS NULL;
	
	-- B5: Identificar pedidos em que o cliente e o vendedor são do mesmo estado (join entre customers, orders, order_items e sellers).
		-- Esta query permite validar a ocorrência de vendas locais dentro da mesma unidade federativa [UF] 
select
		o.order_id,
		c.customer_state,
		s.seller_state,
		c.customer_city,
		s.seller_city
from olist_customers_dataset c
inner join olist_orders_dataset o
	on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
inner join olist_sellers_dataset s
	on oi.seller_id = s.seller_id
where c.customer_state = s.seller_state;
