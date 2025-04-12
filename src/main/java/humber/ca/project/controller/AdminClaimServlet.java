package humber.ca.project.controller;

import humber.ca.project.dao.*;
import humber.ca.project.model.Claim;
import humber.ca.project.model.ClaimStatus;
import humber.ca.project.model.RegisteredProduct;
import humber.ca.project.model.User;
import humber.ca.project.utils.EmailUtil;
//import jakarta.servlet.RequestDispatcher;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/claims")
public class AdminClaimServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClaimDAO claimDAO;
    private RegisteredProductDAO rpDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        claimDAO = new ClaimDAOImpl();
        rpDAO = new RegisteredProductDAOImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        listClaims(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action.equals("updateStatus")) {
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

            // Send Email Notification
            System.out.println("Claim status updated successfully for ID " + claimId + ". Attempting email notification...");

            try {
                Optional<Claim> updateClaimOpt = claimDAO.findById(claimId);

                if (updateClaimOpt.isPresent()) {
                    Claim updatedClaim = updateClaimOpt.get();

                    Optional<RegisteredProduct> rpOpt = rpDAO.findByIdWithDetail(updatedClaim.getregisteredProductId());
                    if (rpOpt.isPresent()) {
                        RegisteredProduct rp = rpOpt.get();

                        Optional<User> userOpt = userDAO.findUserById(rp.getUserId());
                        if (userOpt.isPresent()) {
                            User user = userOpt.get();

                            sendClaimUpdateEmail(user, rp, updatedClaim);
                        } else {
                            System.out.println("Could not find user with ID " + rp.getUserId());
                        }
                    } else {
                        System.out.println("Could not find registered product with ID " + updatedClaim.getregisteredProductId());
                    }
                } else {
                    System.out.println("Could not find the claim with ID " + claimId);
                }
            } catch (Exception e) {
                System.out.println("Failed to send claim status update mail");
            }
        } else {
            message = "Failed+to+update+status+for+Claim+ID+" + claimId + ".+Claim+may+not+exist.";
        }

        // Redirect back to the list view with a feedback message
        response.sendRedirect("/admin/claims?message=" + message + "&messageType=" + messageType);
    }

    private void sendClaimUpdateEmail(User user, RegisteredProduct rp, Claim claim) {
        if (user == null || user.getEmail() == null || rp == null || rp.getProduct() == null || claim == null) {
            System.out.println("Missing required data");
            return;
        }

        String toEmail = user.getEmail();
        String subject = "Update from J2EE Group2 on your claim #" + claim.getId();
        String userName = user.getName();
        String productName = rp.getProduct().getProductName();
        String serialNumber = rp.getSerialNumber();
        String status = claim.getClaimStatus().name();

        // Construct email body (HTML recommended)
        StringBuilder body = new StringBuilder();
        body.append("<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>");
        body.append("<h2>Claim Status Update</h2>");
        body.append("<p>Dear ").append(userName).append(",</p>");
        body.append("<p>The status of your insurance claim (ID: <strong>").append(claim.getId()).append("</strong>) ");
        body.append("for your <strong>").append(productName).append("</strong> ");
        body.append("(Serial #: ").append(serialNumber).append(") has been updated to:</p>");
        body.append("<p style='font-size: 1.2em; font-weight: bold; color: #0056b3;'>").append(status).append("</p>");

        switch (claim.getClaimStatus()) {
            case Approved:
                body.append("<p>Your claim has been approved!</p>");
                break;
            case Rejected:
                body.append("<p>Unfortunately, your claim could not be approved at this time.</p>");
                break;
            case Processing:
                body.append("<p>Your claim is currently under review by our team.</p>");
                break;
            case Submitted:
                body.append("<p>We have received your claim submission. " +
                        "It will be assigned to an adjuster for review shortly.</p>");
                break;
        }

        body.append("<p>Thank you,<br/><strong>The ABC Insurance Team</strong></p>");
        body.append("</body></html>");
        boolean sent = EmailUtil.sendMail(toEmail, subject, body.toString());
        if (!sent) {
            System.out.println("EmailUtil failed to send claim update email to " + toEmail + " for claim ID " + claim.getId());
        } else {
            System.out.println("Claim update email sent successfully to " + toEmail + " for claim ID " + claim.getId());
        }
    }
}
