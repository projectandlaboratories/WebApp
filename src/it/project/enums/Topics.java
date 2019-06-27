package it.project.enums;

import it.project.utils.DbIdentifiers;

public enum Topics {
	MODE("Mode"),
	TEMPERATURE("Temperature"),
	ACTUATOR_STATUS("Acutator-status"),
	PROFILE_CHANGE("ProfileChange"),
	ANTIFREEZE("Antifreeze"),
	MQTT_APP_SENSORI("MqttAppSensori"),
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
}
