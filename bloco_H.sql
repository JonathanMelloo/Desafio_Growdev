-- bloco_H.sql - Functions / Procedures

	-- H1: Criar a function sp_relatorio_vendedor.
		-- Esta função permite consultar faturamento, ticket médio e avaliação de um vendedor em determinado período.
create or replace function sp_relatorio_vendedor
(
	p_id_vendedor varchar,
	p_data_inicio timestamp,
	p_data_fim timestamp
)
returns table
(
	seller_id varchar,
	faturamento_total numeric,
	ticket_medio numeric,
	nota_media numeric
)
language sql
as
$$

select
	s.seller_id,
	sum(oi.price) as faturamento_total,
	avg(oi.price) as ticket_medio,
	avg(r.review_score) as nota_media
from olist_sellers_dataset s
inner join olist_order_items_dataset oi
	on s.seller_id = oi.seller_id
inner join olist_orders_dataset o
	on oi.order_id = o.order_id
left join olist_order_reviews_dataset r
	on o.order_id = r.order_id
where s.seller_id = p_id_vendedor
	and o.order_purchase_timestamp::timestamp
		between p_data_inicio and p_data_fim
group by s.seller_id;

$$;

	-- H2: Criar a function sp_relatorio_categoria.
		-- Esta função permite consultar faturamento e ticket médio de uma categoria em determinado período.
create or replace function sp_relatorio_categoria
(
	p_categoria varchar,
	p_data_inicio timestamp,
	p_data_fim timestamp
)
returns table
(
	categoria varchar,
	faturamento_total numeric,
	ticket_medio numeric
)
language sql
as
$$

select
	p.product_category_name as categoria,
	sum(oi.price) as faturamento_total,
	avg(oi.price) as ticket_medio
from olist_products_dataset p
inner join olist_order_items_dataset oi
	on p.product_id = oi.product_id
inner join olist_orders_dataset o
	on oi.order_id = o.order_id
where p.product_category_name = p_categoria
	and o.order_purchase_timestamp::timestamp
		between p_data_inicio and p_data_fim
group by p.product_category_name;

$$;
