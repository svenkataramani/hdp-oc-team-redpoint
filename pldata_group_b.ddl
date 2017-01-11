

Use mktgplatformdb; 

CREATE EXTERNAL TABLE mktgplatformdb.pl_data_group_b(  
PrivateLabelID                int,
plv_bulk_prices               string,
plv_special_offers            string,
 plv_legal_agreements         string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/pl_data_group_b'
;
 