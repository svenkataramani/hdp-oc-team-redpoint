Use mktgplatformdb; 
     
CREATE EXTERNAL TABLE mktgplatformdb.gdshop_mktg_publication_emailoptin
(     
gdshop_mktg_publication_emailoptin_id   bigint,
gds_marketing_contact_id                int,
gds_marketing_pub                       int,
private_label_id                        int,
opt_in_ts                             timestamp,
opt_out_ts                            timestamp,
confirmed_flag                          boolean,
from_app                                string,
from_ip_address                         string,
entity_id                               int,
catalog_country_site                    string,
catalog_market_id                       string,
vistor_guid                             string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/gdshop_mktg_publication_emailoptin'
;
