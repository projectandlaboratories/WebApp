package it.project.enums;

import it.project.utils.DbIdentifiers;

public enum Topics {
	MODE("Mode"),
	TEMPERATURE("Temperature"),
	ACTUATOR_STATUS("ActuatorStatus"),
	PROFILE_CHANGE("ProfileChange"),
	ANTIFREEZE("Antifreeze"),
	MQTT_APP_SENSORI("MqttAppSensori"),
	ADD_ROOM("AddRoom"),
	LAST_WILL("LastWill"),
	LOCAL_NEWQUERY_SEND("new_query_for_aws"),
	LOCAL_NEWQUERY_SUBSCRIBE("new_query_for_local"),
	AWS_NEWQUERY_SEND("new_query_for_local"),
	AWS_NEWQUERY_SUBSCRIBE("new_query_for_aws");
	
	String name;
	
	Topics(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
