model (
    name gold.fact__orders,
    kind full
);

select
    sat__order.order_pit_hk
,   sat__customer.customer_pit_hk
,   sat__product.product_pit_hk
,   sat__store.store_pit_hk
,   sat__order.ordered_at
,   sat__item.quantity
,   sat__product.price
,   sat__store.tax_rate
,   sat__product.price * sat__store.tax_rate as tax
,   sat__product.price * (1 + sat__store.tax_rate) as price_with_tax
,   sat__order.valid_from
,   sat__order.valid_to

from
    silver.hub__order
    
    inner join silver.sat__order
        on hub__order.order_hk = sat__order.order_hk

    inner join silver.link__customer__order
        on hub__order.order_hk = link__customer__order.order_hk
        and sat__order.valid_from between link__customer__order.valid_from and link__customer__order.valid_to
    
    inner join silver.hub__customer
        on link__customer__order.customer_hk = hub__customer.customer_hk

    inner join silver.sat__customer
        on hub__customer.customer_hk = sat__customer.customer_hk
        and sat__order.valid_from between sat__customer.valid_from and sat__customer.valid_to
    
    inner join silver.link__order__product
        on hub__order.order_hk = link__order__product.order_hk
        and sat__order.valid_from between link__order__product.valid_from and link__order__product.valid_to
    
    inner join silver.sat__item
        on link__order__product.order_hk__product_hk = sat__item.order_hk__product_hk
        and sat__order.valid_from between sat__item.valid_from and sat__item.valid_to
    
    inner join silver.hub__product
        on link__order__product.product_hk = hub__product.product_hk
    
    inner join silver.sat__product
        on hub__product.product_hk = sat__product.product_hk
        and sat__order.valid_from between sat__product.valid_from and sat__product.valid_to

    inner join silver.link__order__store
        on hub__order.order_hk = link__order__store.order_hk
        and sat__order.valid_from between link__order__store.valid_from and link__order__store.valid_to
    
    inner join silver.hub__store
        on link__order__store.store_hk = hub__store.store_hk
    
    inner join silver.sat__store
        on hub__store.store_hk = sat__store.store_hk
        and sat__order.valid_from between sat__store.valid_from and sat__store.valid_to
;