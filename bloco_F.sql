-- bloco_F.sql - CTE (Common Table Expressions)

	-- F1: Faturamento mensal por estado com variação percentual entre meses.
		-- Esta query permite analisar tendências de crescimento ou queda do faturamento por estado.
with faturamento_mensal as
(
	select
		c.customer_state,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		) as mes_referencia,
		sum(oi.price) as faturamento
	from olist_customers_dataset c
	inner join olist_orders_dataset o
		on c.customer_id = o.customer_id
	inner join olist_order_items_dataset oi
		on o.order_id = oi.order_id
	group by
		c.customer_state,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		)
)
select *
from faturamento_mensal;
		
	-- F2: Volume de avaliações e nota média por categoria.
		-- Esta query permite identificar categorias com pior reputação considerando nota e volume de avaliações.
with avaliacoes_categoria as
(
	select
		p.product_category_name,
		count(*) as volume_avaliacoes,
		avg(r.review_score) as nota_media
	from olist_products_dataset p
	inner join olist_order_items_dataset oi
		on p.product_id = oi.product_id
	inner join olist_order_reviews_dataset r
		on oi.order_id = r.order_id
	group by p.product_category_name
)
select
	product_category_name,
	volume_avaliacoes,
	nota_media
from avaliacoes_categoria
where volume_avaliacoes >= 100
order by
	nota_media asc,
	volume_avaliacoes desc;
	
	-- F3: Comparação do frete médio por estado com a média geral.
		-- Esta query permite identificar estados com custos logísticos acima ou abaixo da média da base.
with frete_estado as
(
select
c.customer_state,
avg(oi.freight_value) as frete_medio_estado
from olist_customers_dataset c
inner join olist_orders_dataset o
on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
on o.order_id = oi.order_id
group by c.customer_state
)
select
customer_state,
frete_medio_estado
from frete_estado
order by frete_medio_estado desc;
