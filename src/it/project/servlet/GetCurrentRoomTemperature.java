package it.project.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.dto.Room;
import it.project.utils.ProfileUtil;

/**
 * Servlet implementation class GetCurrentRoomTemperature
 */
@WebServlet("/getCurrentRoomTemperature")
public class GetCurrentRoomTemperature extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCurrentRoomTemperature() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String roomId = request.getParameter("roomId");
		response.setContentType("text/html");
		String temperature = String.valueOf(DBClass.getRoomLastTemp(roomId));
		response.getWriter().write(temperature);
	}

}
