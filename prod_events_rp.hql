SET hive.support.concurrency=FALSE;
SET hive.cli.print.current.db=TRUE;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;
SET hive.groupby.orderby.position.alias=TRUE;

use mktgplatformdb;

--Create Temp Tables
DROP TABLE IF EXISTS dcr_wsb;
CREATE TEMPORARY TABLE dcr_wsb AS

select dcr.shopper_id, er.resource_id, case when dcr.e_id = 'pandc.wsb.v7.publish' then 'Publish' else 'Activate' end as event_action, 'WSB' as prod_type, max(e_time) as event_date
  from dm_ecommerce.fact_billing_external_resource er
  join 
  (select * from dm_customer_interaction.dm_user_events dcr
   where e_id in('pandc.wsb.v7.theme.select','pandc.wsb.v7.publish')
   
   AND dcr.year   = year(TO_DATE('${hiveconf:startdate}'))
   AND dcr.month  = month(TO_DATE('${hiveconf:startdate}'))
   AND dcr.day =    day(TO_DATE('${hiveconf:startdate}'))
             
   ) dcr on er.external_resource_id = dcr.orion_id
   WHERE regexp_extract(dcr.shopper_id,'[a-zA-Z]+', 0) = ''
 group by dcr.shopper_id, er.resource_id, case when dcr.e_id = 'pandc.wsb.v7.publish' then 'Publish' else 'Activate' end, 'WSB'
;

-- ADDED 5/16/16.  ALTERNATE SOURCE FOR OLS EVENTS; TESTING FOR BETTER DATA QUALITY
INSERT OVERWRITE TABLE dcr_ols_stg
select a.shopper_id, o.resource_id, case when m.value = 'ONBOARDING' then 'Acct Activate' else 'Publish' end as event_action, 'OLS' as prod_type, max(m.created_at) as event_date
from 
nemo_ols_common.nemo_core_account_metrics_snap m
inner join
nemo_ols_common.nemo_core_site_accounts_snap a on a.id = m.site_account_id
inner join
dm_ecommerce.fact_billing_external_resource o on a.account_uid = o.external_resource_id
where m.event = 'store_status.change'
and m.value in('ONBOARDING','LIVE')
and a.shopper_id rlike '^[0-9]+$' = TRUE
group by a.shopper_id, o.resource_id, case when m.value = 'ONBOARDING' then 'Acct Activate' else 'Publish' end, 'OLS'
;




DROP TABLE IF EXISTS dcr_sev;
CREATE TEMPORARY TABLE dcr_sev AS
select dcr.shopper_id, er.resource_id, case when dcr.e_id = 'pandc.sev.review.published' then 'Publish' else 'Activate' end as event_action, 'SEV' as prod_type, max(e_time) as event_date
  from dm_ecommerce.fact_billing_external_resource er
  join 
  (select * from dm_customer_interaction.dm_user_events dcr
   where e_id in('pandc.sev.account.create','pandc.sev.review.published')
  
  AND dcr.year   = year(TO_DATE('${hiveconf:startdate}'))
   AND dcr.month  = month(TO_DATE('${hiveconf:startdate}'))
   AND dcr.day =    day(TO_DATE('${hiveconf:startdate}'))
       
   and get_json_object(event_json, '$.product_mode') = 'standalone') dcr 
   on er.external_resource_id = dcr.orion_id
   WHERE regexp_extract(dcr.shopper_id,'[a-zA-Z]+', 0) = ''
 group by dcr.shopper_id, er.resource_id, case when dcr.e_id = 'pandc.sev.review.published' then 'Publish' else 'Activate' end, 'SEV'
;

INSERT OVERWRITE TABLE dcr_mwp_stg
select sr.shopper_id, sr.shopperresourceid as resource_id, 
case when mi.metricid = 459 
then 'Publish' 
else 'Activate' 
end as event_action, 
'MWP' as prod_type, 
max(sequencedategmt) as event_date
FROM productmetricscoring.score_metricinstance_snap mi
JOIN productmetricscoring.score_shopperresource_snap sr ON mi.shopperresourceid = sr.shopperresourceid
where metricid in(459,581)
AND regexp_extract(sr.shopper_id,'[a-zA-Z]+', 0) = ''
group by sr.shopper_id, sr.shopperresourceid, case when mi.metricid = 459 then 'Publish' else 'Activate' end, 'MWP'
union all

Select up.shopperid as shopper_id, br.resource_id, 'ezMode' as event_action, 'MWP' as prod_type, max(to_date(get_json_object(data, '$.datetime'))) as event_date
FROM hosting_wpaas.userprofiles_snap up
JOIN hosting_wpaas.products_snap pr on pr.userid=up.userid
JOIN hosting_wpaas.accounts_snap ac on ac.productid=pr.productid
JOIN hosting_wpaas.pluginaccountdatas_snap pad on pad.accountid=ac.accountid
JOIN godaddybilling.gdshop_billingaccountexternalresource_snap br on ac.accountuid = br.externalresourceid
WHERE LOWER(data) like '%wpem_continue%yes%'
AND regexp_extract(up.shopperid,'[a-zA-Z]+', 0) = ''
group by up.shopperid, br.resource_id, 'ezMode', 'MWP'

