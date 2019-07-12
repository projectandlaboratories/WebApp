package it.project.servlet;

import java.awt.Desktop;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.enums.Season;
import it.project.mqtt.MQTTAppSensori;
import it.project.mqtt.MQTTDbProf;

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
       
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String profileName = request.getParameter("profile");
		String roomId = request.getParameter("room");
		Season season = Season.valueOf(request.getParameter("season"));
		
		Program profile = ((Map<String, Program>) request.getSession(false).getAttribute("profileMap")).get(profileName);
		
		DBClass.updateRoomProfile(roomId, profileName, season);
		MQTTAppSensori.notifyProfileChanged(roomId, season, profile); //TODO decommentare quando si testa mqtt AppSensori
		if(season.equals(Season.WINTER))
			((Map<String, Room>) request.getSession(false).getAttribute("roomMap")).get(roomId).setWinterProfile(profile);
		
		if(season.equals(Season.SUMMER))
			((Map<String, Room>) request.getSession(false).getAttribute("roomMap")).get(roomId).setSummerProfile(profile);
		
		Room room = (Room) ((Map<String, Room>) request.getSession(false).getAttribute("roomMap")).get(roomId);
		MQTTDbProf.sendEditRoomLog("AssignProfile", roomId, room , System.currentTimeMillis());
		
		request.getSession(false).setAttribute("activeTab", season.toString());
		response.sendRedirect(request.getContextPath()+"/pages/roomManagementItem.jsp?roomId=" + roomId);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
