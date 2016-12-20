SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;



--------------------------------------
INSERT OVERWRITE TABLE mktgplatformdb.shopper_suppression
SELECT
        s.shopper_id
        ,CAST (CASE WHEN t.countryCode IS NOT NULL THEN 1 ELSE 0 END AS BOOLEAN) AS terrorist_country_flag
        ,CAST (CASE WHEN r.country_code IS NOT NULL THEN 1 ELSE 0 END AS BOOLEAN) AS restricted_country_flag       
        ,COALESCE(ema.excludedemailflag, false) AS excluded_email_flag       
        ,COALESCE(ema.competitorEmailFlag, false) AS competitor_email_flag      
        ,CASE 
            WHEN bc.first_name IS NOT NULL THEN 'true'
            WHEN bc.last_name IS NOT NULL THEN 'true'
            ELSE 'false'
        END AS bad_char_in_name_flag
        ,CASE
            WHEN fs.first_name IS NULL AND fs.last_name IS NULL THEN 'true'
            ELSE 'false'
        END AS no_first_and_last_name_flag      
        ,CASE WHEN vf.first_name IS NOT NULL THEN 'true' ELSE 'false' END AS vulgar_first_name_flag
        ,CASE WHEN vl.last_name IS NOT NULL THEN 'true' ELSE 'false' END AS vulgar_last_name_flag
        ,CASE WHEN s.isInternal  = 1 Then 'true' ELSE 'false' END AS internal_shopper_flag
        ,CASE WHEN s.fraudStatus IN ('P', 'Y') THEN 'true' ELSE 'false' END AS  fraud_flag      
        ,COALESCE(ema.badEmailFormatFlag, false) AS bad_email_format_flag       
        ,CASE 
            WHEN s.mktg_email_optin = 0 AND s.mktg_email = 0 THEN 'true'
            ELSE 'false'
        END AS marketing_email_flag
        ,CASE
            WHEN s.mktg_nonpromo_optin = 0 AND s.mktg_nonpromo = 0 THEN 'true'
            ELSE 'false'
        END AS marketing_nonpromo_email_flag    
        ,NULL AS do_not_contact_flag
       -- ,COALESCE(ema.DontCntctFlg, false) AS do_not_contact_flag      
       -- ,,NULL AS standard_email_suppress_flag     
       ,COALESCE(ema.softBounceFlag, false) AS soft_bounce_flag   
       ,COALESCE(ema.hardBounceFlag, false) AS hard_bounce_flag     
      -- ,NULL AS gobal_standard_email_suppress_flag
       -- ,CASE
       --     WHEN StdEmlSuprsFlg = 1 THEN 1
       --     WHEN SftBncFlg = 1 THEN 1
       --     WHEN HardBncFlg = 1 THEN 1
       --     ELSE 0
       -- END AS gobal_standard_email_suppress_flag    
        ,CASE
            WHEN scm.gdshop_shoppercostcomembershipstatusid = 1 THEN 
                (CASE WHEN scm.gdshop_shoppercostcomembershiptypeid = 1 THEN 'true' ELSE 'false' END)
            ELSE 'false'
        END AS Costco_flag -- Different type of Costco Membership - General, Executive   
         ,CASE
            WHEN s.isReseller = 0 THEN 'true'
            ELSE 'false' 
          END AS reseller_flag
          
         ,CASE
         WHEN s.isDoNotCall = 0 THEN 'false' 
         ELSE 'true' 
         END AS do_not_call_flag
         
         ,CASE
            WHEN s.privateLabelID IN (1, 2, 1387, 1592) THEN 'false'
            WHEN mopl.ResllrMktgEmlFlg = 1 THEN 'true'
            WHEN mopl.ResllrMktgEmlFlg = 0 THEN 'false'
            ELSE 'true'
        END AS reseller_marketing_email_flag
        
        ,CASE 
            WHEN gdco.pl13activeflag = 1 THEN 'true'
            ELSE 'false'
            END AS pl13_flag
            
         ,CASE
            WHEN s.privateLabelID IN (1) THEN 'true'
            ELSE 'false'
        END AS godaddy_flag 
               
       
       --,NULL AS reseller_standard_email_supress_flag
       --don't activate till standard_email_suppress_flag is validated   
          --  ,CASE
           --   WHEN standard_email_suppress_flag = 1 THEN 'true'
          --    WHEN godaddy_flag = 1 THEN 'true'
          --    ELSE 'false'
      -- END AS reseller_standard_email_supress_flag           
        
               
        FROM
        cust_customertracking.shopperheaderaudit_snap as s
        JOIN
        fortknox.fortknox_shopper_snap fs
        ON s.shopper_id = fs.shopper_id
        LEFT JOIN
        godaddy.gdshop_blockedcountry_snap AS t
            ON s.CountryCode = t.countryCode
        LEFT JOIN
        godaddy.gdshop_restrictedcountrycode_snap AS r
            ON s.CountryCode = r.country_code         
  
