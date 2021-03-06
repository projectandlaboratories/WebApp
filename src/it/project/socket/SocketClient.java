package it.project.socket;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;
import java.util.Date;

import org.json.JSONObject;

public class SocketClient {
	
	private static Socket socket;
	
	public static String createConnection(String IpAddress, int port) {
		try {
			int count = 0;
			while(count < 3) {
				socket = new Socket(IpAddress, port);
				count++;
				if(socket != null)
					return "OK";
			}
			
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
			System.out.println(new Date().toString() + "- Sending wifi info via socket --> " + json.toString());
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
