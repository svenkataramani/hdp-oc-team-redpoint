SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.gdshop_mktg_publication_emailoptin
SELECT
      gdshop_mktg_publication_emailoptin_id
     ,gdshop_email_id AS gds_marketing_contact_id
     ,gdshop_mktg_publication_id AS gds_marketing_pub
     ,privatelabelid AS private_label_id
     ,opt_in_date
     ,opt_out_date
     ,cast(isConfirmed AS boolean) AS confirmed_flag
     ,fromApp AS from_app
     ,fromIPAddr AS from_ip_address
     ,entity_ID AS entity_id
     ,catalog_countrySite AS catalog_country_site
     ,catalog_marketID AS catalog_market_id
     ,visitorguid  AS vistor_guid
FROM
   godaddy.gdshop_mktg_publication_emailoptin_snap
WHERE
     isConfirmed = 1
     ;
     
 
