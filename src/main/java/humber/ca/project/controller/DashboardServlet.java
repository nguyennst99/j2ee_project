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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisteredProductDAO rpDao;
    private ClaimDAO claimDAO;

    @Override
    public void init() throws ServletException {
        rpDao = new RegisteredProductDAOImpl();
        claimDAO = new ClaimDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do not create if no session

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("/login?error=nosession");
            return;
        }
        Integer userId = (Integer) session.getAttribute("userId");

        // Fetch Registered Product
        List<RegisteredProduct> rpList = rpDao.findByUserId(userId);
        request.setAttribute("registeredProducts", rpList);

        // Fetch Claims for each Product
        Map<Integer, List<Claim>> claimsMap = new HashMap<>(); // Map: registeredProductID -> List<Claim>
        if (rpList != null) {
            for (RegisteredProduct rp : rpList) {
                List<Claim> productClaims = claimDAO.findByRegisteredProductId(rp.getId());
                if (productClaims != null && !productClaims.isEmpty()) {
                    claimsMap.put(rp.getId(), productClaims);
                }
            }
        }

        request.setAttribute("claimsMap", claimsMap);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
