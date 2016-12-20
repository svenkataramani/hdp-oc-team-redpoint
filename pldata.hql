SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.pl_data
SELECT
tx_source_database,
tx_source_table,
tx_action,
tx_write_time as tx_write_ts,
TO_DATE(tx_write_time) as tx_write_date,
tx_source_id,
tx_source_time as tx_source_ts,
TO_DATE(tx_source_time) AS tx_source_date,
category as category_id,
privatelabelid as private_label_id,
data as private_label_name
FROM godaddy.pl_data_snap
;