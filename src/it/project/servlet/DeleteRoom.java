package it.project.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Room;
import it.project.mqtt.MQTTDbProf;

/**
 * Servlet implementation class DeleteRoom
 */
@WebServlet("/deleteRoom")
public class DeleteRoom extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteRoom() {
        super();
        
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String roomId = request.getParameter("room");
		
		DBClass.deleteRoom(roomId);
		
		Map<String,Room> roomMap=(Map<String,Room>) request.getSession(false).getAttribute("roomMap");
		roomMap.remove(roomId);
		MQTTDbProf.sendEditRoomLog("DeleteRoom", roomId, null, System.currentTimeMillis());
		
		response.sendRedirect("pages/roomManagement.jsp");
	}

}
