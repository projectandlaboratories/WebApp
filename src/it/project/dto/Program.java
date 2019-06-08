package it.project.dto;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import it.project.enums.DayName;
import it.project.enums.DayType;

public class Program {
	
	private Map<DayName,DayType> days;
	private Map<DayType, List<Interval>> intervals;
	
	public Program() {
		super();
		days=new HashMap<>();
		intervals = new HashMap<>();
	}
	
	public Program(Map<DayName, DayType> days, Map<DayType, List<Interval>> intervals) {
		super();
		this.days = days;
		this.intervals = intervals;
	}
	
	public Map<DayName, DayType> getDays() {
		return days;
	}
	public void setDays(Map<DayName, DayType> days) {
		this.days = days;
	}
	public Map<DayType, List<Interval>> getIntervals() {
		return intervals;
	}
	public void setIntervals(Map<DayType, List<Interval>> intervals) {
		this.intervals = intervals;
	}
	
	
	

}
