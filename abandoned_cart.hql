SET hive.cli.print.header=TRUE;
SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

Use mktgplatformdb;

INSERT OVERWRITE TABLE TABLE mktgplatformdb.abandoned_cart
SELECT DISTINCT
        vsid.shopperID AS shopper_id,
        vsid.visitDate AS visit_ts,
        TO_DATE(vsid.visitDate) as visit_date,
        vsid.visitTracking_id AS visit_tracking_id,
        vbai.cartAddDate AS cart_add_ts,
        TO_DATE(vbai.cartAddDate) as cart_add_date,
        vba.order_id,
        vbai.adjustedPrice AS adjusted_price,
        vbai.pf_id,
        vbai.qty AS cart_qty   
    FROM godaddywebsitetraffic.visitshopperid_snap  vsid
    JOIN godaddywebsitetraffic.visittracking_snap  vt
    ON vsid.visitTracking_id = vt.visitTracking_id
    JOIN godaddywebsitetraffic.visitbasketabandoned_snap  vba
    ON vsid.visitTracking_id = vba.visitTracking_id 
    JOIN godaddywebsitetraffic.visitbasketabandoneditem_snap  vbai
    ON vbai.visitBasketAbandoned_id = vba.visitBasketAbandoned_id
    WHERE vsid.visitDate >= DATE_SUB(FROM_UNIXTIME(UNIX_TIMESTAMP()), 3)
        AND vt.visitDate >= DATE_SUB(FROM_UNIXTIME(UNIX_TIMESTAMP()), 3)
        AND vt.visitTracking_id > 0    
        AND vsid.shopperID IS NOT NULL      ---- ShopperID is populated ----    
        AND vsid.shopperID <> ''            ---- ShopperID is populated ----  
        AND vt.isInternalTraffic <> 1       ---- Not a cart created by C3 ----    
        AND vbai.cartAddDate >= DATE_SUB(FROM_UNIXTIME(UNIX_TIMESTAMP()), 3)  
        AND vba.order_id NOT LIKE '%R'      ---- Order was not refunded ----
        ;

