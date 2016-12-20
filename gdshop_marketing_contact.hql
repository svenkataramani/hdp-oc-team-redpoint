
--------------------------------------------
SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;



Use mktgplatformdb;

INSERT OVERWRITE TABLE mktgplatformdb.gdshop_marketing_contact
SELECT
      mc.gdshop_mktg_contactid as gdshop_mktg_contact_id
     ,mc.firstName as first_name
     ,mc.lastName as last_name
     ,mc.contactHash as contact_hash
     --,CAST(pa.PublicKeyID AS VARCHAR(8))
     -- || '.'
      --|| pa.encryptedEmailAddress AS EncrptdEmlAddrTxt
     ,mc.emailType as email_type
     ,'Scottsdale' AS City
     ,'AZ' AS State
     ,'US' AS Country 
     ,'85260' AS postal_code
     ,'480-505-8877' AS Phone1
     ,NULL AS Phone2
     ,'es-US'AS market_id
     ,NULL AS Env_Var1
     ,NULL AS Env_Var2
     ,NULL AS Env_Var3   
     ,'GodaddyPrivacyApp'  AS list_source
     ,CAST( CASE WHEN isf.gdshop_mktg_contactid IS NOT NULL THEN true
        ELSE false END AS BOOLEAN ) AS godaddy_shopper_flag 
     ,mc.createDate as create_date
     ,mc.modifyDate as modify_date
FROM
   GoDaddy.gdshop_mktg_contact_snap AS mc
   JOIN
   godaddyPrivacyApp.tdaprivacyattributes_snap AS pa
     ON mc.contactHash = pa.emailHash
   LEFT JOIN   
    ( SELECT DISTINCT mc2.gdshop_mktg_contactid FROM
        GoDaddy.gdshop_mktg_contact_snap AS mc2  
      JOIN mktgplatformdb.shopper csa
        ON mc2.ContactHash = csa.email_hash_text 
    ) AS isf 
    ON  mc.gdshop_mktg_contactid = isf.gdshop_mktg_contactid 
WHERE
   mc.contactHash IS NOT NULL
   AND pa.competitorEmailFlag = false
   AND pa.excludedEmailFlag = false
   AND pa.badEmailFormatFlag = false   
;