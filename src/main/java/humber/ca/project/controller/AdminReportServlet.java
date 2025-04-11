package humber.ca.project.controller;

import humber.ca.project.dao.UserDAO;
import humber.ca.project.dao.UserDAOImpl;
import humber.ca.project.model.UserReportDetail;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports/all")
public class AdminReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Call the new DAO method to get the structured report data
        List<UserReportDetail> userReportList = userDAO.getUserReportDetails();

        // 2. Set the list of DTOs as a request attribute
        request.setAttribute("userReportList", userReportList);

        // 3. Forward to the report JSP (which needs to be updated)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/reportAll.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
