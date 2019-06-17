package it.project.servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

import it.project.db.DBClass;
import it.project.dto.Program;

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
		 case "UPDATE": //todo da testare
			System.out.println(action);
			String previousName=(String)req.getSession(false).getAttribute("previousName");
			System.out.println(previousName);
			String currentName=(String)req.getParameter("profile_name");
			
			req.getSession(false).removeAttribute("previousName");		
			//if(currentName.compareTo(previousName)!=0) {
				
			//}
			if(req.getParameter("profile_name").equals("")) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=empty");
			}
			else if(currentName.compareTo(previousName)!=0 && DBClass.existProfile(req.getParameter("profile_name"))) {
				resp.sendRedirect("pages/profileSummary.jsp?alert=present");
			}else {
				DBClass.deleteProfiles(previousName);
				program.setName(req.getParameter("profile_name"));
				DBClass.createProfiles(program);
				resp.sendRedirect("pages/profileList.jsp");
			}
			 
			  
			 //req.getSession(false).removeAttribute("currentProfile");	
			break;
		 case "DELETE":
			System.out.println(action);
			boolean assigned = DBClass.isProfileAssigned(program.getName());
			 //req.getSession(false).removeAttribute("currentProfile");
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
