create tablespace  tbs_base datafile '/u02/oradata/center/base/base01.dbf' size 128M autoextend on next 32M maxsize unlimited;
create tablespace  tbs_base_idx datafile '/u02/oradata/center/base/base_idx01.dbf' size 128M autoextend on next 32M maxsize unlimited;

CREATE USER base PROFILE "DEFAULT" IDENTIFIED BY zdsoft 
DEFAULT TABLESPACE tbs_base TEMPORARY TABLESPACE temp ACCOUNT UNLOCK;

GRANT CREATE SESSION,CREATE TABLE,CONNECT,RESOURCE TO base;