SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

------------------------------

SELECT
        TRIM(CAST(shopperid AS string)) AS shopper_id
        ,obc.DateStamp AS call_ts
         ,TO_DATE(OBC.DateStamp) as call_date
        ,obc.DurationSec AS total_call_duration_seconds
        ,obc.RepVersion AS rep_id
        ,cti.name AS c3_campaign_name
        ,td.Disposition AS call_disposition
    FROM
        callcenterreporting.rptfactc3outboundcall_snap AS obc
        JOIN
        callcenterreporting.rptdimc3campaign_snap AS CTI
            ON obc.c3campaignid = cti.c3campaignid
        JOIN
        callcenterreporting.rptdimc3taskdisposition_snap AS TD
            ON obc.c3taskdispositionid = td.c3taskdispositionid
    WHERE
        obc.shopperid <> 0
        
     limit 10   
        ;
        
        
  
        
        