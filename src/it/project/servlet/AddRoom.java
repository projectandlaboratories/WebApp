package it.project.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.db.MQTTDbSync;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.Mode;
import it.project.enums.SystemType;
import it.project.enums.Topics;
import it.project.mqtt.MQTTAppSensori;
import it.project.mqtt.MQTTDbProf;
import it.project.socket.SocketClient;
import it.project.utils.DbIdentifiers;

/**
 * Servlet implementation class AddRoom
 */
@WebServlet("/AddRoom")
public class AddRoom extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddRoom() {
        super();
        
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		SocketClient.createConnection("192.168.4.1", 5001);
		String localWifiSSid = "Vodafone-34994366";//DBClass.getConfigValue("localWifiSSid");
		String localWifiPwd = "dfl25j784zw6biv";//DBClass.getConfigValue("localWifiPwd");
		SocketClient.sendWifiInfo(localWifiSSid, localWifiPwd);
		//SocketClient.closeConnection();
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String roomName = request.getParameter("roomName");
		
		//controlla che il nome della stanza non esista
		boolean duplicateName = false;
		Map<String,Room> rooms = DBClass.getRooms();
		for(String id : rooms.keySet()) {
			String name = rooms.get(id).getRoomName();
			if(roomName.equals(name)) {
				duplicateName = true;
				break;
			}		
		}
		if(duplicateName) {
			response.sendRedirect("pages/addRoom.jsp?duplicateName=true");
		}
		else {
			int airCondModelId = Integer.parseInt(request.getParameter("airCondModel"));
			String ssid = request.getParameter("apMAC");
			String espPassword =  DBClass.getConfigValue("espPassword");
			String roomId = ssid.split("-")[1];


			//connect to ESP AP
			Process connectEspAP= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),ssid,espPassword).redirectErrorStream(true).start();
			String line;
			BufferedReader input = new BufferedReader(new InputStreamReader(connectEspAP.getInputStream()));
			String connectedSsid = "";
			while ((line = input.readLine()) != null) {
				String[] outputSplitted = line.split(":");		
			}
			
			
			//get ESP IP
			Process getAPipAddress = new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/getAPipAddress.sh")).redirectErrorStream(true).start();
			//String line;
			input = new BufferedReader(new InputStreamReader(getAPipAddress.getInputStream()));
			String ESPipAddress = "";
			while ((line = input.readLine()) != null) {
				ESPipAddress = line.split(" ")[2];
			}

			//send Wifi Info to ESP
			String socketResult = SocketClient.createConnection(ESPipAddress, 5001);
			String localWifiSSid = DBClass.getConfigValue("localWifiSSid");
			String localWifiPwd = DBClass.getConfigValue("localWifiPwd");
			SocketClient.sendWifiInfo(localWifiSSid, localWifiPwd);
			//SocketClient.closeConnection();


			//connect to local Wifi
			Process connectLocalWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),localWifiSSid,localWifiPwd).redirectErrorStream(true).start();
			input = new BufferedReader(new InputStreamReader(connectLocalWifi.getInputStream()));
			connectedSsid = "";
			while ((line = input.readLine()) != null) {
				String[] outputSplitted = line.split(":");		
			}
			
			
			//get broker IP
			Process getBrokerIPAddress = new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/getBrokerIpAddress.sh")).redirectErrorStream(true).start();
			input = new BufferedReader(new InputStreamReader(getBrokerIPAddress.getInputStream()));
			String brokerIpAddress = "";
			while ((line = input.readLine()) != null) {
				brokerIpAddress = line;
			}

			//send roomInfo to ESP via MQTT with online broker
			MQTTDbSync.sendNewRoomInfo(roomId, airCondModelId, brokerIpAddress);


			//create room on db
			String defaultProfileId = DBClass.getConfigValue("defaultProfile");
			Program defaultProfile = DBClass.getProfileByName(defaultProfileId);
			Room newRoom = new Room(roomId,roomName, airCondModelId, true, defaultProfile, defaultProfile, Mode.PROGRAMMABLE, 0.0, SystemType.HOT);
			MQTTDbProf.sendEditRoomLog("AddRoom", roomId, newRoom, System.currentTimeMillis());
			
			DBClass.createRoom(newRoom);
			Map<String,Room> roomMap=(Map<String,Room>) request.getSession(false).getAttribute("roomMap");
			roomMap.put(roomId, newRoom);
			response.sendRedirect("pages/roomManagementItem.jsp?roomId=" + roomId);
			//response.sendRedirect("pages/addRoom.jsp?ssidConnected="+ connectedSsid + "&roomId=" + roomId + "&ipBroker=" + brokerIpAddress + "&ipESP=" + ESPipAddress+ "&ssidESP=" + ssid + "&ssidPwd=" + espPassword);	
			//response.sendRedirect("pages/addRoom.jsp?socketResult="+ socketResult + "&ipBroker=" + brokerIpAddress + "&ipESP=" + ESPipAddress);	
		}
	}
}
