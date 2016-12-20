SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

------------------------------



use mktgplatformdb;

---------

DROP TABLE IF EXISTS brh;
CREATE TEMPORARY TABLE brh AS
select *
from godaddybilling.gdshop_billingresourcehistory_snap
where to_date(date_entered) >= date_sub(to_date(from_unixtime(unix_timestamp())), 30)
;


DROP TABLE IF EXISTS cpl;
CREATE TEMPORARY TABLE cpl AS
select *
from godaddycpl.gdshop_common_purchase_log_snap
where to_date(date_entered) >= date_sub(to_date(from_unixtime(unix_timestamp())), 30)
;


DROP TABLE IF EXISTS shopper_failed_billing_stg;
CREATE TEMPORARY TABLE shopper_failed_billing_stg AS
select distinct 
brh.gdshop_billingresourcehistoryid as gdshop_billing_resource_history_id, 
brh.shopper_id, 
brh.date_entered, 
brh.order_id, 
brh.row_id, 
brh. resource_id, 
brh.gdshop_billing_attemptid, 
brh.adjusted_price, 
brh.gdshop_product_typeid, 
cpl.cpl_id, 
cpl.billing_attempt, 
cpl.response_code, 
cpl.reason_code, 
cpl.source, 
cpl.billing_country_code, 
cpl.total, 
cpl.attempts
from brh
left outer join cpl 
on brh.order_id = cpl.order_id
;


INSERT INTO mktgplatformdb.shopper_failed_billing
SELECT
gdshop_billing_resource_history_id, 
shopper_id, 
date_entered, 
order_id, 
row_id, 
resource_id, 
gdshop_billing_attemptid AS gdshop_billing_attempt_id, 
adjusted_price, 
gdshop_product_typeid AS gdshop_product_type_id, 
cpl_id, 
billing_attempt, 
response_code, 
reason_code, 
source, 
billing_country_code, 
total, 
attempts
from shopper_failed_billing_stg


