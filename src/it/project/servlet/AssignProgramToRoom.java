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
import it.project.enums.Season;

/**
 * Servlet implementation class AssignProgramToRoom
 */

public class AssignProgramToRoom extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AssignProgramToRoom() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String profileName = request.getParameter("profile");
		String roomId = request.getParameter("room");
		Season season = Season.valueOf(request.getParameter("season"));
		
		Program profile = ((Map<String, Program>) request.getSession(false).getAttribute("profileMap")).get(profileName);
		
		DBClass.updateRoomProfile(roomId, profileName, season);
		if(season.equals(Season.WINTER))
			((Map<String, Room>) request.getSession(false).getAttribute("roomMap")).get(roomId).setWinterProfile(profile);
		if(season.equals(Season.SUMMER))
			((Map<String, Room>) request.getSession(false).getAttribute("roomMap")).get(roomId).setSummerProfile(profile);
		response.sendRedirect(request.getContextPath()+"/pages/roomManagementItem.jsp?roomId=" + roomId);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
