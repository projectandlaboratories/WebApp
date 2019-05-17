package it.project.db;

import java.sql.DriverManager;
import java.sql.SQLException;

public class RaspDBClass extends DBClass{

	public RaspDBClass() throws ClassNotFoundException, SQLException {
		super();
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/project", "PCSUser", "root");
		//conn = DriverManager.getConnection("jdbc:mysql://localhost/prova", "provauser", "password");
		DbSyncUtil.setConnection(conn);
		conn.setAutoCommit(true);
	}

}
