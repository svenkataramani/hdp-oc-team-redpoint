Use mktgplatformdb;


CREATE EXTERNAL TABLE mktgplatformdb.abandoned_cart(   
        shopper_id              string,
        visit_ts                timestamp,
        visit_date              date,
        visit_tracking_id       int,
        cart_add_ts             timestamp,
        cart_add_date           date,
        order_id                string,
        adjusted_price          int,
        pf_id                   int,
        cart_qty                int   
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/abandoned_cart'
;


     