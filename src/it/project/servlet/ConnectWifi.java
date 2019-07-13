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
        
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String ssid = request.getParameter("ssid");
		String password = request.getParameter("password");
		request.getSession(false).setAttribute("ipAddress", "None");
		Process connectWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),ssid,password).redirectErrorStream(true).start();

		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(connectWifi.getInputStream()));
		String connectedSsid = "";
		String result="false";
		while ((line = input.readLine()) != null) {
			connectedSsid = line;
			String[] outputSplitted = line.split(":");
			if(outputSplitted.length > 1){
				connectedSsid = line.split(":")[1];
				connectedSsid = connectedSsid.replace("\"", "");	
			}			
		}
		input.close();
		
		if(!connectedSsid.equals(ssid)){
			connectedSsid = "";
			result = "false";
		}
		else {
			result = "true";
			//salvo ssid e pwd sul db
			DBClass.updateConfigValue("localWifiSSid", connectedSsid);
			DBClass.updateConfigValue("localWifiPwd", password);
			//se mi sono connesso con successo alla rete richiesta mi riconnetto al broker di DbSync
			MQTTDbSync.setConnection(DbIdentifiers.LOCAL,getServletContext());
			
			Process getIpAddress = new ProcessBuilder("/bin/bash", getServletContext().getRealPath("/bash/getBrokerIpAddress.sh"))
					.redirectErrorStream(true).start();
			input = new BufferedReader(new InputStreamReader(getIpAddress.getInputStream()));
			String ipAddress = "None";
			while ((line = input.readLine()) != null) {
				ipAddress = line;
			}
			input.close();
			request.getSession(false).setAttribute("ipAddress", ipAddress);
		}
		
		response.sendRedirect("pages/networkSettings.jsp?result="+ result + "&connectedSsid=" + connectedSsid);
	}

}
