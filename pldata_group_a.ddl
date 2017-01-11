Use mktgplatformdb; 
 
 
 CREATE EXTERNAL TABLE mktgplatformdb.pl_data_group_a(   
PrivateLabelID                int,
pl_name                       string,
plv_site_url                  string,
plv_support_url               string,
plv_support_email             string,
plv_secure_site_url           string,
plv_notify_email_address      string,
plv_receipt_bcc_address       string,
plv_transfer_out_bcc_address  string,
plv_support_phone             string,
plv_mng_domains_url           string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/pl_data_group_a'
;
 