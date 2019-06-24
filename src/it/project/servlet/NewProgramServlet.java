package it.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.enums.Season;
import it.project.mqtt.MQTTAppSensori;

public class NewProgramServlet  extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Program program=(Program) req.getSession(false).getAttribute("currentProfile");
		String action = req.getParameter("ACTION");
		
		switch(action) {
		 case "ADD":
			System.out.println(action);
			if(req.getParameter("profile_name").equals("")) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=2");
			}
			else if(DBClass.existProfile(req.getParameter("profile_name"))) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=1");
			}else {
				//req.getSession(false).removeAttribute("currentProfile");
				program.setName(req.getParameter("profile_name"));
				DBClass.createProfiles(program);
				resp.sendRedirect("pages/profileList.jsp");
			}
			break;
		 case "UPDATE":
			System.out.println(action + " Profile");

			String previousName=(String)req.getSession(false).getAttribute("previousName");
			//System.out.println(previousName);
			String currentName=(String)req.getParameter("profile_name");
			
			req.getSession(false).removeAttribute("previousName");		

			if(req.getParameter("profile_name").equals("")) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=empty");
			}
			else if(currentName.compareTo(previousName)!=0 && DBClass.existProfile(req.getParameter("profile_name"))) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=present");
			}else {
				
				//DBClass.deleteProfiles(previousName);
				program.setName(req.getParameter("profile_name"));
				//DBClass.createProfiles(program);
				DBClass.updateProfile(previousName, currentName, program);
				String defaultProfile = DBClass.getConfigValue("defaultProfile");
				if(previousName.compareTo(defaultProfile)==0) {
					DBClass.updateConfigValue("defaultProfile",currentName);
				}
				
				//update appSensori profile info through MQTT
				List<String> rooms = DBClass.getRoomIdsAndSeasonByProfile(currentName);
				for(String roomSeason : rooms) {
					String roomId = roomSeason.split(";")[0];
					Season season = Season.valueOf(roomSeason.split(";")[1]);
					MQTTAppSensori.notifyProfileChanged(roomId, season, program);
				}
				resp.sendRedirect("pages/profileList.jsp");
			}
			break;
		 
		 case "DELETE":
			System.out.println(action);
			boolean assigned = DBClass.isProfileAssigned(program.getName());
			if(!assigned) {
				DBClass.deleteProfiles(program.getName());			 
				resp.sendRedirect("pages/profileList.jsp");
			}
			else {
				resp.sendRedirect("pages/profileShow.jsp?profile=prova&alert=assigned");
			}
			break;	 
		}			
		// TODO Auto-generated method stub
	}
}
