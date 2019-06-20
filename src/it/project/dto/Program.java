package it.project.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import it.project.enums.*;

public class Program implements Serializable{
	private String name;
	private Map<DayName,DayType> days;
	private Map<DayType, List<Interval>> intervals;
	
	//attributi usati durante creazione e update del programma
	private String wakeupTimeW;
	private String bedTimeW;	
	private String leaveTime;	
	private String backTime;
	private String wakeupTimeH;
	private String bedTimeH;
	private Map<DayMoment,Integer> temperatureMap;
	
		
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
	
	public void setDay(DayName dayName, DayType dayType) {
		this.days.put(dayName, dayType);
	}
	
	public Map<DayType, List<Interval>> getIntervals() {
		return intervals;
	}
	public void setIntervals(Map<DayType, List<Interval>> intervals) {
		this.intervals = intervals;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public void setWorkingHours(String wakeupTimeW, String bedTimeW, String leaveTime, String backTime) {
		this.wakeupTimeW=wakeupTimeW;
		this.bedTimeW=bedTimeW;
		this.leaveTime=leaveTime;
		this.backTime=backTime;
	}
	
	public void setHolidaysHours(String wakeupTimeH, String bedTimeH) {
		this.wakeupTimeH=wakeupTimeH;
		this.bedTimeH=bedTimeH;
	}

	public String getWakeupTimeW() {
		return wakeupTimeW;
	}



	public void setWakeupTimeW(String wakeupTimeW) {
		this.wakeupTimeW = wakeupTimeW;
	}



	public String getBedTimeW() {
		return bedTimeW;
	}



	public void setBedTimeW(String bedTimeW) {
		this.bedTimeW = bedTimeW;
	}



	public String getLeaveTime() {
		return leaveTime;
	}



	public void setLeaveTime(String leaveTime) {
		this.leaveTime = leaveTime;
	}



	public String getBackTime() {
		return backTime;
	}



	public void setBackTime(String backTime) {
		this.backTime = backTime;
	}



	public String getWakeupTimeH() {
		return wakeupTimeH;
	}



	public void setWakeupTimeH(String wakeupTimeH) {
		this.wakeupTimeH = wakeupTimeH;
	}



	public String getBedTimeH() {
		return bedTimeH;
	}



	public void setBedTimeH(String bedTimeH) {
		this.bedTimeH = bedTimeH;
	}
	
	public Map<DayMoment, Integer> getTemperatureMap() {
		return temperatureMap;
	}

	public void setTemperatureMap(Map<DayMoment, Integer> temperatureMap) {
		this.temperatureMap = temperatureMap;
	}
	
	public Map<DayType, List<Interval>> generateIntervalMap(float outTemperature, float homeTemperature, float nightTemperature){
		List<Interval> workingIntervals=generateWorkingInterval(outTemperature, homeTemperature, nightTemperature);
		this.intervals.put(DayType.WORKING, workingIntervals);
		
		List<Interval> holidaysIntervals=generateHolidayInterval(homeTemperature, nightTemperature);
		this.intervals.put(DayType.HOLIDAY, holidaysIntervals);
			
		return this.intervals;		
	}
	
	private List<Interval> generateWorkingInterval(float outTemperature, float homeTemperature, float nightTemperature){
		
		List<Interval> intervals= new ArrayList<>();
		
		String[] wakeupTimeSplit=wakeupTimeW.split(":");
		String[] bedTimeSplit=bedTimeW.split(":");
		String[] leaveTimeSplit=leaveTime.split(":");
		String[] backTimeSplit=backTime.split(":");
		
		String nightStart="00:00";
		String homeEnd=bedTimeW;


		if(bedTimeW.compareTo(wakeupTimeW)<0){ //bed_time oltre la mezzanotte
			nightStart=bedTimeW;
			homeEnd="23:59";
		}

		String[] nightStartSplit=nightStart.split(":");
		String[] homeEndSplit=homeEnd.split(":");
		
		Interval i1= new Interval(Integer.parseInt(nightStartSplit[0]),
				Integer.parseInt(nightStartSplit[1]),
				Integer.parseInt(wakeupTimeSplit[0]),
				Integer.parseInt(wakeupTimeSplit[1]),
				(float) nightTemperature,
				DayMoment.NIGHT
				);
		intervals.add(i1);
		
		Interval i2= new Interval(Integer.parseInt(wakeupTimeSplit[0]),
				Integer.parseInt(wakeupTimeSplit[1]),
				Integer.parseInt(leaveTimeSplit[0]),
				Integer.parseInt(leaveTimeSplit[1]),
				(float) homeTemperature,
				DayMoment.HOME
				);
		intervals.add(i2);
		
		Interval i3= new Interval(Integer.parseInt(leaveTimeSplit[0]),
				Integer.parseInt(leaveTimeSplit[1]),
				Integer.parseInt(backTimeSplit[0]),
				Integer.parseInt(backTimeSplit[1]),
				(float) outTemperature,
				DayMoment.OUT
				);
		intervals.add(i3);
		
		Interval i4= new Interval(Integer.parseInt(backTimeSplit[0]),
				Integer.parseInt(backTimeSplit[1]),
				Integer.parseInt(homeEndSplit[0]),
				Integer.parseInt(homeEndSplit[1]),
				(float) homeTemperature,
				DayMoment.HOME
				);
		intervals.add(i4);
		
		Interval i5;
		if(bedTimeW.compareTo(wakeupTimeW)<0){
			i5=new Interval(0,
					0,
					Integer.parseInt(bedTimeSplit[0]),
					Integer.parseInt(bedTimeSplit[1]),
					(float)homeTemperature,
					DayMoment.HOME
					);
		}else{
			i5=new Interval(Integer.parseInt(bedTimeSplit[0]),
					Integer.parseInt(bedTimeSplit[1]),
					23,
					59,
					(float)nightTemperature,
					DayMoment.NIGHT
					);
		}
		intervals.add(i5);
		
		return intervals;
	}
	
	private List<Interval> generateHolidayInterval(float homeTemperature, float nightTemperature){
		
		List<Interval> intervals= new ArrayList<>();
		
		String[] wakeupTimeSplit=wakeupTimeH.split(":");
		String[] bedTimeSplit=bedTimeH.split(":");
		
		
		String nightStart="00:00";
		String homeEnd=bedTimeH;


		if(bedTimeH.compareTo(wakeupTimeH)<0){ //bed_time oltre la mezzanotte
			nightStart=bedTimeH;
			homeEnd="23:59";
		}

		String[] nightStartSplit=nightStart.split(":");
		String[] homeEndSplit=homeEnd.split(":");
		
		Interval i1= new Interval(Integer.parseInt(nightStartSplit[0]),
				Integer.parseInt(nightStartSplit[1]),
				Integer.parseInt(wakeupTimeSplit[0]),
				Integer.parseInt(wakeupTimeSplit[1]),
				(float) nightTemperature,
				DayMoment.NIGHT
				);
		intervals.add(i1);
		
		Interval i2= new Interval(Integer.parseInt(wakeupTimeSplit[0]),
				Integer.parseInt(wakeupTimeSplit[1]),
				Integer.parseInt(homeEndSplit[0]),
				Integer.parseInt(homeEndSplit[1]),
				(float) homeTemperature,
				DayMoment.HOME
				);
		intervals.add(i2);
		
		Interval i3;
		if(bedTimeH.compareTo(wakeupTimeH)<0){
			i3=new Interval(0,
					0,
					Integer.parseInt(bedTimeSplit[0]),
					Integer.parseInt(bedTimeSplit[1]),
					(float)homeTemperature,
					DayMoment.HOME
					);
		}else{
			i3=new Interval(Integer.parseInt(bedTimeSplit[0]),
					Integer.parseInt(bedTimeSplit[1]),
					23,
					59,
					(float)nightTemperature,
					DayMoment.NIGHT
					);
		}
		intervals.add(i3);
		return intervals;
	}
	
	
	public Map<Object,Object> toMap(){
		Map<Object,Object> map = new HashMap<>();
		map.put("name", name);
		map.put("days", days);
		map.put("intervals", intervals);
		return map;
	}
	
}
