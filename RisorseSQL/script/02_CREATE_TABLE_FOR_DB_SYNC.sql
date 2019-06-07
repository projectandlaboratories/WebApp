create table query_to_do(ts TIMESTAMP, query VARCHAR(5000),
primary key(ts));

create table system_config(config_key VARCHAR(500), value VARCHAR(1000), PRIMARY KEY(config_key));

insert into system_config(config_key,value) values('db.sync.ismodified','false');
insert into system_config(config_key,value) values('db.sync.lastTimestamp',sysDate());

commit;