package it.project.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import it.project.db.DBClass;
import it.project.db.MQTTDbSync;
import it.project.dto.Interval;
import it.project.dto.Profile;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.DayMoment;
import it.project.enums.DayName;
import it.project.enums.DayType;
import it.project.enums.Season;
import it.project.mqtt.MQTTAppSensori;
import it.project.socket.SocketClient;

public class ProfileUtil {

	public static Program getProgramFromProfile(List<Profile> profiles) {
		
		Map<DayName,DayType> days = new HashMap<>();
		Map<DayType, List<Interval>> intervals  = new HashMap<>();
		
		for(Profile profile : profiles) {
			if(!days.containsKey(profile.getDayOfWeek()))
				days.put(profile.getDayOfWeek(), profile.getDayType());
			
			if(intervals.containsKey(profile.getDayType())) {
				if(!intervals.get(profile.getDayType()).contains(profile.getInterval()))
					intervals.get(profile.getDayType()).add(profile.getInterval());
			}
			else {
				List<Interval> programIntervalList = new ArrayList<>();
				programIntervalList.add(profile.getInterval());
				intervals.put(profile.getDayType(), programIntervalList);
			}
		}
		
		Program program = new Program(days,intervals);
		program.setName(profiles.get(0).getIdProfile());
		
		return program;
	}
	
	public static Map<String,List<Profile>> groupProfilesById(List<Profile> profiles) {
		Map<String,List<Profile>> profileMap = new HashMap<>();
		for(Profile profile : profiles) {
			if(profileMap.containsKey(profile.getIdProfile())) {
				profileMap.get(profile.getIdProfile()).add(profile);
			}
			else {
				List<Profile> programProfiles = new ArrayList<>();
				programProfiles.add(profile);
				profileMap.put(profile.getIdProfile(), programProfiles);
			}
		}
		
		return profileMap;
		
	}
	
	public static Profile getProfile(ResultSet result) throws SQLException {
		String idProfile = result.getString("ID_PROFILE");
		DayName dayOfWeek = DayName.valueOf(result.getString("DAY_OF_WEEK"));
		DayType dayType = DayType.valueOf(result.getString("DAY_TYPE"));
		DayMoment dayMoment = DayMoment.valueOf(result.getString("DAY_MOMENT"));
		int startHour = result.getInt("START_HOUR");
		int startMin = result.getInt("START_MIN");
		int endHour = result.getInt("END_HOUR");
		int endMin = result.getInt("END_MIN");
		double temperature = result.getDouble("TEMPERATURE");
		
		Interval interval = new Interval(startHour,startMin,endHour,endMin,temperature,dayMoment);
		Profile profile = new Profile(idProfile,dayOfWeek,dayType,interval);
		
		return profile;
		
	}
	
	public static Map<DayMoment, String> getDayMomentColors() {
		Map<DayMoment, String> colors = new HashMap<DayMoment, String>();
		colors.put(DayMoment.NIGHT, "#2C3E50");
		colors.put(DayMoment.HOME, "#f2a654");
		colors.put(DayMoment.OUT, "#f96868");
		return colors;
	}
	
	public static Map<DayName,String> getDefaultDays(){
		Map<DayName,String> checked = new HashMap<>();
		checked.put(DayName.MON, "");
		checked.put(DayName.TUE, "");
		checked.put(DayName.WED, "");
		checked.put(DayName.THU, "");
		checked.put(DayName.FRI, "");
		checked.put(DayName.SAT, "checked");
		checked.put(DayName.SUN, "checked");
		return checked;
	}
	
	public static  Map<DayMoment, Integer> getDefaultTemperatures(){
		Map<DayMoment, Integer> temperature = new HashMap<>();
		temperature.put(DayMoment.NIGHT,20);
		temperature.put(DayMoment.HOME,20);
		temperature.put(DayMoment.OUT,20);
		return temperature;
	}
	
	public static String getTimeString(int h, int m) {
		String hour = Integer.toString(h);
		String min = Integer.toString(m);
		if(h<=9){
			hour=new String("0"+hour);
		}
		if(m<=9){
			min=new String("0"+min);
		}
		return new String(hour+":"+min);	
	}
	
	public static Season getCurrentSeason() {
		Date today = new Date(); 
		Calendar cal = Calendar.getInstance();
		cal.setTime(today); 
		int month=cal.get(Calendar.MONTH);
		
		if(month<3 ||month>9){		
			return Season.WINTER;
		}else{		
			return Season.SUMMER;
		}
	}
	
