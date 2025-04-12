package humber.ca.project.controller;


import humber.ca.project.dao.ClaimDAO;
import humber.ca.project.dao.ClaimDAOImpl;
import humber.ca.project.model.ClaimStatus;
import humber.ca.project.model.Role;
//import jakarta.servlet.RequestDispatcher;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClaimDAO claimDAO;

    @Override
    public void init() throws ServletException {
        claimDAO = new ClaimDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do not create if no session

        if (session == null || session.getAttribute("userId") == null || session.getAttribute("userRole") != Role.admin) {
            response.sendRedirect("/login?error=nosession");
            return;
        }


        // --- Fetch Claims Per Product Chart Data ---
        Map<String, Long> productClaimData = claimDAO.getClaimCountsPerProductType();
        List<String> productClaimLabels = new ArrayList<>(productClaimData.keySet()); // Get labels (product names)
        List<Long> productClaimCounts = new ArrayList<>(productClaimData.values()); // Get counts

        request.setAttribute("productClaimLabels", productClaimLabels);
        request.setAttribute("productClaimCounts", productClaimCounts);
        // --- End Fetch Chart Data ---

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
