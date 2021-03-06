Use mktgplatformdb;


CREATE EXTERNAL TABLE mktgplatformdb.customer_shopper_spend (
customer_id                      int,
shopper_id                       string,
shopper_lifetime_gcr_amt         double,
shopper_lifetime_order_count     int,
shopper_last_30_day_gcr_amt      double,
shopper_first_30_day_gcr_amt     double,
shopper_first_year_gcr_amt       double,
shopper_last_cal_year_gcr_amt    double
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/customer_shopper_spend'
;