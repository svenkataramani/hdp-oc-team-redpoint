Use mktgplatformdb;



CREATE EXTERNAL TABLE mktgplatformdb.afn_state_codes (
state_code_id           int,
state_name              string,
state_code              string,
clean_state_name        string
)
    Stored as ORC
LOCATION '/teams/mktgplatformdb/afn_state_codes'
;