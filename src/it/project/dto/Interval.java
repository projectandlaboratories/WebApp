package it.project.dto;

import it.project.enums.DayMoment;

public class Interval {
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
	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}
	public DayMoment getDayMoment() {
		return dayMoment;
	}
	public void setDayMoment(DayMoment dayMoment) {
		this.dayMoment = dayMoment;
	}
	
}
