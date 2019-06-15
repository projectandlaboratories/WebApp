DROP TABLE actuators;

CREATE TABLE IF NOT EXISTS actuators (
  ID_ROOM VARCHAR(30) NOT NULL,
  TIMESTAMP DATETIME NOT NULL,
  STATE VARCHAR(10) NOT NULL,
  PRIMARY KEY (ID_ROOM,TIMESTAMP),
  FOREIGN KEY (ID_ROOM) REFERENCES rooms (ID_ROOM));
  

-- alcune tuple di prova
  
insert into weekend_mode(ID,WMODE,START_TIME,END_TIME)
values(2,TRUE,now(),'2019-06-20 19:00:00');


insert into actuators(ID_ROOM,TIMESTAMP,STATE)
values("id1",now(),'HOT');