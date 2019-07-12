package it.project.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.Season;
import it.project.mqtt.MQTTDbProf;

/**
 * Servlet implementation class EditRoom
 */
@WebServlet("/editRoom")
public class EditRoom extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditRoom() {
        super();
        
    }
    

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String roomId = request.getParameter("room");
		String roomName = request.getParameter("room_name");
		String airCondModelId = request.getParameter("airCondModel");
		
		Map<String,Room> roomMap=(Map<String,Room>) request.getSession(false).getAttribute("roomMap");
		roomMap.get(roomId).setRoomName(roomName);
		roomMap.get(roomId).setIdAirCond(Integer.parseInt(airCondModelId));
		
		DBClass.editRoom(roomId,roomName,airCondModelId);
		MQTTDbProf.sendEditRoomLog("EditRoom", roomId, roomMap.get(roomId), System.currentTimeMillis());
		
		response.sendRedirect("pages/roomManagementItem.jsp?roomId=" + roomId);
			
	}

}
