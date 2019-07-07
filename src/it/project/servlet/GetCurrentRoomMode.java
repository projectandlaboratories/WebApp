package it.project.servlet;

import java.io.IOException;
import java.util.NavigableMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Room;
import it.project.enums.Mode;
import it.project.utils.DbIdentifiers;
import it.project.utils.ProfileUtil;

/**
 * Servlet implementation class GetCurrentRoomMode
 */
@WebServlet("/GetCurrentRoomMode")
public class GetCurrentRoomMode extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCurrentRoomMode() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String roomId = request.getParameter("roomId");
		DbIdentifiers user = DbIdentifiers.valueOf(request.getParameter("user"));
		try {
			DBClass.getConnection(user);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("text/html");
		Room room = DBClass.getRoomByName(roomId);
		String temperature;
		if(room.getMode().equals(Mode.PROGRAMMABLE)) {
			temperature = ProfileUtil.getCurrentTemperature(room); 
		}else {
			temperature = new Double(room.getManualTemp()).toString();
		}
		String state = room.getMode().toString() + "-" + temperature + "-" + room.getManualSystem().toString();
		//System.out.println(state);
		response.getWriter().write(state);
	}

}
