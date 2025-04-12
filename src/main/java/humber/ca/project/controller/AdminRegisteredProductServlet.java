package humber.ca.project.controller;

import humber.ca.project.dao.RegisteredProductDAO;
import humber.ca.project.dao.RegisteredProductDAOImpl;
import humber.ca.project.model.RegisteredProduct;
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

@WebServlet("/admin/registeredProducts")
public class AdminRegisteredProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisteredProductDAO rpDAO;

    @Override
    public void init() throws ServletException {
        rpDAO = new RegisteredProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        List<RegisteredProduct> rpList;

        if (searchTerm != null) {
            rpList = rpDAO.searchRegisteredProducts(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
        } else {
            rpList = rpDAO.searchRegisteredProducts("");
        }

        request.setAttribute("registeredProductList", rpList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/listRegisteredProducts.jsp");
        dispatcher.forward(request, response);
    }
}
