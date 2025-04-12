package humber.ca.project.controller;

import humber.ca.project.dao.ClaimDAO;
import humber.ca.project.dao.ClaimDAOImpl;
import humber.ca.project.dao.RegisteredProductDAO;
import humber.ca.project.dao.RegisteredProductDAOImpl;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/my-products") // Maps requests for this page
public class MyProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisteredProductDAO registeredProductDAO;
    private ClaimDAO claimDAO;

    @Override
    public void init() {
        registeredProductDAO = new RegisteredProductDAOImpl();
        claimDAO = new ClaimDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("/login?error=nosession");
            return;
        }
        Integer userId = (Integer) session.getAttribute("userId");

        // Fetch the list of registered products for this user
        // The findByUserId method already joins Product details
        List<RegisteredProduct> userProducts = registeredProductDAO.findByUserId(userId);
        Map<Integer, Integer> claimCountsMap = new HashMap<>();

        if (userProducts != null) {
            for (RegisteredProduct rp : userProducts) {
                if (rp.getPurchaseDate() != null) {
                    int count = claimDAO.countClaimsInWindow(rp.getId(), rp.getPurchaseDate());
                    claimCountsMap.put(rp.getId(), count);
                } else {
                    claimCountsMap.put(rp.getId(), 0);
                    System.out.println("Purchase date is null for RegisteredProduct ID: " + rp.getId());
                }
            }
        }

        // Set the list as a request attribute
        request.setAttribute("registeredProducts", userProducts);
        request.setAttribute("claimCountsMap", claimCountsMap);
        // Forward to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/my-products.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}