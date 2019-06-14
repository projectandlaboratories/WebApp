package it.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import it.project.enums.*;
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
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		Mode mode = Mode.valueOf((String)request.getParameter("mode"));
		Double targetTemp=Double.parseDouble(request.getParameter("targetTemp"));
		SystemType systemType = SystemType.valueOf(request.getParameter("act"));
		//System.out.println(mode+" " + targetTemp+" "+systemType);
		String currentRoomId = (String) request.getSession().getAttribute("currentRoomId");
		DBClass.updateRoomMode(currentRoomId, mode, targetTemp, systemType);
		response.sendRedirect("index.jsp");
	}

}
