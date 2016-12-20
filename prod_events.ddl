use mktgplatformdb;

CREATE EXTERNAL TABLE mktgplatformdb.prod_events (
shopper_id              string,
resource_id             int,
prod_type               string,
event_action            string

)
 PARTITIONED BY (event_date  STRING)
 Stored as ORC
LOCATION '/teams/mktgplatformdb/prod_events'
;

