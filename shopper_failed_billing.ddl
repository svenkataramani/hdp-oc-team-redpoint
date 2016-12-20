use mktgplatformdb;

CREATE EXTERNAL TABLE mktgplatformdb.shopper_failed_billing (
gdshop_billing_resource_history_id          INT,
shopper_id                                  string,
date_entered                                timestamp,
order_id                                    string,
row_id                                      int,
resource_id                                 int,
gdshop_billing_attempt_id                   int,
adjusted_price                              int,
gdshop_product_type_id                      int,
cpl_id                                      int,
billing_attempt                             int,
response_code                               smallint,
reason_code                                 smallint,
source                                      string,
billing_country_code                        string,
total                                       int,
attempts                                    tinyint 
)
Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper_failed_billing'
;