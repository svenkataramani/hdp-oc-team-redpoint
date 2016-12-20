SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;


--------------------


INSERT OVERWRITE TABLE mktgplatformdb.afn_state_codes
SELECT
    StateID AS state_code_id
 ,StateName AS state_name
 ,USPSShort AS state_code
 ,StateName AS clean_state_name
FROM godaddy.lu_state_snap;