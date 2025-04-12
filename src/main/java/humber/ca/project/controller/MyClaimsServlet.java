package humber.ca.project.controller;

import humber.ca.project.dao.ClaimDAO;
import humber.ca.project.dao.ClaimDAOImpl;
import humber.ca.project.dao.RegisteredProductDAO;
import humber.ca.project.dao.RegisteredProductDAOImpl;
import humber.ca.project.model.Claim;
import humber.ca.project.model.RegisteredProduct;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/my-claims")
public class MyClaimsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClaimDAO claimDAO;
    private RegisteredProductDAO registeredProductDAO; // Need this to get product info

    @Override
    public void init() {
        claimDAO = new ClaimDAOImpl();
        registeredProductDAO = new RegisteredProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=nosession");
            return;
        }
        Integer userId = (Integer) session.getAttribute("userId");

        // 1. Fetch all registered products for the user (includes Product details)
        List<RegisteredProduct> userProducts = registeredProductDAO.findByUserId(userId);

        // 2. Create a list to hold all claims for this user
        List<Claim> allUserClaims = new ArrayList<>();

        // 3. Create a map to easily look up product details by registeredProductId
        Map<Integer, RegisteredProduct> productMap = new HashMap<>();

        // 4. Fetch claims for each registered product
        if (userProducts != null && !userProducts.isEmpty()) {
            for (RegisteredProduct rp : userProducts) {
                productMap.put(rp.getId(), rp); // Store product details for lookup
                List<Claim> claimsForProduct = claimDAO.findByRegisteredProductId(rp.getId());
                if (claimsForProduct != null) {
                    allUserClaims.addAll(claimsForProduct); // Add claims to the main list
                }
            }
        }

        // Optional: Sort all claims by date (most recent first)
        allUserClaims.sort((c1, c2) -> c2.getCreatedAt().compareTo(c1.getCreatedAt())); // Sort by creation time desc

        // 5. Set attributes for the JSP
        request.setAttribute("allUserClaims", allUserClaims);
        request.setAttribute("productMap", productMap); // Pass map for looking up product details in JSP

        // 6. Forward to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/my-claims.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle potential POST actions later (like filtering claims)
        doGet(request, response);
    }
}