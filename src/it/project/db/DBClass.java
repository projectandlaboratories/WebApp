package it.project.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import it.project.dto.Interval;
import it.project.dto.Profile;
import it.project.dto.Program;
import it.project.enums.DayMoment;
import it.project.enums.DayName;
import it.project.enums.DayType;
import it.project.utils.DbIdentifiers;
import it.project.utils.ProfileUtil;

public class DBClass {

	private static Connection conn;
	
	
	public DBClass(){
	}
	
	public static Connection getConnection(DbIdentifiers user) throws Exception {
		
		if(conn == null) {
			if(user.equals(DbIdentifiers.AWS)) {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://projectdb.c3mhigfjfwis.eu-west-3.rds.amazonaws.com:3306/projectDb", "db_admin", "projectpwd");
				conn.setAutoCommit(true);
			}
			if(user.equals(DbIdentifiers.LOCAL)) {
				Class.forName("com.mysql.cj.jdbc.Driver");
				//conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/project", "PCSUser", "root"); //Vincenzo
				//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thermostat", "root", "ily2marzo"); //Ilaria
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thermostat?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "ily2marzo"); //Ilaria
				
				//conn = DriverManager.getConnection("jdbc:mysql://localhost/prova", "provauser", "password");
				conn.setAutoCommit(true);
			}
		}
		
		return conn;
		
	}
	
	//TODO da rimuovere
	public static int getProva(int id) {
		Statement statement;
		int valore = -1;
		try {
			statement = conn.createStatement();
			String query = "SELECT value from PROVA where id=" + id;
			ResultSet result = statement.executeQuery(query);
			if (result.next())
				valore = result.getInt("value");
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return valore;
	}
	
	public static void executeQuery(String query){
		Statement statement;
		
		try {
			statement = conn.createStatement();
			statement.executeUpdate(query);
						
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	
	public static void createProfiles(Program program) {
		Statement statement;
		String name=program.getName();
		Map<DayName,DayType> days =program.getDays();
		for(DayName day: DayName.values()) {
			DayType dayType=days.get(day);
			List<Interval> intervals = program.getIntervals().get(dayType);
			for(Interval interval:intervals) {
				try {
					statement = conn.createStatement();
					String query = "INSERT INTO profiles (ID_PROFILE, DAY_OF_WEEK,DAY_TYPE,DAY_MOMENT, START_HOUR, START_MIN,END_HOUR, END_MIN, TEMPERATURE) "+
									"VALUES ('"+name+"','"+day+"','"+dayType+"','"+interval.getDayMoment()+"',"+
									interval.getStartHour()+","+interval.getStartMin()+","+interval.getEndHour()+","+interval.getEndMin()+","+interval.getTemperature()+")" ;
					statement.executeUpdate(query);			
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	} 
	
	public static boolean existProfile(String name) {
		Statement statement;
		try {
			statement = conn.createStatement();
			String query = "SELECT DISTINCT ID_PROFILE FROM profiles";
			ResultSet result = statement.executeQuery(query);
			while(result.next()) {
				String idProfile = result.getString("ID_PROFILE");
				if(idProfile.compareTo(name)==0) {
					return true;
				}
			}
			return false;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
		
	}
	
	public static List<Program> getProfileList(){
		
		List<Profile> profiles = new ArrayList<>();
		Statement statement;
		try {
			statement = conn.createStatement();
			String query = "SELECT * from profiles";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				Profile profile = ProfileUtil.getProfile(result);
				profiles.add(profile);				
			}
			
			List<Program> programs = new ArrayList<>();
			Map<String,List<Profile>> profileMap = ProfileUtil.groupProfilesById(profiles);
			
			for(String profileId : profileMap.keySet()) {
				programs.add(ProfileUtil.getProgramFromProfile(profileMap.get(profileId)));
			}
			
			return programs;
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return null;
	}
	
}
