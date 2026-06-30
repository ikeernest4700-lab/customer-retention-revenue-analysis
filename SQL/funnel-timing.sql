with ranking as (select 
website_session_id,
pageview_url,
created_at
from website_pageviews),



labeled as (
select

distinct website_session_id,
min(case when pageview_url in ( '/home', '/lander-1','/lander-2','/lander-2','/lander-3','/lander-4','/lander-5')
then created_at  end) as landing,
min(case when pageview_url= '/products' then created_at end) as product,
 min( case WHEN pageview_url IN ('/the-birthday-sugar-panda',
                         '/the-forever-love-bear',
                         '/the-hudson-river-mini-bear',
                         '/the-original-mr-fuzzy') then created_at  end) as product_detail,
min(case when pageview_url='/cart' then created_at  end) as cart,
min(case when pageview_url ='/shipping' then created_at  end) as shipping,
min(case when pageview_url in ('/billing', '/billing-2') then created_at  end) as billing,
min(case when pageview_url ='/thanks-for-your-order' then created_at end) as purchase

from ranking
group by 1
)

select 
website_session_id,
case when product is not null then extract(epoch from (product-landing))  end as landing_to_product_time,
case when product_detail is not null then extract(epoch from (product_detail-product)) end as product_to_product_detail_time,
case when cart is not null then extract(epoch from (cart-product_detail))  end as product_detail_to_cart_time,
case when shipping is not null then extract(epoch from (shipping-cart)) end as cart_to_shipping_time,
case when billing is not null then extract(epoch from (billing-shipping))  end as shipping_to_billing_time,
case when purchase is not null then extract(epoch from (purchase-billing))  end as billing_to_purchase_time
from labeled


