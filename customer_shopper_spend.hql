SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.customer_shopper_spend
Select
ch.tdacustomerid as customer_id
,s.shopper_id
,s.shopper_lifetime_gcr_amt
,s.shopper_lifetime_order_count
,s.shopper_last_30_day_gcr_amt
,s.shopper_first_30_day_gcr_amt
,s.shopper_first_year_gcr_amt
,s.shopper_last_cal_year_gcr_amt

FROM        
    fortknox.tdacustomerhierarchy_snap ch
        JOIN
        mktgplatformdb.shopper_spend s
            ON ch.shopperid = s.shopper_id
            ;