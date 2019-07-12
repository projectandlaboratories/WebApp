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
import it.project.utils.ProfileUtil;

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
		
		//controlla che il nome della stanza non esista e che non sia stringa vuota
		int error = 0;
		if(roomName.equals(""))
			error = 1;
		else {
			Map<String,Room> rooms = DBClass.getRooms();
			for(String id : rooms.keySet()) {
				String name = rooms.get(id).getRoomName();
				if(roomName.equals(name)) {
					error = 2;
					break;
				}		
			}
		}
		
		if(error != 0) {
			response.sendRedirect("pages/addRoom.jsp?error=" + error);
		}
		else {
			int airCondModelId = Integer.parseInt(request.getParameter("airCondModel"));
			String ssid = request.getParameter("apMAC");
			String espPassword =  DBClass.getConfigValue("espPassword");
			String roomId = ssid.split("-")[1];


			//CONNECT TO ROOM
			try {
				ProfileUtil.connectToRoom(getServletContext(),roomId,airCondModelId, ssid, espPassword);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}


			//create room on db
			String defaultProfileId = DBClass.getConfigValue("defaultProfile");
			Program defaultProfile = DBClass.getProfileByName(defaultProfileId);
			Room newRoom = new Room(roomId,roomName, airCondModelId, true, defaultProfile, defaultProfile, Mode.PROGRAMMABLE, 0.0, SystemType.HOT);
			MQTTDbProf.sendEditRoomLog("AddRoom", roomId, newRoom, System.currentTimeMillis());
			
			DBClass.createRoom(newRoom);
			Map<String,Room> roomMap=(Map<String,Room>) request.getSession(false).getAttribute("roomMap");
			roomMap.put(roomId, newRoom);
			response.sendRedirect("pages/roomManagement.jsp");
		}
	}
}
