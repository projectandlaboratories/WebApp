package it.project.enums;

public enum Topics {
	MODE("Mode"),
	TEMPERATURE("Temperature"),
	ACTUATOR_STATUS("Acutator-status");
	
	String name;
	
	Topics(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
}
