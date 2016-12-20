SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

------------------------------

INSERT OVERWRITE TABLE mktgplatformdb.shopper_inbound_calls
SELECT
        TRIM(CAST(shopperid AS string)) AS shopper_id
        ,DateStamp AS calendar_ts
        ,TO_DATE(DateStamp) as calendar_date
        --,Cast(DateStamp as Date) AS calendar_date
        ,HoldTimeSec + TalkTimeSec + WorkTimeSec + NetQTimeSec AS total_call_duration_seconds
        ,'Inbound' as disposition
        ,RepVersion as rep_id
    FROM
        callcenterreporting.rptfactc3inboundcall_snap
        where ShopperID IS NOT NULL
        
;