package it.project.dto;

import java.io.Serializable;

import it.project.enums.DayMoment;
import it.project.utils.ProfileUtil;

public class Interval implements Comparable<Object>, Serializable{
	private int startHour;
	private int startMin;
	private int endHour;
	private int endMin;
	private double temperature;
	private DayMoment dayMoment;
	
	public Interval() {
		super();
	}
	
	public Interval(int startHour, int startMin, int endHour, int endMin, double temperature, DayMoment dayMoment) {
		super();
		this.startHour = startHour;
		this.startMin = startMin;
		this.endHour = endHour;
		this.endMin = endMin;
		this.temperature = temperature;
		this.dayMoment = dayMoment;
	}
	public int getStartHour() {
		return startHour;
	}
	public void setStartHour(int startHour) {
		this.startHour = startHour;
	}
	public int getStartMin() {
		return startMin;
	}
	public void setStartMin(int startMin) {
		this.startMin = startMin;
	}
	public int getEndHour() {
		return endHour;
	}
	public void setEndHour(int endHour) {
		this.endHour = endHour;
	}
	public int getEndMin() {
		return endMin;
	}
	public void setEndMin(int endMin) {
		this.endMin = endMin;
	}
	public double getTemperature() {
		return temperature;
	}
	public int getIntTemperature() {
		return (int)temperature;
	}
	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}
	public DayMoment getDayMoment() {
		return dayMoment;
	}
	public void setDayMoment(DayMoment dayMoment) {
		this.dayMoment = dayMoment;
	}
	@Override 
    public int compareTo(Object o) {
        Interval other = (Interval) o; 
        return (this.startHour*60+this.startMin) - (other.startHour*60+other.startMin) ;
    }
	
	@Override 
	public boolean equals(Object obj) {
		Interval other = (Interval) obj; 
		return (this.startHour==other.startHour && this.startMin==other.startMin);  
	}
	
	public float getPercentageOfDay() {
		return ((float)((endHour*60+endMin)-(startHour*60+startMin)))/(24*60)*100;
	}
	public String getColor() {
		return ProfileUtil.getDayMomentColors().get(this.dayMoment);
	}
}
