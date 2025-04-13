package humber.ca.project.controller;

import humber.ca.project.dao.UserDAO;
import humber.ca.project.dao.UserDAOImpl;
import humber.ca.project.model.Role;
import humber.ca.project.model.User;
import org.mindrot.jbcrypt.BCrypt;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
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
            Optional<User> userOptional = userDAO.findUserByUsername(username);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                String hashedPassword = user.getPassword();
                // Verify password
                if (BCrypt.checkpw(password, hashedPassword)) {
                    // Login successfully
                    // Create session scope
                    HttpSession session = request.getSession(true);

                    // Store user info in session
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("userRole", user.getRole());

                    // Redirect to the user or admin dashboard
                    if (user.getRole() == Role.admin) {
                        response.sendRedirect("/admin/dashboard");
                    } else {
                        response.sendRedirect("/dashboard");
                    }
                    return;
                } else {
                    // User not found
                    loginError = "Invalid username or password";
                }
            } else {
                // User not found
                loginError = "Invalid username or password";
            }
        }


        if (loginError != null) {
            request.setAttribute("loginError", loginError); // Set error message for JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}