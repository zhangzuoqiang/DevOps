conn / as sysdba;

alter system set job_queue_processes=10;


create tablespace  tbs_deploy datafile '/u02/oradata/center/deploy/deploy01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create user deploy identified by zdsoft default tablespace tbs_deploy;
grant connect,resource,create table,create view,execute any procedure to deploy;
/


----passport----
CREATE SMALLFILE TABLESPACE tbs_passport DATAFILE 
'/u02/oradata/center/passport/passport_data01.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M,
'/u02/oradata/center/passport/passport_data02.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M,
'/u02/oradata/center/passport/passport_data03.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M
LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
CREATE TABLESPACE tbs_passport_idx DATAFILE 
'/u02/oradata/center/passport/passport_idx01.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M,
'/u02/oradata/center/passport/passport_idx02.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M,
'/u02/oradata/center/passport/passport_idx03.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M;
CREATE USER passport PROFILE "DEFAULT" IDENTIFIED BY zdsoft DEFAULT
TABLESPACE tbs_passport TEMPORARY TABLESPACE temp ACCOUNT UNLOCK;
GRANT CREATE SESSION,CREATE TABLE,CONNECT,RESOURCE TO passport;
-----


--office 
create tablespace  tbs_office datafile '/u02/oradata/center/office/office01.dbf' size 10M autoextend on next 5M maxsize unlimited;
create user office identified by zdsoft default tablespace tbs_office;
grant connect,resource,create table,create view,execute any procedure,create synonym to office;
/



conn / as sysdba;


create tablespace  tbs_eis datafile '/u02/oradata/center/eis/eis01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_idx datafile '/u02/oradata/center/eis/eis_idx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_base datafile '/u02/oradata/center/eis/eis_base01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_base_idx datafile '/u02/oradata/center/eis/eis_baseidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_arch datafile '/u02/oradata/center/eis/eis_arch01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_arch_idx datafile '/u02/oradata/center/eis/eis_archidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_courseform datafile '/u02/oradata/center/eis/eis_courseform01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_courseform_idx datafile '/u02/oradata/center/eis/eis_courseformidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_diathesis datafile '/u02/oradata/center/eis/eis_diathesis01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_diathesis_idx datafile '/u02/oradata/center/eis/eis_diathesisidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_exam datafile '/u02/oradata/center/eis/eis_exam01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_exam_idx datafile '/u02/oradata/center/eis/eis_examidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_personnel datafile '/u02/oradata/center/eis/eis_personnel01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_personnel_idx datafile '/u02/oradata/center/eis/eis_personnelidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_postion datafile '/u02/oradata/center/eis/eis_postion01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_postion_idx datafile '/u02/oradata/center/eis/eis_postionidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_schres datafile '/u02/oradata/center/eis/eis_schres01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_schres_idx datafile '/u02/oradata/center/eis/eis_schresidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_student datafile '/u02/oradata/center/eis/eis_student01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_student_idx datafile '/u02/oradata/center/eis/eis_studentidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_sys datafile '/u02/oradata/center/eis/eis_sys.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_sys_idx datafile '/u02/oradata/center/eis/eis_sysidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_party datafile '/u02/oradata/center/eis/eis_party01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_party_idx datafile '/u02/oradata/center/eis/eis_partyidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_group datafile '/u02/oradata/center/eis/eis_group01.dbf' size 50M autoextend on next 20M maxsize unlimited;
create tablespace  tbs_eis_group_idx datafile '/u02/oradata/center/eis/eis_groupidx01.dbf' size 50M autoextend on next 20M maxsize unlimited;

create tablespace  tbs_eis_project datafile '/u02/oradata/center/eis/eis_project01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_project_idx datafile '/u02/oradata/center/eis/eis_projectidx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_studoc datafile '/u02/oradata/center/eis/eis_studoc01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_studoc_idx datafile '/u02/oradata/center/eis/eis_studocidx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_dossier datafile '/u02/oradata/center/eis/eis_dossier01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_dossier_idx datafile '/u02/oradata/center/eis/eis_dossieridx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_juniorenroll datafile '/u02/oradata/center/eis/eis_juniorenroll01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_juniorenroll_idx datafile '/u02/oradata/center/eis/eis_juniorenrollidx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_datadeclare datafile '/u02/oradata/center/eis/eis_datadeclare01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_datadeclare_idx datafile '/u02/oradata/center/eis/eis_datadeclareidx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_primaryenroll datafile '/u02/oradata/center/eis/eis_primaryenroll01.dbf' size 20M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_primaryenroll_idx datafile '/u02/oradata/center/eis/eis_primaryenrollidx01.dbf' size 20M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_recruit datafile '/u02/oradata/center/eis/eis_recruit01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_recruit_idx datafile '/u02/oradata/center/eis/eis_recruitidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_stat datafile '/u02/oradata/center/eis/eis_stat01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_stat_idx datafile '/u02/oradata/center/eis/eis_statidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_kgsys datafile '/u02/oradata/center/eis/eis_kgsys01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_kgsys_idx datafile '/u02/oradata/center/eis/eis_kgsysidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;


create tablespace  tbs_eis_achi datafile '/u02/oradata/center/eis/eis_achi01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_achi_idx datafile '/u02/oradata/center/eis/eis_achiidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_achistat datafile '/u02/oradata/center/eis/eis_achistat01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_achistat_idx datafile '/u02/oradata/center/eis/eis_achistatidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;
/

create tablespace  tbs_eis_crecog datafile '/u02/oradata/center/eis/eis_crecog01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_crecog_idx datafile '/u02/oradata/center/eis/eis_crecogidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_creass datafile '/u02/oradata/center/eis/eis_creass01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_creass_idx datafile '/u02/oradata/center/eis/eis_creassidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_gzachi datafile '/u02/oradata/center/eis/eis_gzachi01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_gzachi_idx datafile '/u02/oradata/center/eis/eis_gzachiidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_gzachi_stat datafile '/u02/oradata/center/eis/eis_gzachi_stat01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_gzachi_stat_idx datafile '/u02/oradata/center/eis/eis_gzachi_statidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_gzstat datafile '/u02/oradata/center/eis/eis_gzstat01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_gzstat_idx datafile '/u02/oradata/center/eis/eis_gzstatidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;
/


create tablespace  tbs_eis_deeach datafile '/u02/oradata/center/eis/eis_deeach01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_deeach_idx datafile '/u02/oradata/center/eis/eis_deeachidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;

create tablespace  tbs_eis_deresult datafile '/u02/oradata/center/eis/eis_deresult01.dbf' size 10M autoextend on next 10M maxsize unlimited;
create tablespace  tbs_eis_deresult_idx datafile '/u02/oradata/center/eis/eis_deresultidx01.dbf' size 10M autoextend on next 10M maxsize unlimited;
/

create user eis identified by zdsoft default tablespace tbs_eis;
grant connect,resource,create table,create view,execute any procedure,create synonym to eis;
/


CREATE SMALLFILE TABLESPACE tbs_netdisk DATAFILE 
'/u02/oradata/center/netdisk/netdisk01.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 10240M
LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;   

create user netdisk identified by zdsoft default tablespace tbs_netdisk;
grant connect,resource,create table,create view,execute any procedure,create synonym to netdisk;

