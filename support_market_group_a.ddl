Use mktgplatformdb;
	

CREATE EXTERNAL TABLE mktgplatformdb.support_market_group_a (	
	 catalog_market_id                string
	,Private_label_reseller_type_id   string
    ,assisted_service_phone           string
    ,billing_phone                    string
    ,marketing_phone                  string    
    ,support_phone                    string
    ,support_hours                    string
    ,market_id                        string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/support_market_group_a'
;