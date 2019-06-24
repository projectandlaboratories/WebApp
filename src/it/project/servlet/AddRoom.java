package it.project.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.Mode;
import it.project.enums.SystemType;

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
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String roomName = request.getParameter("roomName");
		int airCondModelId = Integer.parseInt(request.getParameter("airCondModel"));
		String roomId = request.getParameter("apMAC");
		
		//TODO controlla che il nome della stanza non esista getRooms()
		//TODO implementa connessione con schedina
		String defaultProfileId = DBClass.getConfigValue("defaultProfile");
		Program defaultProfile = DBClass.getProfileByName(defaultProfileId);
		/*(String room, String roomName, int idAirCond, boolean connState, Program winterProfile,
			Program summerProfile, Mode mode, double manualTemp, SystemType manualSystem) */
		Room newRoom = new Room(roomId,roomName, airCondModelId, true, defaultProfile, defaultProfile, Mode.PROGRAMMABLE, 0.0, SystemType.HOT);
		DBClass.createRoom(newRoom);
		Map<String,Room> roomMap=(Map<String,Room>) request.getSession(false).getAttribute("roomMap");
		roomMap.put(roomId, newRoom);
		response.sendRedirect("pages/roomManagementItem.jsp?roomId=" + roomId);	
	}
}
