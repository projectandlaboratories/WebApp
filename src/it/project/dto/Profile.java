package it.project.dto;

import java.io.Serializable;

import it.project.enums.DayName;
import it.project.enums.DayType;

public class Profile implements Serializable {
	
	private String idProfile;
	private DayName dayOfWeek;
	private DayType dayType;
	private Interval interval;
	
	
	public Profile() {
		super();
	}
	
	


	public Profile(String idProfile, DayName dayOfWeek, DayType dayType, Interval interval) {
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


	public DayName getDayOfWeek() {
		return dayOfWeek;
	}


	public void setDayOfWeek(DayName dayOfWeek) {
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
