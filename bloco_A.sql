-- bloco_A.sql - Select básico

	-- A1: Listar os 20 pedidos com status 'delivered' mais recentes, ordenados pela data de entrega.
		-- Esta query permite analisar as entregas concluídas mais próximas da data atual da base.
select
		order_id,
		order_status,
		order_delivered_customer_date
from olist_orders_dataset ood  
where order_status = 'delivered'
order by order_delivered_customer_date desc
limit 20;

	-- A2: Listar todos os produtos de uma categoria específica (usando a tabela de tradução para filtrar pelo nome em português).
		-- Esta query permite consultar os itens cadastrados em determinada categoria de negócio.
select
		p.product_id,
		t.product_category_name as Nome_Produto_Pt,
		t.product_category_name_english as Nome_Produto_En
from olist_products_dataset p
inner join product_category_name_translation t
		on p.product_category_name = t.product_category_name
where t.product_category_name = 'perfumaria';
	
	-- A3: Listar os métodos de pagamento distintos utilizados na base ('select distinct payment_type).
		-- Esta query permite conhecer as formas de pagamento disponíveis na base.
select distinct
		payment_type
from olist_order_payments_dataset;

	-- A4: Listar os produtos com peso (product_weight_g) acima de 10kg, ordenados do mais pesado para o mais leve.
		-- Esta query permite identificar itens mais pesados para análises de logísticas e de transporte.
select
		product_id,
		product_category_name,
		product_weight_g
from olist_products_dataset
where product_weight_g > 10000
order by product_weight_g desc;
