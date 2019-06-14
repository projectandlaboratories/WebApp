-- per poter funzionare bisogna creare un profilo di nome cs

insert into air_cond(ID_AIR_COND,MODEL_NAME) values(1,'name1');

insert into rooms(ID_ROOM, ROOM_NAME, ID_AIR_COND, CONN_STATE, ID_PROFILE_WINTER, ID_PROFILE_SUMMER, TMODE, MANUAL_TEMP, MANUAL_SYSTEM)
values('id1','room1',1,true,'cs','cs',null,0,0);