package it.project.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBClass {

private Connection conn;
	
	
	public DBClass() throws ClassNotFoundException, SQLException{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		
			conn = DriverManager.getConnection("jdbc:mysql://localhost/prova", "provauser", "password");
			conn.setAutoCommit(true);
			
	}
	
	public int getProva() {
		Statement statement;
		int valore = -1;
		try {
			statement = conn.createStatement();
			String query = "SELECT value from PROVA where id=0";
			ResultSet result = statement.executeQuery(query);
			if (result.next())
				valore = result.getInt("value");
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return valore;
	}
}
