-- bloco_C.sql - Funções Agregadas + GROUP BY + HAVING

	-- C1: Faturamento total por estado do cliente.
		-- Esta query permite identificar quais estados geram maior receita para o e-commerce.
select
		c.customer_state,
		sum(oi.price) as faturamento_total
from olist_customers_dataset c
inner join olist_orders_dataset o
	on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
group by c.customer_state
order by faturamento_total desc;
		
	-- C2: Top 10 vendedores por faturamento.
		-- Esta query permite identificar os vendedores com melhor desempenho financeiro na plataforma.
select
		s.seller_id,
		sum(o.price) as faturamento_total
from olist_sellers_dataset s
inner join olist_order_items_dataset o
	on s.seller_id = o.seller_id
group by s.seller_id
order by faturamento_total desc
limit 10;

	-- C3: Ticket médio por categoria de produto.
		-- Esta query permite analisar o valor médio gasto pelos clientes em cada categoria de produto.
select
		p.product_category_name,
		AVG(o.price) as ticket_medio
from olist_products_dataset p
inner join olist_order_items_dataset o
	on p.product_id = o.product_id 
group by p.product_category_name 
order by ticket_medio desc;

	-- C4: Vendedores com nota média de avaliação abaixo de 3.
		-- Esta query permite identificar vendedores com baixo índice de satisfação dos clientes.
select
		s.seller_id,
		AVG(r.review_score) as nota_media
from olist_sellers_dataset s
inner join olist_order_items_dataset o
	on s.seller_id = o.seller_id 
inner join olist_order_reviews_dataset r
	on o.order_id = r.order_id
group by s.seller_id 
having AVG(r.review_score) < 3
order by nota_media desc;

	-- C5: Quantidade de pedidos por forma de pagamento.
		-- Esta query permite identificar os meios de pagamento mais utilizados pelos clientes.
select
		payment_type,
		count(distinct order_id) as quantidade_pedidos
from olist_order_payments_dataset
group by payment_type
order by quantidade_pedidos desc;

	-- C6: Peso médio dos produtos por categoria.
		-- Esta query permite analisar características logísticas das categorias comercializadas.
select 
		product_category_name,
		avg(product_weight_g) as peso_medio_g
from olist_products_dataset
group by product_category_name
order by peso_medio_g desc;

	-- C7: Número médio de parcelas por categoria de produto.
		-- Esta query permite avaliar o comportamento de parcelamento dos clientes por categoria.
select
		p.product_category_name,
		avg(op.payment_installments) as media_parcelas
from olist_products_dataset p
inner join olist_order_items_dataset o
	on p.product_id = o.product_id 
inner join olist_order_payments_dataset op
	on o.order_id = op.order_id
group by p.product_category_name
order by media_parcelas desc;
