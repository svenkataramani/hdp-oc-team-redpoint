SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.support_market_group_a
    SELECT
     catalog_marketID as catalog_market_id
    ,privateLabelResellerTypeID as Private_label_reseller_type_id
    ,MAX(CASE WHEN gdshop_supporttypeid = 33 THEN CAST(contactInfo AS string) ELSE '' END) AS assisted_service_phone 
    ,MAX(CASE WHEN gdshop_supporttypeid = 34 THEN CAST(contactInfo AS string) ELSE '' END) AS billing_phone
    ,MAX(CASE WHEN gdshop_supporttypeid = 45 THEN CAST(contactInfo AS string) ELSE '' END) AS marketing_phone
    ,MAX(CASE WHEN gdshop_supporttypeid = 53 THEN CAST(contactInfo AS string) ELSE '' END) AS support_phone
    ,MAX(CASE WHEN gdshop_supporttypeid = 3  THEN CAST(contactInfo AS string) ELSE '' END) AS support_hours
    ,SUBSTRING( catalog_marketID, LENGTH( catalog_marketID ) - 1   ) AS market_id
    FROM
    godaddy.gdshop_supportmarket_mtm_supporttype_snap
    GROUP BY catalog_marketID, privateLabelResellerTypeID;
    
	
	
