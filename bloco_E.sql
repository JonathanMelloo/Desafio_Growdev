-- bloco_E.sql - CASE WHEN

	-- E1: Classificar pedidos por prazo de entrega.
		-- Esta query permite categorizar entregas como adiantadas, no prazo ou atrasadas.
select
		order_id,
		order_delivered_customer_date,
		order_estimated_delivery_date,
		case
			when order_delivered_customer_date < order_estimated_delivery_date
			then 'Adiantado'
			when order_delivered_customer_date = order_estimated_delivery_date
			then 'No Prazo'
			when order_delivered_customer_date > order_estimated_delivery_date
			then 'Atrasado'
			else 'Sem informação'
		end as status_entrega
from olist_orders_dataset;
		
	-- E2: Classificar clientes por faixa de gasto total.
		-- Esta query permite segmentar clientes conforme seu volume de compras.
select
		c.customer_id,
		sum(oi.price) as gasto_total,
		case 
			when sum(oi.price) <= 500
			then 'Bronze'
			when sum(oi.price) <= 2000
			then 'Prata'
			else 'Ouro'
		end as classificacao_cliente
from olist_customers_dataset c
inner join olist_orders_dataset o
	on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
	on o.order_id = oi.order_id
group by c.customer_id
order by gasto_total desc;
		
	-- E3: Classificar produtos por faixa de peso.
		-- Esta query permite categorizar produtos de acordo com suas características logísticas.
select
		product_id,
		product_category_name,
		product_weight_g,
		case
			when product_weight_g <= 1000
			then 'Leve'
			when product_weight_g <= 5000
			then 'Médio'
			else 'Pesado'
		end as classificacao_peso
from olist_products_dataset
order by product_weight_g desc;

	-- E4: Classificar pagamentos como à vista ou parcelado.
		-- Esta query permite analisar o perfil de pagamento utilizado pelos clientes.
select
		order_id,
		payment_type,
		payment_installments,
		case
			when payment_installments = 1
			then 'À Vista'
			when payment_installments between 2 and 6
			then 'Parcelado'
			else 'Parcelado Longo'
		end as classificado_pagamento
from olist_order_payments_dataset
order by payment_installments desc;
