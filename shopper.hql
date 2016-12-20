SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;



Use mktgplatformdb;


--------------------
--Create Temp Tables
DROP TABLE IF EXISTS si;
CREATE TEMPORARY TABLE si AS
SELECT
    SI9.EntityID
   ,SI9.CompanyNameN
   ,SI9.PrivateLabelResellerTypeID
   ,SI8.EntityID AS EntityID2
FROM godaddy.pl_signupinfo_snap SI9
LEFT JOIN
goDaddy.gdshop_privatelabel_billing_snap PLB9
ON SI9.EntityID = PLB9.entity_id
LEFT JOIN
godaddy.pl_signupinfo_snap SI8
ON PLB9.PrivateLabelID = SI8.EntityID;

DROP TABLE IF EXISTS spqm;
CREATE TEMPORARY TABLE spqm AS
SELECT
   shopper_id,
   sum(quantity) as total_product_count         
FROM godaddy.gdshop_shopperproductquantitymap_snap
WHERE
regexp_extract(pf_id_or_namespace, '[a-zA-Z]+', 0) = ''
AND regexp_extract(shopper_id, '[a-zA-Z]+', 0) = ''
GROUP BY shopper_id;        

DROP TABLE IF EXISTS d;
CREATE TEMPORARY TABLE d AS           
SELECT
   di.shopper_id,
   sum(di.domain_count) AS total_domain_count
FROM
   (
   Select
   di.shopper_id,
   count(di.id) AS domain_count
   FROM domains.domaininfo_snap AS di
   JOIN
   domains.domaininfo_status_snap AS s
   ON di.status = s.domaininfo_statusId
   WHERE  s.iseclipseactivedomain = 1
   GROUP BY di.shopper_id
   ) AS di
   GROUP BY
    di.shopper_id;

DROP TABLE IF EXISTS ple;
CREATE TEMPORARY TABLE ple AS
SELECT DISTINCT
     ples.id
    ,ples.entityname
    ,egs.emailgroup_desc
    FROM
    godaddy.pl_entity_snap as ples
    LEFT JOIN
    godaddy.email_group_snap as egs
    ON ples.emailgroup_id = egs.emailgroup_id;
            




INSERT OVERWRITE TABLE mktgplatformdb.shopper

Select
f.shopper_id,
f.first_name,          
f.middle_name,         
f.last_name, 
f.birthday as birth_day, 
f.birthmonth as birth_month,
f.birthyear as birth_year,
TO_DATE(Concat(f.birthyear,'-',f.birthmonth,'-',f.birthday)) as birthdate2,
f.gender,
f.state, 
f.country,
f.city,                
f.zip as postal_code,                 
f.phone1,              
f.phone2,              
f.fax,                 
f.shipping_method,
f.date_created as account_create_ts,
Cast(f.date_created as DATE) as account_create_date,
c.t_xxx_firstorderdate as first_order_ts,
TO_DATE(c.t_xxx_firstorderdate) as first_order_date,
CAST(c.b_xxx_isattrition_computed as BOOLEAN) as attrition_flag,
Cast(c.t_xxx_attritiondate as DATE) as attrition_date,
Cast(gs.iscompany as BOOLEAN) as business_flag,
f.privatelabelid as private_label_id,
COALESCE(f.company, 'n/a') as company_name,
SI.PrivateLabelResellerTypeID AS private_label_reseller_type_id,
COALESCE(spqm.total_product_count, 0) as total_product_count,
COALESCE(d.total_domain_count, 0) as total_domain_count,
c.c_xxx_crmportfoliotypeid AS crm_portfolio_type_id,
a.PortfolioSegmentID as domain_portfolio_segment_id,
0 as total_instore_pref_currency_amt,  --waiting for instore to be deployed to hadoop
NULL as pref_currency_code,  -- combined with in-store source
0 as total_instore_credit_usd_amt, --same as above
CASE WHEN 
f.catalog_marketID = '' 
THEN 'en-US'
ELSE COALESCE(f.catalog_marketID, 'en-US') END AS locale_code,
CASE WHEN 
f.catalog_marketID = '' 
THEN CONCAT('en-US',a.PrivateLabelID)
ELSE CONCAT(COALESCE(f.catalog_marketID, 'en-US'),a.PrivateLabelID) END AS locale_private_label_id,
a.emailHash as email_hash_text,
f.emailDomain AS email_domain_name,
ple.emailgroup_desc as private_label_group_name,
ple.entityname as program_id,
NULL as encryptedShopperID,  --- from customerhierarchy --Add later
--CASE
--        WHEN ss.reseller_marketing_email_flag = 1
--            THEN 0
--        WHEN ss.reseller_marketing_email_flag = 0
--            THEN 1
--        ELSE
--            0
--    END 
NULL AS reseller_optin_flag,
a.SegmentCode AS segment_code,
a.SegmentSourceCode AS segment_source_code

FROM fortknox.fortknox_shopper_snap f
JOIN dbmarketing.cdl c
ON f.shopper_id = c.shopper_id
JOIN godaddy.gdshop_shopper_snap gs
ON f.shopper_id = gs.shopper_id
JOIN cust_customertracking.shopperheaderaudit_snap as a
ON f.shopper_id = a.shopper_id
LEFT JOIN SI
ON f.PrivateLabelID = SI.EntityID           
LEFT JOIN spqm
ON f.shopper_id = spqm.shopper_id
LEFT JOIN d
ON trim(f.shopper_id) = trim(d.shopper_id)
LEFT JOIN ple
ON f.privatelabelid = ple.id

--LEFT JOIN
--newdb.shopper_suppression AS ss
--ON f.shopper_id = ss.shopper_id


WHERE regexp_extract(f.shopper_id, '[a-zA-Z]+', 0) = ''
AND a.recactive = true

;

