package it.project.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.db.MQTTDbSync;
import it.project.utils.DbIdentifiers;

/**
 * Servlet implementation class ConnectWifi
 */
@WebServlet("/connectWifi")
public class ConnectWifi extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConnectWifi() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String ssid = request.getParameter("ssid");
		String password = request.getParameter("password");

		Process connectWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),ssid,password).redirectErrorStream(true).start();

		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(connectWifi.getInputStream()));
		String connectedSsid = "";
		while ((line = input.readLine()) != null) {
			String[] outputSplitted = line.split(":");
			if(outputSplitted.length > 1){
				connectedSsid = line.split(":")[1];
				connectedSsid = connectedSsid.replace("\"", "");
				if(!connectedSsid.equals(ssid)){
					connectedSsid = "";
				}
				else {
					//se mi sono connesso con successo alla rete richiesta mi riconnetto al broker di DbSync
					MQTTDbSync.setConnection(DbIdentifiers.LOCAL);
				}
			}			
		}
		input.close();
		

		response.setContentType("text/html");
		response.getWriter().write(connectedSsid);
	}

}
