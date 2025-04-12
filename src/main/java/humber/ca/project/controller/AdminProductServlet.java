package humber.ca.project.controller;

import humber.ca.project.dao.ProductDAO;
import humber.ca.project.dao.ProductImpl;
import humber.ca.project.model.Product;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "list":
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("/admin/products");
        }

        switch (action) {
            case "create":
                createProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendRedirect("/admin/products");
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> products = productDAO.findAllProducts();
        request.setAttribute("productList", products);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/listProducts.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("product", null);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid Product ID");
            request.setAttribute("messageType", "error");
            listProducts(request, response);
            return;
        }

        Optional<Product> productOpt = productDAO.findProductById(id);

        if (productOpt.isPresent()) {
            request.setAttribute("product", productOpt.get());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("message", "Product with ID " + id + " not found.");
            request.setAttribute("messageType", "error");
            listProducts(request, response);
        }
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productName = request.getParameter("productName");
        String model = request.getParameter("model");
        String description = request.getParameter("description");

        //  Server-side validation
        List<String> errors = new ArrayList<>();
        if (productName == null || model == null || description == null) errors.add("All fields are required");
        else if (productName.length() > 100) errors.add("Product is too long (max 100)");

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("product", null);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Product newProduct = new Product();
        newProduct.setProductName(productName);
        newProduct.setModel(model);
        newProduct.setDescription(description);

        boolean success = productDAO.createProduct(newProduct);

        if (success) {
            response.sendRedirect("/admin/products?message=Product+added+successfully");
        } else {
            errors.add("Failed to add new product");
            request.setAttribute("errors", errors);
            request.setAttribute("product", null);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String productName = request.getParameter("productName");
        String model = request.getParameter("model");
        String description = request.getParameter("description");

        int id;

        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect("/admin/products?message=Error:+Invalid+product+ID+for+update");
            return;
        }

        //  Server-side validation
        List<String> errors = new ArrayList<>();
        if (productName == null || model == null || description == null) errors.add("All fields are required");
        else if (productName.length() > 100) errors.add("Product is too long (max 100)");

        Product productToUpdate = new Product(id, productName, model, description);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("product", productToUpdate);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
            dispatcher.forward(request, response);
            return;
        }

        boolean success = productDAO.updateProduct(productToUpdate);

        if (success) {
            response.sendRedirect("/admin/products?message=Product+updated+successfully");
        } else {
            errors.add("Failed to update product");
            request.setAttribute("errors", errors);
            request.setAttribute("product", productToUpdate);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editProduct.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        int id;
        String message;
        String messageType = "success";

        try {
            id = Integer.parseInt(idStr);
            boolean success = productDAO.deleteProduct(id);

            if (success) {
                message = "Product+deleted+successfully";
            } else {
                message = "Fail+to+delete";
                messageType = "error";
            }
        } catch (NumberFormatException | NullPointerException e) {
            message = "Invalid+product+id";
            messageType = "error";
        }
        response.sendRedirect("/admin/products?message=" + message + "&messageType=" + messageType);
    }
}
