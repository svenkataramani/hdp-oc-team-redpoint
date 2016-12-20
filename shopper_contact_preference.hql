SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

------------------------------



Use mktgplatformdb;




INSERT OVERWRITE TABLE mktgplatformdb.shopper_contact_preference
    SELECT
         s.shopper_id
        ,Cast(fks.mktg_mail AS boolean) AS marketing_mail_flag       
        ,Case
            WHEN s.mktg_email_optin = 1 -- must be both
                and S.mktg_email = 1
                THEN 'true'
            Else 'false'
        END AS marketing_email_Flg    
        ,fks.donotcallflag AS marketing_call_flag
        ,CASE
            WHEN s.sms_optin = 0
                THEN 'true'
            ELSE 'false'
         END AS marketing_sms_flag
        , s.mktg_nonpromo_optin as marketing_nonpromo_email_flag
         
        ,COALESCE(fks.lu_emailTypeID, 2) AS email_format_pref_ind --  deafult to html = 2
        
       ,NULL as DontCntctFlg --  Same Do Not Contact as ShopAcctSuprs (only 80 -100 shoppers)
       
        ,COALESCE(SP.gdshop_currencytype, 'USD') AS preferred_currency_code -- default to USD
    FROM
        cust_customertracking.shopperheaderaudit_snap as s
        JOIN
        FortKnox.fortknox_shopper_snap fks
            ON FKS.shopper_id = S.shopper_id
        LEFT OUTER JOIN
        godaddy.gdshop_shopperpreference_snap AS SP -- preferred currency
            ON S.shopper_id = SP.shopper_id
    WHERE  s.recactive = 1       
 ;           

 