--     LEFT JOIN
--        (
        
--        SELECT
--                fs.shopper_id
--                ,fs.emailDomain
--                ,er.excluded_email_flag                 
               
--            FROM
--               fortknox.fortknox_shopper_snap fs
--               JOIN
--                bsherman.email_rules er
--                on fs.emailDomain = er.email_domain_name
--        ) eef
        
--        ON s.shopper_id = eef.shopper_id  
     
        LEFT JOIN
        (
            SELECT
                shopper_id
                ,first_name
                ,last_name
            FROM
                fortknox.fortknox_shopper_snap
            WHERE
                (
                    LOCATE ('|', first_name) > 0
                    OR LOCATE ('^', first_name) > 0
                    OR LOCATE ('?', first_name) > 0
                    OR LOCATE ('%', first_name) > 0
                    OR LOCATE ('|', last_name) > 0
                    OR LOCATE ('^', last_name) > 0
                    OR LOCATE ('?', last_name) > 0
                    OR LOCATE ('%', last_name) > 0
           ) 
        )bc          

            ON s.shopper_id = bc.shopper_id
            
        LEFT JOIN
        
        
        (
            SELECT
                 fs.shopper_id
                ,fs.first_name
            FROM
                fortknox.fortknox_shopper_snap fs
            JOIN
                 bsherman.vulgar_terms vt
            ON fs.first_name = vt.vulgar_term     
               
        ) AS vf
            ON s.shopper_id = vf.shopper_id
        
        
        
        LEFT JOIN
        (
            SELECT
                 fs.shopper_id
                ,fs.last_name
            FROM
                fortknox.fortknox_shopper_snap fs
            JOIN
                 bsherman.vulgar_terms vt
            ON fs.last_name = vt.vulgar_term 
            
        ) AS vl
            ON s.shopper_id = vl.shopper_id    
            
        
   --     LEFT JOIN
   --     (
   --         SELECT
   --             shopper_id
   --             ,1 as DontCntctFlg
   --         FROM
   --             P_BigReporting.vtemail_no_contact
   --     ) AS dnc
        
  
        LEFT JOIN
        (
            SELECT
                privateLabelID
                ,CASE
                    WHEN optInFlag = 1 THEN 0
                    WHEN optInFlag = 0 THEN 1
                    ELSE 1
                END AS ResllrMktgEmlFlg --They opted out. The flag is 1 to indicate suppression
            FROM
                godaddy.pl_marketingoptinprivatelabel_snap
            WHERE
                pl_marketingTypeID = 1
                AND endDate IS NULL
        ) AS mopl
         ON s.privateLabelID = mopl.privateLabelID
        
   ---     LEFT JOIN
   ---     P_TDA.vtCustHier AS ch1
   ---     ON s.shopper_id = ch1.ShopAcctId
  
   --      LEFT JOIN
   --      P_FortKnox.vtEmailAttributes AS bounce
   --      ON ch1.CustId = bounce.tdaCustomerID
  
  
        
         LEFT JOIN
        (
             SELECT
                shopper_id
                ,gdshop_shoppercostcomembershipstatusid
                ,gdshop_shoppercostcomembershiptypeid
                ,createDate              
             FROM        
        (
            SELECT
                ROW_NUMBER() OVER(PARTITION by shopper_id ORDER BY createDate DESC) AS theRank
                ,shopper_id
                ,gdshop_shoppercostcomembershipstatusid
                ,gdshop_shoppercostcomembershiptypeid
                ,createDate
            FROM
                godaddy.gdshop_shoppercostcomembership_snap
         ) scm       
            WHERE
                theRank = 1
        ) AS scm
            ON s.shopper_id = scm.shopper_id      
  
         LEFT JOIN
         cust_customertracking.gdshoppercrossover_snap gdco
         on s.shopper_id = gdco.shopper_id
         
         LEFT JOIN
         fortknox.tdaemailattributes_snap ema
         ON fs.emailhash = ema.emailhash
;
----------------------------------------------        
     

