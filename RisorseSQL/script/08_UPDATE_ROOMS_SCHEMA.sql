drop table temperatures;
drop table rooms;



CREATE TABLE IF NOT EXISTS rooms (
  ID_ROOM VARCHAR(17) NOT NULL,
  ROOM_NAME VARCHAR(30) NOT NULL,
  ID_AIR_COND INT,
  CONN_STATE BOOLEAN,
  ID_PROFILE_WINTER VARCHAR(30),
  ID_PROFILE_SUMMER VARCHAR(30),
  MODE VARCHAR(30),
  MANUAL_TEMP INT,
  MANUAL_SYSTEM VARCHAR(5),
  PRIMARY KEY (ID_ROOM),
  FOREIGN KEY (ID_PROFILE_WINTER) REFERENCES profiles (ID_PROFILE),
  FOREIGN KEY (ID_PROFILE_SUMMER) REFERENCES profiles (ID_PROFILE),
  FOREIGN KEY (ID_AIR_COND) REFERENCES air_cond (ID_AIR_COND));
  
  
  CREATE TABLE IF NOT EXISTS temperatures (
  ID_ROOM VARCHAR(30) NOT NULL,
  TIMESTAMP DATETIME NOT NULL,
  TEMPERATURE DOUBLE NOT NULL,
  PRIMARY KEY (ID_ROOM,TIMESTAMP),
  FOREIGN KEY (ID_ROOM) REFERENCES rooms (ID_ROOM));