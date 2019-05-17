package it.project.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class DbSyncUtil {
	
	private static Connection conn;
	private static final String IS_MODIFIED_FLAG_KEY = "db.sync.ismodified";
	private static final String LAST_TIMESTAMP_KEY = "db.sync.lastTimestamp";
	
	public static void setConnection(Connection connection) {
		conn = connection;
	}
	
	public static void storeQueries(List<String> queries) {
		String timestamp = new Timestamp(new Date().getTime()).toString();
		for(String query : queries) {
			storeQuery(query);
		}
		if(!getQueriesIsModifiedFlag()) {
			setLastQueryUpdateTimestamp(timestamp);
			setQueriesIsModifiedFlag(true);
		}
	}
	
	private static boolean getQueriesIsModifiedFlag() {
		Statement statement;
		String isModified = null;		
		try {
			statement = conn.createStatement();
			ResultSet result = statement.executeQuery("SELECT value from system_config where config_key = '" + IS_MODIFIED_FLAG_KEY +  "'");
			if (result.next())
				isModified = result.getString("value");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return Boolean.parseBoolean(isModified);
	}
	
	
	private static void setQueriesIsModifiedFlag(boolean isModified) {
		Statement statement;
		
		try {
			statement = conn.createStatement();
			statement.executeUpdate("UPDATE system_config SET value = '" + isModified + "' where config_key = '" + IS_MODIFIED_FLAG_KEY + "'");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static void setLastQueryUpdateTimestamp(String timestamp) {
		Statement statement;
		
		try {
			statement = conn.createStatement();
			statement.executeUpdate("UPDATE system_config SET value = '" + timestamp + "' where config_key = '" + LAST_TIMESTAMP_KEY + "'");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	private static void storeQuery(String query) {
		Statement statement;
		String timestamp = new Timestamp(new Date().getTime()).toString();
		try {
			statement = conn.createStatement();
			statement.executeUpdate("INSERT INTO query_to_do(ts,query) values('" + timestamp + "','" + query + "')");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	

}
