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


INSERT OVERWRITE TABLE mktgplatformdb.customer_shopper_contact_preference
Select
     ch.tdacustomerid as customer_id
    ,s.shopper_id
    ,s.marketing_mail_flag
    ,s.marketing_email_Flg
    ,s.marketing_call_flag
    ,s.marketing_sms_flag
    ,s.marketing_nonpromo_email_flag
    ,s.email_format_pref_ind
    ,s.do_not_contact_flag
    ,s.preferred_currency_code

FROM
        fortknox.tdacustomerhierarchy_snap ch
        JOIN
        mktgplatformdb.shopper_contact_preference s
            ON ch.shopperid = s.shopper_id
            ;