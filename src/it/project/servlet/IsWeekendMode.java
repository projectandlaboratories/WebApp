package it.project.servlet;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.utils.DbIdentifiers;

/**
 * Servlet implementation class IsWeekendMode
 */
@WebServlet("/isWeekendMode")
public class IsWeekendMode extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IsWeekendMode() {
        super();
        
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html");
		DbIdentifiers user = DbIdentifiers.valueOf(request.getParameter("user"));
		try {
			DBClass.getConnection(user);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		String endTime = DBClass.isWeekendMode();
		if(endTime != null) {
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
			Date endDate;
			try {
				endDate = format.parse(endTime);
				Date now = new Date();
				if(endDate.compareTo(now) <= 0) { //esco dalla weekend mode
					DBClass.stopWeekenMode();
					endTime = "";
				}
				else {
					endTime = endTime.replaceAll(" ", "T");	
				}
			} catch (ParseException e) {
				
				e.printStackTrace();
			}
						
		}
		else {
			endTime = "";
		}
			
		response.getWriter().write(endTime);
	}

}
