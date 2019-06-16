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
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String roomId = request.getParameter("roomId");
		Room room=((Map<String,Room>) request.getSession(false).getAttribute("roomMap")).get(roomId);
		response.setContentType("text/html");
		String temperature = ProfileUtil.getCurrentTemperature(room); 
		response.getWriter().write(temperature);
		
	}

}
