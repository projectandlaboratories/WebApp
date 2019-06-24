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
import java.util.NavigableMap;
import java.util.SortedMap;
import java.util.TreeMap;

import it.project.dto.Interval;
import it.project.dto.Profile;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.*;
import it.project.utils.DbIdentifiers;
import it.project.utils.ProfileUtil;

public class DBClass {

	private static Connection conn;
	private static DbIdentifiers dbuser;
	private static String mainRoomId; //MAC del raspberry
	
	
	public DBClass(){
	}
	
	public static Connection getConnection(DbIdentifiers user) throws Exception {
		dbuser = user;
		if(conn == null) {
			if(user.equals(DbIdentifiers.AWS)) {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://projectdb.c3mhigfjfwis.eu-west-3.rds.amazonaws.com:3306/projectDb", "db_admin", "projectpwd");
				conn.setAutoCommit(true);
			}
			if(user.equals(DbIdentifiers.LOCAL)) {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/project", "PCSUser", "root"); //Vincenzo
				//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/thermostat?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "ily2marzo"); //Ilaria
				
				//conn = DriverManager.getConnection("jdbc:mysql://localhost/prova", "provauser", "password"); //raspberry vins
				//conn = DriverManager.getConnection("jdbc:mysql://localhost/prova?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "provauser", "password"); //raspberry prof
				conn.setAutoCommit(true);
			}
		}
		
		return conn;
		
	}
	
