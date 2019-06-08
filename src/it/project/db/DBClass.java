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
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/project", "PCSUser", "root"); //Vincenzo
				//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thermostat", "root", "ily2marzo"); //Ilaria
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
	
	public static List<Program> getProfileList(){
		
		List<Profile> profiles = new ArrayList<>();
		Statement statement;
		try {
			statement = conn.createStatement();
			String query = "SELECT * from profiles";
			ResultSet result = statement.executeQuery(query);
			if (result.next()) {
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
