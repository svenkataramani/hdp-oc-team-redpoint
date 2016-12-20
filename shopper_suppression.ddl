Use mktgplatformdb;



CREATE EXTERNAL TABLE mktgplatformdb.shopper_suppression (
Shopper_id                                string,
terrorist_country_flag                    boolean,
restricted_country_flag                   boolean,
excluded_email_flag                       boolean,
competitor_email_flag                     boolean,
bad_char_in_name_flag                     boolean,
no_first_and_last_name_flag               boolean,
vulgar_first_name_flag                    boolean,
vulgar_last_name_flag                     boolean,
internal_shopper_flag                     boolean,
fraud_flag                                boolean,
bad_email_format_flag                     boolean, 
marketing_email_flag                      boolean,
marketing_nonpromo_email_flag             boolean,--
do_not_contact_flag                       boolean,  --*** ???
soft_bounce_flag                          boolean,  
hard_bounce_flag                          boolean, 
costco_flag                               boolean,
reseller_flag                             boolean,
do_not_call_flag                          boolean,
reseller_marketing_email_flag             boolean,
pl13_flag                                 boolean,
godaddy_flag                              boolean
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper_suppression'
;