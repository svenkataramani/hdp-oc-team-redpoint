#!/bin/sh

kinit -R -k -t /home/hdp_oc_team/kerberos/hdp_oc_team.keytab hdp_oc_team@DC1.CORP.GD
hive -f /home/hdp_oc_team/RedPoint/shopper.hql;
hive -f /home/hdp_oc_team/RedPoint/customer_shopper.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_suppression.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_contact_preference.hql;
hive -f /home/hdp_oc_team/RedPoint/customer_shopper_contact_preference.hql;
hive -f /home/hdp_oc_team/RedPoint/product_ownership.hql;
hive -f /home/hdp_oc_team/RedPoint/support_market_group_a.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_spend.hql;
hive -f /home/hdp_oc_team/RedPoint/customer_shopper_spend.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_outbound_calls.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_inbound_calls.hql;
hive -f /home/hdp_oc_team/RedPoint/shopper_failed_billing.hql;
hive -f /home/hdp_oc_team/RedPoint/abandoned_cart.hql;
hive -f /home/hdp_oc_team/RedPoint/prod_events_rp.hql;
hive -f /home/hdp_oc_team/RedPoint/pldata.hql;
hive -f /home/hdp_oc_team/RedPoint/pldata_group_a.hql;
hive -f /home/hdp_oc_team/RedPoint/pldata_group_b.hql;
hive -f /home/hdp_oc_team/RedPoint/pl_entity_snap.hql;
hive -f /home/hdp_oc_team/RedPoint/marketing_pub_email_optin.hql;
hive -f /home/hdp_oc_team/RedPoint/gdshop_marketing_contact.hql;