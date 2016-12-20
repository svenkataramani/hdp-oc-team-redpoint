SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;
 -----------------
 CREATE EXTERNAL TABLE mktgplatformdb.pl_data_group_a(   
PrivateLabelID                int,
pl_name                       string,
plv_site_url                  string,
plv_support_url               string,
plv_support_email             string,
plv_secure_site_url           string,
plv_notify_email_address      string,
plv_receipt_bcc_address       string,
plv_transfer_out_bcc_address  string,
plv_support_phone             string,
plv_mng_domains_url           string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/pl_data_group_a'
;
 
 
 
 ------------------
 INSERT OVERWRITE TABLE mktgplatformdb.pl_data_group_a
 SELECT
     privatelabelid
 ,MAX(CASE WHEN Category = 0  THEN CAST(data AS string) ELSE NULL END) AS pl_name
 ,MAX(CASE WHEN Category = 2  THEN CAST(data AS string) ELSE NULL END) AS plv_site_url
 ,MAX(CASE WHEN Category = 8  THEN CAST(data AS string) ELSE NULL END) AS plv_support_url
 ,MAX(CASE WHEN Category = 9  THEN CAST(data AS string) ELSE NULL END) AS plv_support_email
 ,MAX(CASE WHEN Category = 17 THEN CAST(data AS string) ELSE NULL END) AS plv_secure_site_url
 ,MAX(CASE WHEN Category = 25 THEN CAST(data AS string) ELSE NULL END) AS plv_notify_email_address
 ,MAX(CASE WHEN Category = 30 THEN CAST(data AS string) ELSE NULL END) AS plv_receipt_bcc_address
 ,MAX(CASE WHEN Category = 34 THEN CAST(data AS string) ELSE NULL END) AS plv_transfer_out_bcc_address
 ,MAX(CASE WHEN Category = 46 THEN CAST(data AS string) ELSE NULL END) AS plv_support_phone
 ,MAX(CASE WHEN Category = 47 THEN CAST(data AS string) ELSE NULL END) AS plv_mng_domains_url
    FROM
        godaddy.pl_data_snap
 GROUP BY privatelabelid
  ;
  
---------------------

