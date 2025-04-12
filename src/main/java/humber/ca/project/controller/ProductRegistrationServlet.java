package humber.ca.project.controller;

import humber.ca.project.dao.ProductDAO;
import humber.ca.project.dao.ProductImpl;
import humber.ca.project.dao.RegisteredProductDAO;
import humber.ca.project.dao.RegisteredProductDAOImpl;
import humber.ca.project.model.Product;
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

@WebServlet("/registerProduct")
public class ProductRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisteredProductDAO rpDao;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductImpl();
        rpDao = new RegisteredProductDAOImpl();
    }

    // Show the registration form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> productList = productDAO.findAllProducts();
        request.setAttribute("productList", productList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/registerProduct.jsp");
        dispatcher.forward(request, response);
    }

    // Process the form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check session (login status)
        HttpSession session =  request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("/login?error=nosession");
        }
        Integer userId = (Integer) session.getAttribute("userId");

        // Get parameters
        String productIdStr = request.getParameter("productId");
        String serialNumber = request.getParameter("serialNumber");
        String purchaseDateStr = request.getParameter("purchaseDate");

        // Validation
        List<String> errors = new ArrayList<>();
        int productId = 0;
        Date purchaseDate = null;

        if (productIdStr == null) {
            errors.add("Please select a product");
        } else {
            productId = Integer.parseInt(productIdStr);
        }

        if (serialNumber == null) {
            errors.add("Serial number is required.");
        } else if (serialNumber.length() > 50) {
            errors.add("Serial Number is too long (max 50 chars).");
        }

        if (purchaseDateStr == null) {
            errors.add("Purchase date is required.");
        } else {
            try {
                LocalDate localDate = LocalDate.parse(purchaseDateStr);
                if (localDate.isAfter(LocalDate.now())) {
                    errors.add("Purchase Date cannot be in the future.");
                } else {
                    purchaseDate = Date.valueOf(localDate);
                }
            } catch (DateTimeException e) {
                errors.add("Invalid purchase date format (YYYY-MM-DD)");
            }
        }

        // If error -> forward back to form
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            List<Product> productList =  productDAO.findAllProducts();

            request.setAttribute("productList", productList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/registerProduct.jsp");
            dispatcher.forward(request, response);
            return;
        }

        RegisteredProduct registeredProduct = new RegisteredProduct();
        registeredProduct.setUserId(userId);
        registeredProduct.setProductId(productId);
        registeredProduct.setSerialNumber(serialNumber);
        registeredProduct.setPurchaseDate(purchaseDate);

        boolean success = rpDao.registerProduct(registeredProduct);

        if (success) {
            response.sendRedirect("/dashboard?message=Product+registered+successfully");
        } else {
            errors.add("Failed to register product. This serial number might already be use registered");

            request.setAttribute("errors", errors);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/registerProduct.jsp");
            dispatcher.forward(request, response);
        }
    }
}
