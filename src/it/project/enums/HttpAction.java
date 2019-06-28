package it.project.enums;

public enum HttpAction {
	AUTH("/auth"),
	GROUP("/user/PL19-20"),
	DEVICE("/user/PL19-20/devices"),
	LOG("/user/PL19-20/logs");
	
	String name;
	
	HttpAction(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
}
