CREATE EXTERNAL TABLE mktgplatformdb.shopper_inbound_calls(   
shopper_id                       string,
call_ts                      timestamp,
call_date                    date,
total_call_duration_seconds      int,
disposition                      string,
rep_id                           int
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper_inbound_calls'
;