Use mktgplatformdb;



CREATE EXTERNAL TABLE mktgplatformdb.shopper (
shopper_id                       string,
first_name                       string,          
middle_name                      string,         
last_name                        string, 
birth_day                        int, 
birth_month                      int,
birth_year                       int,
birthdate                        string,
gender                           string,
state                            string,
country                          string,
city                             string,               
postal_code                      string,              
phone1                           string,            
phone2                           string,          
fax                              string,               
shipping_method                  string, 
account_create_ts                timestamp,
account_create_date              date,
first_order_ts                   timestamp, 
first_order_date                 date,
attrition_flag                   boolean,
attrition_date                   date,
business_flag                    boolean,
private_label_id                 int,
company_name                     string,
private_label_reseller_type_id                 int,
total_product_count               bigint,
total_domain_count                bigint,
crm_portfolio_type_id             int,
domain_portfolio_segment_id       int,
total_instore_pref_currency_amt   int,
pref_currency_code                string,
total_instore_credit_usd_amt      int,
locale_code                       string,
locale_private_label_id           string,
email_hash_text                   string,
email_domain_name                 string,
private_label_group_name          string,
program_id                        string,
encryptedShopperID                string,
reseller_optin_flag               boolean,
segment_code                      int,
segment_source_code               int

)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper'
;

