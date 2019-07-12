package it.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
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
		int airCondModelId = DBClass.getRoomByName(roomId).getIdAirCond();
		String ssid = "ESP-" + roomId;
		String espPassword =  DBClass.getConfigValue("espPassword");
		
		//CONNECT TO ROOM
		try {
			ProfileUtil.connectToRoom(getServletContext(),roomId,airCondModelId, ssid, espPassword);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.sendRedirect("pages/roomManagement.jsp");
	}

}
