package it.project.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import it.project.dto.Interval;
import it.project.dto.Profile;
import it.project.enums.DayMoment;
import it.project.enums.DayName;
import it.project.enums.DayType;
import it.project.utils.DbIdentifiers;

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
	
	public static List<Profile> getProfileList(){
		
		List<Profile> profiles = new ArrayList<>();
		Statement statement;
		try {
			statement = conn.createStatement();
			String query = "SELECT * from profiles";
			ResultSet result = statement.executeQuery(query);
			if (result.next()) {
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
				profiles.add(profile);				
			}
		
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return null;
	}
	
}
