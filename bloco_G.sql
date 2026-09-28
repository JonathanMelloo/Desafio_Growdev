-- bloco_G.sql - Views

	-- G1: Criar a view vw_pedidos_completos.
		-- Esta view consolida pedidos, clientes, itens, pagamentos e vendedores para análises futuras.
create view vw_pedidos_completos as
select
	o.order_id,
	o.order_status,
	o.order_purchase_timestamp,
	c.customer_id,
	c.customer_city,
	c.customer_state,
	oi.product_id,
	oi.seller_id,
	oi.price,
	oi.freight_value,
	op.payment_type,
	op.payment_installments,
	op.payment_value,
	s.seller_city,
	s.seller_state
from olist_orders_dataset o
inner join olist_customers_dataset c
	on o.customer_id = c.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
inner join olist_order_payments_dataset op
	on o.order_id = op.order_id
inner join olist_sellers_dataset s
	on oi.seller_id = s.seller_id;

	-- G2: Criar a view vw_avaliacoes_categoria.
		-- Esta view consolida indicadores de avaliação por categoria de produto.
create view vw_avaliacoes_categoria as
select
	p.product_category_name,
	count(r.review_id) as volume_avaliacoes,
	avg(r.review_score) as nota_media
from olist_products_dataset p
inner join olist_order_items_dataset oi
	on p.product_id = oi.product_id
inner join olist_order_reviews_dataset r
	on oi.order_id = r.order_id
group by p.product_category_name;
