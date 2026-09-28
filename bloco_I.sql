-- I2: Faturamento mensal acumulado por vendedor.
		-- Esta query permite acompanhar a evolução acumulada da receita de cada vendedor ao longo do tempo.
with faturamento_mensal as
(
	select
		oi.seller_id,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		) as mes_referencia,
		sum(oi.price) as faturamento_mes
	from olist_order_items_dataset oi
	inner join olist_orders_dataset o
		on oi.order_id = o.order_id
	group by
		oi.seller_id,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		)
)
select
	seller_id,
	mes_referencia,
	faturamento_mes,
	sum(faturamento_mes) over
	(
		partition by seller_id
		order by mes_referencia
	) as faturamento_acumulado
from faturamento_mensal
order by
	seller_id,
	mes_referencia;

	-- I3: Percentual de participação do vendedor no faturamento do estado.
		-- Esta query permite medir a representatividade de cada vendedor em sua região.
select
	s.seller_state,
	s.seller_id,
	sum(oi.price) as faturamento_vendedor,
	(
		sum(oi.price) * 100.0
		/
		sum(sum(oi.price)) over
		(
			partition by s.seller_state
		)
	) as percentual_participacao
from olist_sellers_dataset s
inner join olist_order_items_dataset oi
	on s.seller_id = oi.seller_id
group by
	s.seller_state,
	s.seller_id
order by
	s.seller_state,
	percentual_participacao desc;
	
	-- I4: Variação de faturamento mês a mês por vendedor.
		-- Esta query permite identificar crescimento ou queda de desempenho ao longo do tempo.
with faturamento_mensal as
(
	select
		oi.seller_id,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		) as mes_referencia,
		sum(oi.price) as faturamento_mes
	from olist_order_items_dataset oi
	inner join olist_orders_dataset o
		on oi.order_id = o.order_id
	group by
		oi.seller_id,
		date_trunc(
			'month',
			o.order_purchase_timestamp::timestamp
		)
)
select
	seller_id,
	mes_referencia,
	faturamento_mes,
	lag(faturamento_mes) over
	(
		partition by seller_id
		order by mes_referencia
	) as faturamento_mes_anterior,
	faturamento_mes
	-
	lag(faturamento_mes) over
	(
		partition by seller_id
		order by mes_referencia
	) as variacao_faturamento
from faturamento_mensal
order by
	seller_id,
	mes_referencia;