union all
select u.shopperid as shopper_id, r.resource_id, 'Migrate' as event_action, 'MWP' as prod_type, min(m.datecreated) as event_date
from
hosting_wpaas.migrations_snap m
inner join
hosting_wpaas.accounts_snap a on m.accountid = a.accountid
inner join
hosting_wpaas.userprofiles_snap u on a.userid = u.userid
inner join
hosting_wpaas.products_snap p on a.productid = p.productid
inner join
dm_ecommerce.fact_billing_external_resource r on p.productuid = r.external_resource_id
where regexp_extract(u.shopperid,'[a-zA-Z]+', 0) = ''
and to_date(m.datecreated)  >= '2014-01-07'
group by u.shopperid, r.resource_id, 'Migrate', 'MWP'
;
-------

DROP TABLE IF EXISTS dcr_gem;
CREATE TEMPORARY TABLE dcr_gem AS
select dcr.shopper_id, er.resource_id, case when dcr.e_id = 'productivity.gem.dashboard.email.send' then 'Gem Send' else 'inactive' end as event_action, 'GEM' as prod_type, max(e_time) as event_date
  from dm_ecommerce.fact_billing_external_resource er
  join 
  (select * from dm_customer_interaction.dm_user_events dcr
   where e_id in('productivity.gem.dashboard.email.send')
   
   AND dcr.year   = year(TO_DATE('${hiveconf:startdate}'))
   AND dcr.month  = month(TO_DATE('${hiveconf:startdate}'))
   AND dcr.day =    day(TO_DATE('${hiveconf:startdate}'))
   
   ) dcr
   on er.external_resource_id = dcr.orion_id
  WHERE regexp_extract(dcr.shopper_id,'[a-zA-Z]+', 0) = '' 
 group by dcr.shopper_id, er.resource_id, case when dcr.e_id = 'productivity.gem.dashboard.email.send' then 'Gem Send' else 'inactive' end, 'GEM'
;

DROP TABLE IF EXISTS dcr_cpnl;
CREATE TEMPORARY TABLE dcr_cpnl AS
select dcr.shopper_id, er.resource_id, case when dcr.e_id = 'hosting.cpanel.api.customer_migration.complete' then 'Migrate' when dcr.e_id = 'hosting.cpanel.account.setup.complete' then 'Setup' else 'Publish' end as event_action, 'cPanel' as prod_type, max(e_time) as event_date
  from dm_ecommerce.fact_billing_external_resource er
  join 
  (select * from dm_customer_interaction.dm_user_events dcr
   where e_id in('hosting.cpanel.api.customer_migration.complete', 'hosting.cpanel.account.setup.complete', 'hosting.cpanel.account.publish')
   
   AND dcr.year   = year(TO_DATE('${hiveconf:startdate}'))
   AND dcr.month  = month(TO_DATE('${hiveconf:startdate}'))
   AND dcr.day =    day(TO_DATE('${hiveconf:startdate}'))
        
   ) dcr
   on er.external_resource_id = dcr.orion_id
  WHERE regexp_extract(dcr.shopper_id,'[a-zA-Z]+', 0) = '' 
 group by dcr.shopper_id, er.resource_id, case when dcr.e_id = 'hosting.cpanel.api.customer_migration.complete' then 'Migrate' when dcr.e_id = 'hosting.cpanel.account.setup.complete' then 'Setup' else 'Publish' end, 'cPanel'
;

DROP TABLE IF EXISTS dcr_union;
CREATE TEMPORARY TABLE dcr_union AS
select dcr_wsb.shopper_id, dcr_wsb.resource_id, dcr_wsb.prod_type, to_date(dcr_wsb.event_date) as event_date, dcr_wsb.event_action
from dcr_wsb
union all
select dcr_ols.shopper_id, dcr_ols.resource_id, dcr_ols.prod_type, to_date(dcr_ols.event_date) as event_date, dcr_ols.event_action
from dcr_ols_stg as dcr_ols
union all
select dcr_mwp.shopper_id, dcr_mwp.resource_id, dcr_mwp.prod_type, to_date(dcr_mwp.event_date) as event_date, dcr_mwp.event_action
from dcr_mwp_stg as dcr_mwp
union all
select dcr_sev.shopper_id, dcr_sev.resource_id, dcr_sev.prod_type, to_date(dcr_sev.event_date) as event_date, dcr_sev.event_action
from dcr_sev
union all
select dcr_gem.shopper_id, dcr_gem.resource_id, dcr_gem.prod_type, to_date(dcr_gem.event_date) as event_date, dcr_gem.event_action
from dcr_gem
union all
select dcr_cpnl.shopper_id, dcr_cpnl.resource_id, dcr_cpnl.prod_type, to_date(dcr_cpnl.event_date) as event_date, dcr_cpnl.event_action
from dcr_cpnl
;

INSERT OVERWRITE table mktgplatformdb.prod_events PARTITION (event_date)
select dcr_union.shopper_id, dcr_union.resource_id, dcr_union.prod_type,  dcr_union.event_action, to_date(dcr_union.event_date) as event_date
from dcr_union
where dcr_union.event_date = '${hiveconf:startdate}'
group by dcr_union.shopper_id, dcr_union.resource_id, dcr_union.prod_type, dcr_union.event_action, dcr_union.event_date

;


