package it.project.dto;

import it.project.enums.DayType;

public class Profile {
	
	private String idProfile;
	private int dayOfWeek;
	private DayType dayType;
	private Interval interval;
	
	
	public Profile() {
		super();
	}
	
	
	public Profile(String idProfile, int dayOfWeek, DayType dayType, Interval interval) {
		super();
		this.idProfile = idProfile;
		this.dayOfWeek = dayOfWeek;
		this.dayType = dayType;
		this.interval = interval;
	}
	public String getIdProfile() {
		return idProfile;
	}
	public void setIdProfile(String idProfile) {
		this.idProfile = idProfile;
	}
	public int getDayOfWeek() {
		return dayOfWeek;
	}
	public void setDayOfWeek(int dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}
	public DayType getDayType() {
		return dayType;
	}
	public void setDayType(DayType dayType) {
		this.dayType = dayType;
	}
	public Interval getInterval() {
		return interval;
	}
	public void setInterval(Interval interval) {
		this.interval = interval;
	}
	
	

}
