SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

------------------------------

use mktgplatformdb;


INSERT OVERWRITE TABLE mktgplatformdb.customer_shopper
SELECT
ch.tdacustomerid as customer_id,
s.shopper_id,
s.first_name,          
s.middle_name,         
s.last_name, 
s.birth_day, 
s.birth_month,
s.birth_year,
s.birthdate,
s.gender,
s.state,
s.country,
s.city,               
s.postal_code,              
s.phone1,            
s.phone2,          
s.fax,               
s.shipping_method, 
s.account_create_ts,
s.account_create_date,
s.first_order_ts, 
s.first_order_date,
s.attrition_flag,
s.attrition_date,
s.business_flag,
s.private_label_id,
s.company_name,
s.private_label_reseller_type_id,
s.total_product_count,
s.total_domain_count,
s.crm_portfolio_type_id,
s.domain_portfolio_segment_id,
s.total_instore_pref_currency_amt,
s.pref_currency_code,
s.total_instore_credit_usd_amt,
s.locale_code,
s.locale_private_label_id,
s.email_hash_text,
s.email_domain_name,
s.private_label_group_name,
s.program_id,
s.encryptedShopperID,
s.reseller_optin_flag,
s.segment_code,
s.segment_source_code
FROM        
    fortknox.tdacustomerhierarchy_snap ch
        JOIN
        mktgplatformdb.shopper s
            ON ch.shopperid = s.shopper_id
            ;

