
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE; 
 
use mktgplatformdb; 
 
------------
INSERT OVERWRITE TABLE mktgplatformdb.product_ownership
  SELECT
    PO.resource_id,
    PO.pf_id,
    PO.shopper_id,
    PO.ProdOwnClsnCd,
    PO.order_ts,
    PO.order_date,
    PO.billing_status_name,
    PO.free_product_flag,
    PO.auto_renewal_flag,
    PO.mobile_purchase_flag,
    PO.expiration_ts AS product_expiration_ts,
    PO.expiration_date AS product_expiration_date, 
    PR.prev_renewal_ts,
    CAST(PR.prev_renewal_ts as DATE) as prev_renewal_date,  
    --CASE
    --WHEN PO.ProdOwnClsnCd = 'D'
    --THEN PR.next_renewal_ts
    --ELSE
    --DATE_SUB(FROM_UNIXTIME(PO.billing_ts),1)
    --END AS next_renewal_ts,
    CASE
    WHEN PO.ProdOwnClsnCd = 'D'
    THEN TO_DATE(PR.next_renewal_ts)  
    ELSE 
    DATE_SUB(TO_DATE(PO.billing_ts),1)  
    END AS next_renewal_date,
    PO.last_renewal_ts,
    PO.last_renewal_date,
    PO.billing_ts AS next_billing_ts,
    PO.billing_date AS next_billing_date,
    PO.renewal_price_locked_flag,
    PO.locked_price_amt AS locked_renewal_price_amt,
    PO.locked_price_currency_code AS locked_renewal_price_currency_code
FROM
    (
        SELECT
            b.resource_id,
            b.pf_id,
            b.shopper_id,
            CASE
                WHEN dp.productclass like '%Domains%' -- Modify WHEN we get other product classifications
                    THEN 'D'
                ELSE
                    'O'
            END AS ProdOwnClsnCd,
            b.create_ts AS order_ts,
            b.create_date AS order_date,
            CASE
                WHEN b.billing_status_id = 1
                    THEN 'Active'
                WHEN b.billing_status_id = 2
                    THEN 'Free'
                WHEN b.billing_status_id = 4
                    THEN 'Cancelled'
                Else
                    'Unknown'
            END AS billing_status_name,
            CASE
                WHEN b.billing_status_id = 1
                    THEN 0
                WHEN b.billing_status_id = 2
                    THEN 1
                ELSE
                    NULL
            END AS free_product_flag,
            b.billing_ts,
            b.billing_date,
            b.expiration_ts,
            b.expiration_date,
            b.last_renewal_ts,
            b.last_renewal_date,
            b.previous_expiration_ts,
            b.previous_expiration_date,
            b.renewal_price_locked_flag,
            b.locked_price_amt,
            b.locked_price_currency_code,
            b.auto_renewal_flag -- billing and billing add-on, is an add-on's auto renew tied to base product?
            ,
            CASE
                WHEN mob.item_tracking_code IS NOT NULL --same issue on add-ons
                    THEN 1
                ELSE
                    0
            END AS mobile_purchase_flag
        FROM
            dm_ecommerce.fact_billing as b
            JOIN
            BigReporting.dim_product_snap AS dp
                ON b.pf_id = dp.pf_id
            LEFT OUTER JOIN
            (
                SELECT
                    order_id,
                    pf_id,
                    Shopper_id,
                    item_tracking_code
                FROM
                    dp_enterprise.uds_order uds
                    JOIN
                    (
                        SELECT
                            t.gdshop_item_trackingcode
                        FROM
                            godaddy.gdshop_item_tracking_snap AS t
                            Join
                            godaddy.gdshop_item_trackinggroup_snap AS tg
                                ON t.gdshop_item_trackinggroupid = tg.gdshop_item_trackinggroupid
                        WHERE
                            tg.description LIKE '%Mobile%'
                            AND t.gdshop_item_trackingcode IS NOT NULL
                    ) mob
                        ON uds.item_tracking_code = mob.gdshop_item_trackingcode
            ) AS mob
                ON mob.order_id = B.order_id
        WHERE
            B.billing_status_id IN (1, 2) -- Free, Active - separate view for Cancelled
            AND regexp_extract(b.shopper_id, '[a-zA-Z]+', 0) = '' -- eliminate 3 letter accounts
    ) PO
    LEFT JOIN
    (
        SELECT
            bd.resource_id,
            bd.pf_id,
            i.shopper_id,
            CASE
                WHEN bd.status = 'Free'
                    THEN 1
                ELSE
                    0
            END AS free_product_flag,
            i.id AS domain_id,
            LOWER(TRIM(i.DomainName)) as domain_name,
            i.tldid,
            t.tld,
            SUBSTR(LOWER(TRIM(i.DomainName)), 1,(LOCATE(".", TRIM(i.DomainName))) - 1) as sld,
            bd.registration_date,
            drs.renewaldate,
            drs.previousexpirationdate as prev_renewal_ts,
            drs.newexpirationdate as next_renewal_ts
                   
        FROM
            domains.domaininfo_snap AS i
            JOIN
            domains.domaininfo_status_snap AS s
                ON i.Status = s.domaininfo_statusId
            JOIN
            domains.tlds_snap AS t
                ON i.TldID = t.TldID
            JOIN
            godaddybilling.gdshop_billingdomain_snap AS bd
                ON i.id = bd.domainId
                
            JOIN
             
            (    
             Select domainid,
                    domainname,
                    renewaldate,
                    previousexpirationdate,
                    newexpirationdate     
            FROM
                    (
                        SELECT
                            ROW_NUMBER() OVER(PARTITION by domainid ORDER BY renewaldate DESC) AS Rank1,
                            domainid,
                            domainname,
                            renewalDate,
                            previousExpirationDate,
                            newExpirationDate
                        FROM
                            domains.rec_domainrenewal_snap
                     )  dfr  
                where  Rank1 = 1
             ) drs
             ON i.id = drs.domainid
             AND i.domainname = drs.domainname
             WHERE  s.iseclipseactivedomain = 1
            
    ) PR
        ON PO.resource_id = PR.resource_id
            AND PO.pf_id = PR.pf_id
            AND PO.shopper_id = PR.shopper_id
            ;

  