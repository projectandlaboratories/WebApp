package it.project.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Room;

/**
 * Servlet implementation class ChangeNetworkSettings
 */
@WebServlet("/changeNetworkSettings")
public class ChangeNetworkSettings extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangeNetworkSettings() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String ssid = request.getParameter("ssid");
		String password = request.getParameter("password");
		
		Process connectWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),ssid,password).redirectErrorStream(true).start();
		
		response.sendRedirect("pages/networkSettings.jsp?");
	}

}
