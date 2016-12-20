Use mktgplatformdb;



CREATE EXTERNAL TABLE mktgplatformdb.shopper_contact_preference (
     shopper_id                      string
    ,marketing_mail_flag             boolean
    ,marketing_email_Flg             boolean
    ,marketing_call_flag             boolean
    ,marketing_sms_flag              boolean
    ,marketing_nonpromo_email_flag   boolean
    ,email_format_pref_ind           int
    ,do_not_contact_flag             boolean    -- **Do we need this column?? remove from one of the tables
    ,preferred_currency_code         string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/shopper_contact_preference'
;   