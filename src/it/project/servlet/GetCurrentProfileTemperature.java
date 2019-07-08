package it.project.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.utils.DbIdentifiers;
import it.project.utils.ProfileUtil;

/**
 * Servlet implementation class getCurrentProfileTemperature
 */
@WebServlet("/getCurrentProfileTemperature")
public class GetCurrentProfileTemperature extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCurrentProfileTemperature() {
        super();
        
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String roomId = request.getParameter("roomId");
		DbIdentifiers user = DbIdentifiers.valueOf(request.getParameter("user"));
		try {
			DBClass.getConnection(user);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		Room room=DBClass.getRoomByName(roomId);
		response.setContentType("text/html");
		String temperature = ProfileUtil.getCurrentTemperature(room); 
		response.getWriter().write(temperature);
		
	}

}
