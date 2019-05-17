package it.project.db;

import java.sql.DriverManager;
import java.sql.SQLException;

public class AWSDBClass extends DBClass{
	

	public AWSDBClass() throws ClassNotFoundException, SQLException {
		super();
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://projectdb.c3mhigfjfwis.eu-west-3.rds.amazonaws.com:3306/projectDb", "db_admin", "projectpwd");
		DbSyncUtil.setConnection(conn);
		conn.setAutoCommit(true);
	}
	
}
