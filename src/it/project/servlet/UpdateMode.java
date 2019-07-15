package it.project.servlet;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import it.project.enums.*;
import it.project.mqtt.MQTTAppSensori;
import it.project.db.DBClass;

/**
 * Servlet implementation class UpdateMode
 */
@WebServlet("/UpdateMode")
public class UpdateMode extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateMode() {
        super();
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String action = request.getParameter("ACTION");
		String currentRoomId = (String) request.getSession().getAttribute("currentRoomId");
		
		switch(action) {
		 	case "changeManualProgrammableMode":
		 		Mode mode = Mode.valueOf((String)request.getParameter("mode"));
				Double targetTemp=Double.parseDouble(request.getParameter("targetTemp"));
				SystemType systemType = SystemType.valueOf(request.getParameter("act"));
				DBClass.updateRoomMode(currentRoomId, mode, targetTemp, systemType);
				//MQTTAppSensori.notifyModeChanged(mode, currentRoomId, targetTemp, systemType,0); //TODO decommentare quando dobbiamo testare mqtt con appSensori
		 		break;
		 	case "onOffClick":
		 		String prova = (String)request.getParameter("modeOff");
		 		Mode modeOff = Mode.valueOf((String)request.getParameter("modeOff"));//off o programmable
				DBClass.updateRoomMode(currentRoomId, modeOff, 0.0, SystemType.COLD);
				//MQTTAppSensori.notifyModeChanged(modeOff, currentRoomId, 0.0, SystemType.COLD,0); //TODO decommentare quando dobbiamo testare mqtt con appSensori
		 		break;
		 	case "setWeekendMode":				
		 		try {
		 			String date = request.getParameter("date").replaceAll("T", " ");
		 			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);
		 			Date now = new Date();
		 			Date endTimestamp = format.parse(date);
		 			if(now.compareTo(endTimestamp)>=0) {
		 				break;
		 			}
		 			DBClass.setWeekendMode(date.toString());
		 			DBClass.updateRoomMode(currentRoomId, Mode.PROGRAMMABLE, 20.0, SystemType.COLD);
		 			MQTTAppSensori.notifyModeChanged(Mode.WEEKEND,null, 0, null,endTimestamp.getTime()/1000);
		 		} catch (ParseException e) {
		 			
		 			e.printStackTrace();
		 		}

		 		break;
		 	case "removeWeekendMode":
		 		DBClass.stopWeekenMode();
				Date now = new Date();
				MQTTAppSensori.notifyModeChanged(Mode.WEEKEND,null, 0, null,now.getTime()/1000);
		 		break;
		}
		
		response.sendRedirect("index.jsp?currentRoom="+currentRoomId);
		
	}

}
