ALTER TABLE ACTUATORS
ADD COLUMN END_TIMESTAMP DATETIME NULL AFTER START_TIMESTAMP,
CHANGE COLUMN TIMESTAMP START_TIMESTAMP DATETIME NOT NULL ;
