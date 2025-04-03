package humber.ca.project.controller;

import humber.ca.project.dao.UserDAO;
import humber.ca.project.dao.UserDAOImpl;
import humber.ca.project.model.Role;
import humber.ca.project.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginError = null;

        if (username == null || password == null) {
            loginError = "Username and password are required";
        } else {
            // Find user by username
            Optional<User> userOptional = userDAO.findUserByUsernameAndPassword(username, password);

            if (userOptional.isPresent()) {
                User user = userOptional.get();
                // Login successfully
                // Create session scope
                HttpSession session = request.getSession(true);

                // Store user info in session
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());

                // Redirect to the user or admin dashboard
                if (user.getRole() == Role.admin) {
                    response.sendRedirect("/admin/dashboard.jsp");
                } else {
                    response.sendRedirect("/dashboard.jsp");
                }
                return;
            } else {
                // User not found
                loginError = "Invalid username or password";
            }
        }

        // If login failed
        if (loginError != null) {
            request.setAttribute("loginError", loginError); // Set error message for JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
