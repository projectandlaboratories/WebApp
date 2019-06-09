package it.project.servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Program;

public class NewProgramServlet  extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Program program=(Program) req.getSession(false).getAttribute("program");
		
		System.out.println(req.getParameter("profile_name"));
		program.setName(req.getParameter("profile_name"));
		DBClass.createProfiles(program);
		// TODO Auto-generated method stub
	}
}
