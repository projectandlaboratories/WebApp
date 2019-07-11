package it.project.socket;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;

import org.json.JSONObject;

public class SocketClient {
	
	private static Socket socket;
	
	public static String createConnection(String IpAddress, int port) {
		try {
			socket = new Socket(IpAddress, port);
			if(socket != null)
				return "OK";
			else
				return "NOT OK";
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		} 
		
	}
	
	public static void sendWifiInfo(String wifiSsid, String wifiPwd) {
		OutputStream output;
		try {
			output = socket.getOutputStream();
			PrintWriter writer = new PrintWriter(output, true); //The argument true indicates that the writer flushes the data after each method call (auto flush).
			JSONObject json = new JSONObject();
			json.put("wifiSsid", wifiSsid);
			json.put("wifiPwd", wifiPwd);
			
			writer.println(json.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		//per ricevere info dal server
//		InputStream input = socket.getInputStream();
//		BufferedReader reader = new BufferedReader(new InputStreamReader(input));
//		String line = reader.readLine();  
		
	}
	
	public static void closeConnection() {
		try {
			if(socket != null)
				socket.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
