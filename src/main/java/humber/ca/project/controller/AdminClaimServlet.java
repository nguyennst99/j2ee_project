package humber.ca.project.controller;

import humber.ca.project.dao.ClaimDAO;
import humber.ca.project.dao.ClaimDAOImpl;
import humber.ca.project.model.Claim;
import humber.ca.project.model.ClaimStatus;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/claims")
public class AdminClaimServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClaimDAO claimDAO;

    @Override
    public void init() throws ServletException {
        claimDAO = new ClaimDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        listClaims(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            updateClaimStatus(request, response);
        } else {
            // Default action or unknown action, redirect to list view
            response.sendRedirect("/admin/claims");
        }
    }

    private void listClaims(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Claim> claimList = claimDAO.findAllClaims();

        request.setAttribute("claimList", claimList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/listClaims.jsp");
        dispatcher.forward(request, response);
    }

    private void updateClaimStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String claimIdStr = request.getParameter("claimId");
        String newStatusStr = request.getParameter("newStatus");
        String message;
        String messageType = "error"; // Default to error

        int claimId = -1;
        ClaimStatus newStatus = null;

        // Validate Claim ID
        try {
            claimId = Integer.parseInt(claimIdStr);
        } catch (NumberFormatException | NullPointerException e) {
            message = "Invalid+Claim+ID+format.";
            response.sendRedirect("/admin/claims?message=" + message + "&messageType=" + messageType);
            return;
        }

        // Validate Status Enum
        try {
            newStatus = ClaimStatus.valueOf(newStatusStr);
        } catch (IllegalArgumentException | NullPointerException e) {
            message = "Invalid+status+value+provided.";
            response.sendRedirect("/admin/claims?message=" + message + "&messageType=" + messageType);
            return;
        }

        // Attempt to update the status via DAO
        boolean success = claimDAO.updateClaimStatus(claimId, newStatus);

        if (success) {
            message = "Claim+ID+" + claimId + "+status+updated+to+" + newStatus.name() + "+successfully.";
            messageType = "success";
        } else {
            message = "Failed+to+update+status+for+Claim+ID+" + claimId + ".+Claim+may+not+exist.";
        }

        // Redirect back to the list view with a feedback message
        response.sendRedirect("/admin/claims?message=" + message + "&messageType=" + messageType);
    }
}