	public static String getMainRoomId() {
		if(mainRoomId==null) {
			mainRoomId=getConfigValue("mainRoomId");
		}
		return mainRoomId;
	}

	
	public static void saveActuatorStatus(String roomId, ActuatorState actStatus) {
		Statement statement;
		try {
			statement = getStatement();
			java.sql.Timestamp now = new java.sql.Timestamp(new java.util.Date().getTime());
			String query = "INSERT INTO actuators(ID_ROOM,TIMESTAMP,STATE) values('" + roomId + "','" + now + "'," + actStatus.name() + ");" ;
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void executeQuery(String query){
		Statement statement;

		try {
			statement = getStatement();
			statement.executeUpdate(query);

		} catch (Exception e) {
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
					statement = getStatement();
					String query = "INSERT INTO profiles (ID_PROFILE, DAY_OF_WEEK,DAY_TYPE,DAY_MOMENT, START_HOUR, START_MIN,END_HOUR, END_MIN, TEMPERATURE) "+
							"VALUES ('"+name+"','"+day+"','"+dayType+"','"+interval.getDayMoment()+"',"+
							interval.getStartHour()+","+interval.getStartMin()+","+interval.getEndHour()+","+interval.getEndMin()+","+interval.getTemperature()+")" ;
					statement.executeUpdate(query);
					MQTTDbSync.sendQueryMessage(query);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public static void saveCurrentTemperature(String roomId, int currentTemp) {
		Statement statement;
		try {
			statement = getStatement();
			java.sql.Timestamp now = new java.sql.Timestamp(new java.util.Date().getTime());
			String query = "INSERT INTO temperatures(ID_ROOM,TIMESTAMP,TEMPERATURE) values('" + roomId + "','" + now + "'," + currentTemp + ");" ;
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void updateProfile(String previousProfileName, String newProfileName, Program program) {
		Statement statement;
		String fakeProfileName="fake111";
		try {
			statement = conn.createStatement();
			String query;
			//creo profilo falso
			query= "INSERT INTO profiles (ID_PROFILE, DAY_OF_WEEK,DAY_TYPE,DAY_MOMENT, START_HOUR, START_MIN,END_HOUR, END_MIN, TEMPERATURE) "+
					"VALUES ('"+fakeProfileName+"','-','-','-',0,0,0,0,0)";	
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
			//assegno profilo falso alle stanze che hanno previousProfileName
			query="UPDATE rooms set ID_PROFILE_WINTER = '"+fakeProfileName+"' where ID_PROFILE_WINTER='"+previousProfileName+"'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
			query="UPDATE rooms set ID_PROFILE_SUMMER = '"+fakeProfileName+"' where ID_PROFILE_SUMMER='"+previousProfileName+"'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
			//delete Profilo vecchio
			deleteProfiles(previousProfileName);
			
			//creazione profilo nuovo
			createProfiles(program);
			
			//assegno profilo nuovo alle stanze che hanno fakeProfileName
			query="UPDATE rooms set ID_PROFILE_WINTER = '"+newProfileName+"' where ID_PROFILE_WINTER='"+fakeProfileName+"'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
			query="UPDATE rooms set ID_PROFILE_SUMMER = '"+newProfileName+"' where ID_PROFILE_SUMMER='"+fakeProfileName+"'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
			
			//cancello profilo fake
			query= "DELETE FROM profiles WHERE ID_PROFILE = '"+fakeProfileName+"'";	
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	
	public static boolean isProfileAssigned(String name) {
		Statement statement;
		
		try {
			statement = conn.createStatement();
			String query = "select count(*) as count from rooms where ID_PROFILE_WINTER='"+name+"' or ID_PROFILE_SUMMER='"+name+"'";
			ResultSet result = statement.executeQuery(query);
			while(result.next()) {
				int count = result.getInt("count");
				if(count>0) {
					return true;
				}
			}
			return false;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean existProfile(String name) {
		Statement statement;
		try {
			statement = getStatement();
			String query = "SELECT DISTINCT ID_PROFILE FROM profiles";
			ResultSet result = statement.executeQuery(query);
			while(result.next()) {
				String idProfile = result.getString("ID_PROFILE");
				if(idProfile.compareTo(name)==0) {
					return true;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
		
	}
	
	public static void deleteProfiles(String name) {//todo controlla che nessuna room ce l'abbia come profilo
		Statement statement;		
		try {
			statement = getStatement();
			String query = "DELETE from profiles where id_profile='"+name+"'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
	
	
	public static Map<String,Program> getProfileMap(){
		
		List<Profile> profiles = new ArrayList<>();
		Statement statement;
		try {
			statement = getStatement();
			String query = "SELECT * from profiles";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				Profile profile = ProfileUtil.getProfile(result);
				profiles.add(profile);				
			}
			
			Map<String,Program> programs = new HashMap<>();
			Map<String,List<Profile>> profileMap = ProfileUtil.groupProfilesById(profiles);
			
			for(String profileId : profileMap.keySet()) {
				programs.put(profileId,ProfileUtil.getProgramFromProfile(profileMap.get(profileId)));
			}
			

			return programs;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return null;
	}
	
	public static void updateRoomProfile(String roomId, String profileName, Season season) {
		Statement statement;
		try {
			statement = getStatement();
			String query = "UPDATE rooms SET ID_PROFILE_" + season.name() + "= '" + profileName + "' WHERE ID_ROOM = '" + roomId + "'" ;
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public static void updateRoomMode(String roomId, Mode mode, Double targetTemp, SystemType systemType) {
		Statement statement;
		try {
			statement = getStatement();
			String query = "UPDATE rooms SET MODE= '" + mode + "', MANUAL_TEMP= '" + targetTemp + "', MANUAL_SYSTEM= '" + systemType 
					+ "' WHERE ID_ROOM = '" + roomId + "'" ;
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	

	
	public static String getRoomProfile(String roomId, Season season) {
		
		Statement statement;
		String profileId = null;
		try {
			statement = getStatement();
			String query = "SELECT ID_PROFILE_" + season + " from rooms where ID_ROOM = '" + roomId + "'";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				profileId = result.getString(1);				
			}
			
			return profileId;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
	}
	
	public static Program getProfileByName(String profileName) {
		Statement statement;
		List<Profile> profiles = new ArrayList<>();
		try {
			statement = getStatement();
			String query = "SELECT * from profiles where ID_PROFILE = '" + profileName + "'";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				Profile profile = ProfileUtil.getProfile(result);
				profiles.add(profile);
			}
			Program program = ProfileUtil.getProgramFromProfile(profiles);
			return program;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
	}
	
	
	public static int getRoomLastTemp(String roomId) {
		Statement statement;
		List<Profile> profiles = new ArrayList<>();
		try {
			statement = getStatement();
			int temperature = -100;
			String query = "SELECT TEMPERATURE from temperatures where ID_ROOM = '" + roomId + "' order by timestamp desc limit 1";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				temperature = result.getInt("TEMPERATURE");
			}
			return temperature;
		} catch (Exception e) {
			e.printStackTrace();
			return -100;
		}
	}
	
	
	public static Map<String,Room> getRooms(){
		
		//Map<String,Room> rooms = new HashMap<String, Room>();
		NavigableMap<String, Room> rooms = new TreeMap<>();
		Statement statement;
		try {
			statement = getStatement();
			String query = "SELECT * from rooms";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				String idRoom = result.getString("ID_ROOM");
				String roomName = result.getString("ROOM_NAME");
				int idAirCond = result.getInt("ID_AIR_COND");
				boolean connState = result.getBoolean("CONN_STATE");
				String summerProfileName = result.getString("ID_PROFILE_SUMMER");
				String winterProfileName = result.getString("ID_PROFILE_WINTER");
				Mode mode = Mode.valueOf(result.getString("MODE"));
				double manualTemp = result.getDouble("MANUAL_TEMP");
				SystemType manualSystem = SystemType.valueOf(result.getString("MANUAL_SYSTEM"));
				
				Program summerProfile = getProfileByName(summerProfileName);
				Program winterProfile = getProfileByName(winterProfileName);
				
				Room room = new Room(idRoom,roomName,idAirCond,connState, winterProfile,summerProfile,mode, manualTemp, manualSystem);
				rooms.put(idRoom, room);
			}
			
			return rooms;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static ActuatorState getActuatorState(String roomId) {
		Statement statement;
		try {
			statement = getStatement();
			ActuatorState state = null;
			String query = "SELECT STATE from actuators where ID_ROOM = '" + roomId + "' order by timestamp desc limit 1";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				state = ActuatorState.valueOf(result.getString("STATE"));
			}
			return state;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static String isWeekendMode() {
		Statement statement;
		String endTime = null;
		try {
			statement = getStatement();
			String query = "SELECT END_TIME from weekend_mode where WMODE = 1;";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				endTime = result.getString("END_TIME");
			}
			return endTime;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static Room getRoomByName(String roomId) {
		Statement statement;
		Room room = null;
		try {
			statement = getStatement();
			String query = "SELECT * from rooms where ID_ROOM = '" + roomId + "'";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				String idRoom = result.getString("ID_ROOM");
				String roomName = result.getString("ROOM_NAME");
				int idAirCond = result.getInt("ID_AIR_COND");
				boolean connState = result.getBoolean("CONN_STATE");
				String summerProfileName = result.getString("ID_PROFILE_SUMMER");
				String winterProfileName = result.getString("ID_PROFILE_WINTER");
				Mode mode = Mode.valueOf(result.getString("MODE"));
				double manualTemp = result.getDouble("MANUAL_TEMP");
				SystemType manualSystem = SystemType.valueOf(result.getString("MANUAL_SYSTEM"));
				
				Program summerProfile = getProfileByName(summerProfileName);
				Program winterProfile = getProfileByName(winterProfileName);
				
				room = new Room(idRoom,roomName,idAirCond,connState, winterProfile,summerProfile,mode, manualTemp, manualSystem);
			}
			
			return room;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static void setWeekendMode(String date) {
		Statement statement;
		int id = -1;
		try {
			statement = getStatement();
			String getIdQuery = "SELECT max(id) as lastid from weekend_mode";
			ResultSet result = statement.executeQuery(getIdQuery);
			while (result.next()) {
				id = result.getInt("lastid") + 1;
			}
			
			if(id != -1) {
				java.sql.Timestamp now = new java.sql.Timestamp(new java.util.Date().getTime());
				String query = "insert into weekend_mode(ID,WMODE,START_TIME,END_TIME)"
						+ "VALUES(" + id + ",true,'"+ now + "','" + date + "');";
				statement.executeUpdate(query);
				MQTTDbSync.sendQueryMessage(query);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void stopWeekenMode() {
		Statement statement;
		try {
			statement = getStatement();
			String query = "update weekend_mode set WMODE = 0 where WMODE = 1";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static Map<Integer,String> getAirCondList(){
		Statement statement;
		Map<Integer,String> airCondMap = new HashMap<>();
		try {
			statement = getStatement();
			String query = "SELECT * from air_cond";
			ResultSet result = statement.executeQuery(query);
			while (result.next()) {
				int id = result.getInt("ID_AIR_COND");
				String modelName = result.getString("MODEL_NAME");
				airCondMap.put(id, modelName);
			}
			return airCondMap;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static void editRoom(String roomId, String roomName, String airCondModelId) {
		
		Statement statement;
		
		try {
			statement = conn.createStatement();
			String query = "UPDATE rooms SET ID_AIR_COND = " + airCondModelId + ",ROOM_NAME = '" + roomName +  "' where ID_ROOM = '" + roomId + "';";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static Statement getStatement() throws Exception {
		if(conn == null)
			conn = getConnection(dbuser);
			
		return conn.createStatement();
	}
	
	public static void deleteRoom(String roomId) {
		Statement statement;
		
		try {
			statement = conn.createStatement();
			String query = "DELETE FROM rooms WHERE ID_ROOM='" + roomId +  "'";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
	
	public static void createRoom(String roomName, String airCondModelId, String roomId) {
		Statement statement;
		try {
			statement = getStatement();
			String defaultProfile = DBClass.getConfigValue("defaultProfile");
			String query = "insert into rooms(ID_ROOM, ROOM_NAME, ID_AIR_COND, CONN_STATE, ID_PROFILE_WINTER, ID_PROFILE_SUMMER, MODE, MANUAL_TEMP, MANUAL_SYSTEM)"+
							"values('"+roomId+"','"+roomName+"',"+airCondModelId+",true,'"+defaultProfile+"','"+defaultProfile+"','"+Mode.PROGRAMMABLE.toString()+"',0,'" + SystemType.HOT.toString()+"')";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public static String getConfigValue(String config_key) {
		Statement statement;
		String retval="";
		try {
			statement = getStatement();
			String query = "SELECT value from system_config where config_key='"+config_key+"'";
			ResultSet result = statement.executeQuery(query);
			if (result.next())
				retval = result.getString("value");
		} catch (Exception e) {			
			e.printStackTrace();
		}		
		return retval;
	}
	
	public static void updateConfigValue (String config_key, String value) {
		Statement statement;
		try {
			statement = getStatement();
			String query = "UPDATE system_config SET value = '" + value + "' where config_key = '" + config_key + "';";
			statement.executeUpdate(query);
			MQTTDbSync.sendQueryMessage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}



	
}
