SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.shopper_spend
Select
shopper_id
,i_xxx_lt_gcr as shopper_lifetime_gcr_amt
,i_xxx_lt_orders as shopper_lifetime_order_couunt
,i_xxx_gcr_30d as shopper_last_30_day_gcr_amt
,i_xxx_gcr_fo_30d as shopper_first_30_day_gcr_amt
,i_xxx_gcr_fy as shopper_first_year_gcr_amt
,i_xxx_gcr_ly as shopper_last_cal_year_gcr_amt

FROM dbmarketing.cdl
;


