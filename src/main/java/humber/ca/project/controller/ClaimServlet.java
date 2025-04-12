package humber.ca.project.controller;

import humber.ca.project.dao.ClaimDAO;
import humber.ca.project.dao.ClaimDAOImpl;
import humber.ca.project.dao.RegisteredProductDAO;
import humber.ca.project.dao.RegisteredProductDAOImpl;
import humber.ca.project.model.Claim;
import humber.ca.project.model.ClaimStatus;
import humber.ca.project.model.RegisteredProduct;
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
import java.sql.Date;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/addClaim")
public class ClaimServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClaimDAO claimDAO;
    private RegisteredProductDAO rpDAO;

    @Override
    public void init() throws ServletException {
        claimDAO = new ClaimDAOImpl();
        rpDAO = new RegisteredProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rpIdStr = request.getParameter("regId");
        if (rpIdStr == null) {
            response.sendRedirect("/dashboard?error=Missing+product+ID+for+claim");
            return;
        }

        try {
            int rpId = Integer.parseInt(rpIdStr);
            // Fetch product details to display on the claim form
            Optional<RegisteredProduct> rpOpt = rpDAO.findByIdWithDetail(rpId);
            if (rpOpt.isPresent()) {
                // pass it to jsp
                request.setAttribute("registeredProduct", rpOpt.get());
            } else {
                System.out.println("Registered product not found.");
            }

            request.setAttribute("regId", rpId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/addClaim.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("/dashboard?error=Invalid+product+ID+format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Check session of a user
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("/login?error=no+session");
            return;
        }
        Integer currentUserId = (Integer) session.getAttribute("userId");

        // 2. Get parameter
        String regIdStr = request.getParameter("registeredProductId");
        String dateOfClaimStr = request.getParameter("dateOfClaim");
        String description = request.getParameter("description");

        List<String> errors = new ArrayList<>();
        int registeredProductId = -1;
        Date dateOfClaim = null;
        Date purchaseDate = null;

        // 3. Fetch Product info
        try {
            registeredProductId = Integer.parseInt(regIdStr);
            // 3.1 Fetch the registered product
            Optional<RegisteredProduct> rpOpt = rpDAO.findByIdWithDetail(registeredProductId);
            if (rpOpt.isPresent()) {
                RegisteredProduct rp = rpOpt.get();
                // 3.2 Check: does this product belong to the logged-in user?
                if (rp.getUserId() != currentUserId) {
                    errors.add("Authorization: You cannot submit a claim for this product");
                } else {
                    // 3.3 User owns this product, get the purchase date
                    purchaseDate = rp.getPurchaseDate();
                    // 3.4 Pass the registered product to JSP view
                    request.setAttribute("registeredProduct", rp);
                }
            } else {
                errors.add("Invalid Registered Product ID. Cannot submit claim.");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid Registered Product ID format");
        }

        // 4. Validate date of claim and description
        if (dateOfClaimStr == null) {
            errors.add("Date of claim is required");
        } else {
            try {
                LocalDate localDate = LocalDate.parse(dateOfClaimStr);
                if (localDate.isAfter(LocalDate.now())) {
                    errors.add("Date of Claim cannot be in the future");
                } else {
                    dateOfClaim = Date.valueOf(dateOfClaimStr);
                }
            } catch (DateTimeException e) {
                System.out.println("Date time exception parsing a date of claim: " + e.getMessage());
            }
        }

        if (description == null || description.trim().isEmpty()) {
            errors.add("Description is required.");
        }

        // 5. Business logic
        if (errors.isEmpty() && purchaseDate != null && dateOfClaim != null) {
            LocalDate purchaseLocalDate = purchaseDate.toLocalDate();
            LocalDate claimLocalDate = dateOfClaim.toLocalDate();
            LocalDate fiveYearsAfterPurchase = purchaseLocalDate.plusYears(5);


            // 5.1. The claim must be on or after purchase date, BEFORE 5 years after
            if (claimLocalDate.isBefore(purchaseLocalDate) || !claimLocalDate.isBefore(fiveYearsAfterPurchase)) {
                errors.add("Claim date must be within 5 years of the product purchase date " +
                        "(" + purchaseLocalDate + " to " + fiveYearsAfterPurchase.minusDays(1) + ").");
            } else {
                // 5.2. Check the number of claim
                int existingClaimCount = claimDAO.countClaimsInWindow(registeredProductId, purchaseDate);

                if (existingClaimCount < 0) {
                    errors.add("Could not verify existing claim count. Please try again");
                } else if (existingClaimCount >= 3) {
                    errors.add("Maximum claim limit (3) reached for this product.");
                }
            }
        }

        // 6. If errors exist, forward back to form
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            if (request.getAttribute("registeredProduct") == null && registeredProductId > 0) {

                Optional<RegisteredProduct> rpOptRetry = rpDAO.findByIdWithDetail(registeredProductId);

                if (rpOptRetry.isPresent()) {
                    request.setAttribute("registeredProduct", rpOptRetry.get());
                } else {
                    System.out.println("Error: Could not re-fetch product details for ID: " + registeredProductId + " on validation error path.");
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/addClaim.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // 7. All check pass - Create and save the claim
        Claim newClaim = new Claim();
        newClaim.setregisteredProductId(registeredProductId);
        newClaim.setDateOfClaim(dateOfClaim);
        newClaim.setDescription(description);
        newClaim.setClaimStatus(ClaimStatus.Submitted);

        boolean success = claimDAO.createClaim(newClaim);

        if (success) {
            response.sendRedirect("/dashboard?message=Claim+submitted+successfully!");
        } else {
            errors.add("Failed to submit claim");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/addClaim.jsp");
            dispatcher.forward(request, response);
        }
    }
}
