SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE; 
 
 --------------------

 
INSERT OVERWRITE TABLE mktgplatformdb.pl_data_group_b
SELECT
  privatelabelid
 ,MAX(CASE WHEN Category = 13 THEN CAST(data AS string) ELSE NULL END) AS plv_bulk_prices
 ,MAX(CASE WHEN Category = 15 THEN CAST(data AS string) ELSE NULL END) AS plv_special_offers
 ,MAX(CASE WHEN Category = 85 THEN CAST(data AS string) ELSE NULL END) AS plv_legal_agreements
    FROM
         godaddy.pl_data_snap
 GROUP BY privatelabelid
  ;