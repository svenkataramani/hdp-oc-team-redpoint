use mktgplatformdb;


CREATE EXTERNAL TABLE mktgplatformdb.pl_entity_snap
(
tx_source_database       string,
tx_source_table           string,
tx_action                 string,
tx_write_time             timestamp,
tx_source_id              binary,
tx_source_time            timestamp,
entity_id                 int,
entity_name               string,
active_flag               tinyint,
internal_registrar_id     int,
merchant_account_id       int,
accounting_company_id     int,
emailgroup_id             int,
gdshop_vendor_id          int,
background_display_color  string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/pl_entity_snap'
;