	public static String getCurrentTemperature(Room currentRoom) {
		String temperature = "0";
		Program program;
		Date today = new Date(); 
		Calendar cal = Calendar.getInstance();
		cal.setTime(today); 
		int month=cal.get(Calendar.MONTH);
		
		if(month<3 ||month>9){		
			program=currentRoom.getWinterProfile();
		}else{		
			program=currentRoom.getSummerProfile();
		}

		int dayIndex=(cal.get(Calendar.DAY_OF_WEEK)+7-2)%7;
		DayName day=DayName.values()[dayIndex];
		DayType dayType = program.getDays().get(day);
		int now = (cal.get(Calendar.HOUR_OF_DAY))*60 + cal.get(Calendar.MINUTE);
		
		for(Interval interval:program.getIntervals().get(dayType)){
			if(interval.getStartHour()*60+interval.getStartMin() <= now && interval.getEndHour()*60+interval.getEndMin() > now){
				temperature = Double.toString(interval.getTemperature());
				break;
			}
		}
		return temperature;
	}
	
	public static String reconnectToWifi(ServletContext context,String connectedSsid,String ssid) throws Exception {
		int count=0;
		while(connectedSsid.equals("") && count < 3){
			count++;
			Process reconnect= new ProcessBuilder("/bin/bash",context.getRealPath("/bash/reconnect.sh")).redirectErrorStream(true).start();
			BufferedReader input = new BufferedReader(new InputStreamReader(reconnect.getInputStream()));
			String line = "";
			while ((line = input.readLine()) != null) {
				connectedSsid = line;
				String[] outputSplitted = line.split(":");
				if(outputSplitted.length > 1){
					connectedSsid = line.split(":")[1];
					connectedSsid = connectedSsid.replace("\"", "");	
				}	
			}
			System.out.println(new Date().getTime() + " -(count=" + count + ") Try to reconnect to Wifi SSID= " + ssid + ", output = " + connectedSsid);
			
			input.close();
		}
		
		return connectedSsid;
	}
	
	public static void connectToRoom(ServletContext context, String roomId, int airCondModelId, String ssid, String espPassword) throws Exception {
		//connect to ESP AP
		Process connectEspAP= new ProcessBuilder("/bin/bash",context.getRealPath("/bash/connect_wifi.sh"),ssid,espPassword).redirectErrorStream(true).start();
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(connectEspAP.getInputStream()));
		String connectedSsid = "";
		while ((line = input.readLine()) != null) {
			System.out.println("Connection to Wifi Line= " + line);
			connectedSsid = line;
			String[] outputSplitted = line.split(":");
		}
		System.out.println(new Date().toString() + "- Connection to Wifi SSID= " + ssid + " password = " + espPassword + ", output = " + line);
		
		
		//TRY TO RECONNECT
		connectedSsid = reconnectToWifi(context,connectedSsid,ssid);
				
		//get ESP IP
		Process getAPipAddress = new ProcessBuilder("/bin/bash",context.getRealPath("/bash/getAPipAddress.sh")).redirectErrorStream(true).start();
		//String line;
		input = new BufferedReader(new InputStreamReader(getAPipAddress.getInputStream()));
		String ESPipAddress = "";
		while ((line = input.readLine()) != null) {
			ESPipAddress = line.split(" ")[2];
		}
		System.out.println("ESP IP address is " + ESPipAddress);

		//send Wifi Info to ESP
		String socketResult = SocketClient.createConnection(ESPipAddress, 5001);
		String localWifiSSid = DBClass.getConfigValue("localWifiSSid");
		String localWifiPwd = DBClass.getConfigValue("localWifiPwd");
		if(socketResult.equals("OK"))
			SocketClient.sendWifiInfo(localWifiSSid, localWifiPwd);
		//SocketClient.closeConnection();


		//connect to local Wifi
		Process connectLocalWifi= new ProcessBuilder("/bin/bash",context.getRealPath("/bash/connect_wifi.sh"),localWifiSSid,localWifiPwd).redirectErrorStream(true).start();
		input = new BufferedReader(new InputStreamReader(connectLocalWifi.getInputStream()));
		connectedSsid = "";
		while ((line = input.readLine()) != null) {
			System.out.println(new Date().toString() + "- Connection to Wifi SSID= " + localWifiSSid + " password = " + localWifiPwd + ", output = " + line);
			String[] outputSplitted = line.split(":");		
		}
		
		
		
		//get broker IP
		Process getBrokerIPAddress = new ProcessBuilder("/bin/bash",context.getRealPath("/bash/getBrokerIpAddress.sh")).redirectErrorStream(true).start();
		input = new BufferedReader(new InputStreamReader(getBrokerIPAddress.getInputStream()));
		String brokerIpAddress = "";
		while ((line = input.readLine()) != null) {
			brokerIpAddress = line;
		}

		//send roomInfo to ESP via MQTT with online broker
		MQTTDbSync.sendNewRoomInfo(roomId, airCondModelId, brokerIpAddress);
	}
}
