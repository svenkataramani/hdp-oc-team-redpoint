CREATE EXTERNAL TABLE mktgplatformdb.shopper_outbound_calls(   
shopper_id                       string,
call_ts                          timestamp,
call_date                        date,
total_call_duration_seconds      int,
rep_id                           int,
c3_campaign_name                 string,
call_disposition                 string,

)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper_inbound_calls'
;




        ,OBC.RepVersion AS RepId
        ,CTI.name AS C3_campaign_name
        ,TD.Disposition AS call_disposition