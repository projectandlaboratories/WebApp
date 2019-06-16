package it.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;

/**
 * Servlet implementation class GetActuatorState
 */
@WebServlet("/getActuatorState")
public class GetActuatorState extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetActuatorState() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String roomId = request.getParameter("roomId");
		response.setContentType("text/html");
		String actuatorState = DBClass.getActuatorState(roomId).name();
		response.getWriter().write(actuatorState);
	}

}