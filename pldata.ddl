use mktgplatformdb;

CREATE EXTERNAL TABLE mktgplatformdb.pl_data (
tx_source_database      string,
tx_source_table         string,
tx_action               string,
tx_write_ts             timestamp,
tx_write_date           date,
tx_source_id            binary,
tx_source_ts            timestamp,
tx_source_date          date,
category_id             int,
privatelabelid          int,
private_label_name      string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/pl_data'
;

