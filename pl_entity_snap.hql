SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

use mktgplatformdb;



INSERT OVERWRITE TABLE  mktgplatformdb.pl_entity_snap
Select 
tx_source_database,
tx_source_table,
tx_action,
tx_write_time,
tx_source_id,
tx_source_time,
id as entity_id,
entityname as entity_name,
isactive as active_flag,
internalregistrarid as internal_registrar_id,
merchantaccountid as merchant_account_id,
accountingcompanyid as accounting_company_id,
emailgroup_id,
gdshop_vendorid as gdshop_vendor_id,
backgrounddisplaycolor as background_display_color

FROM godaddy.pl_entity_snap
;