package it.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.db.DBClass;
import it.project.utils.DbIdentifiers;

/**
 * Servlet implementation class GetAntifreezeState
 */
@WebServlet("/getAntifreezeState")
public class GetAntifreezeState extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAntifreezeState() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DbIdentifiers user = DbIdentifiers.valueOf(request.getParameter("user"));
		try {
			DBClass.getConnection(user);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("text/html");
		String antifreezeState = DBClass.getAntifreezeState();
		response.getWriter().write(antifreezeState);
	}


}
