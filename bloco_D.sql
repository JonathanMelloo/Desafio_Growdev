-- bloco_D.sql - Subqueries

	-- D1: Clientes cujo gasto total está acima da média geral de gasto por cliente.
		-- Esta query permite identificar clientes com gasto superior à média da base.
select
		c.customer_id,
		sum(oi.price) AS gasto_total
from olist_customers_dataset c
inner join olist_orders_dataset o
	on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
group by c.customer_id
having sum (oi.price) >
(select
		avg(gasto_cliente)
from
(select
 		c.customer_id,
        sum(oi.price) AS gasto_cliente
from olist_customers_dataset c
inner join olist_orders_dataset o
	on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
group by c.customer_id ) media_clientes)
order by gasto_total desc;

	-- D2: Produtos que nunca receberam avaliação.
		-- Esta query permite identificar produtos sem registros de avaliação pelos clientes.
select
		p.product_id,
		p.product_category_name
from olist_products_dataset p
where not exists (
select 1
from olist_order_items_dataset o
inner join olist_order_reviews_dataset r
	on o.order_id = r.order_id
where o.product_id = p.product_id);

	-- D3: Vendedores que venderam produtos de mais de 5 categorias diferentes.
		-- Esta query permite identificar vendedores com maior diversidade de portfólio.
select
		s.seller_id
from olist_sellers_dataset s
where s.seller_id in
(
select
		o.seller_id
from olist_order_items_dataset o
inner join olist_products_dataset p
	on o.product_id = p.product_id
group by o.seller_id
having count(distinct p.product_category_name) > 5)
order by s.seller_id;

	-- D4: Pedidos cujo valor de frete é maior que o valor total dos itens.
		-- Esta query permite identificar situações onde o custo logístico supera o valor dos produtos vendidos.
select
		o.order_id,
		sum(o.freight_value) as valor_frete
from olist_order_items_dataset o
group by o.order_id
having sum(o.freight_value) >
(
select sum(o2.price)
from olist_order_items_dataset o2
where o2.order_id = o.order_id
)
order by valor_frete desc;
