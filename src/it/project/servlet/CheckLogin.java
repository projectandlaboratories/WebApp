package it.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import it.project.socket.SocketClient;

/**
 * Servlet implementation class CheckLogin
 */
@WebServlet("/checkLogin")
public class CheckLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckLogin() {
        super();
  
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	if(request.getParameter("action").equals("logout")) {
			 request.getSession(false).setAttribute("logged","false");
			 response.sendRedirect("pages/login.jsp");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if(username.equals("PL19-20") && password.equals("password")) {
			response.sendRedirect("index.jsp?logged=true");
		}
		else if(username.equals("admin") && password.equals("admin")) {
			response.sendRedirect("pages/admin.jsp");
		}
		else {
			response.sendRedirect("pages/login.jsp?error=true");
		}
	}

}
