package it.project.db;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/myservlet")
public class MyServlet extends HttpServlet {
	
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AWSDBClass awsDb;
		try {
			 awsDb = new AWSDBClass();
			 if (request.getParameter("query") != null) {
		            List<String> queries = new ArrayList<>();
		            queries.add(request.getParameter("query"));
		            awsDb.storeQueries(queries);
		        }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

}
