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

		if(req.getParameter("profile_name").equals("")) {
			resp.sendRedirect("pages/profileSummary.jsp?alert=2");
		}
		else if(DBClass.existProfile(req.getParameter("profile_name"))) {
			resp.sendRedirect("pages/profileSummary.jsp?alert=1");
		}else {
			program.setName(req.getParameter("profile_name"));
			DBClass.createProfiles(program);
			resp.sendRedirect("pages/profileList.jsp");
		}		
		// TODO Auto-generated method stub
	}
}
