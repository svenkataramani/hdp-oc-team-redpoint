Use mktgplatformdb;

CREATE EXTERNAL TABLE mktgplatformdb.gdshop_marketing_contact
(
      gdshop_mktg_contact_id    INT
     ,first_name                string
     ,last_name                 string
     ,contact_hash              string
     --,EncrptdEmlAddrTxt
     ,email_type               tinyint
     ,City                     string
     ,State                    string
     ,Country                  string
     ,postal_code              string
     ,Phone1                   string
     ,Phone2                   string
     ,market_id                string
     ,Env_Var1                 string
     ,Env_Var2                 string
     ,Env_Var3                 string
     ,list_source              string
     ,godaddy_shopper_flag     boolean
     ,create_ts                timestamp
     ,modify_ts                timestamp
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/gdshop_marketing_contact'
;
 

