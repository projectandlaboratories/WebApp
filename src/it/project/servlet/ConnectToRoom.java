package it.project.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.cj.xdevapi.DatabaseObject.DbObjectStatus;

import it.project.db.DBClass;
import it.project.db.MQTTDbSync;
import it.project.utils.ProfileUtil;

/**
 * Servlet implementation class ConnectToRoom
 */
@WebServlet("/connectToRoom")
public class ConnectToRoom extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConnectToRoom() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String roomId = request.getParameter("roomId");
		String user = (String) request.getSession(false).getAttribute("user");
		String awsUser = (String) request.getSession(false).getAttribute("awsUser");
		
		if(user.equals(awsUser)) {
			MQTTDbSync.connectToRoom(roomId);
		}
		else {
			int airCondModelId = DBClass.getRoomByName(roomId).getIdAirCond();
			String ssid = "ESP-" + roomId;
			String espPassword =  DBClass.getConfigValue("espPassword");
			
			String mainRoomId = DBClass.getMainRoomId();
			if(mainRoomId.equals(roomId)) {
				Process connectMainRoom= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_main_room.sh")).redirectErrorStream(true).start();
				String line;
				BufferedReader input = new BufferedReader(new InputStreamReader(connectMainRoom.getInputStream()));
				while ((line = input.readLine()) != null) {
					String output = line;	
				}
			}
			else {
				//CONNECT TO ROOM
				try {
					ProfileUtil.connectToRoom(getServletContext(),roomId,airCondModelId, ssid, espPassword);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		String from = request.getParameter("from");
		response.sendRedirect( from +".jsp");
	}

}
