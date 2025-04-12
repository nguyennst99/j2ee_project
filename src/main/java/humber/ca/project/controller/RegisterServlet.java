package humber.ca.project.controller;


import humber.ca.project.dao.UserDAO;
import humber.ca.project.dao.UserDAOImpl;
import humber.ca.project.model.Role;
import humber.ca.project.model.User;
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
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("register.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String cellphone = request.getParameter("cellphone");
        String name = request.getParameter("name");
        String address = request.getParameter("address");

        // Server-side validation
        List<String> errors = validateUserInput(username, email, password, confirmPassword, cellphone, name, address);

        // If validation errors, forward back
        if (!errors.isEmpty()) {
            repopulateFormOnError(request, username, email, cellphone, name, address);
            request.setAttribute("errors", errors);
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Process registration if validation passes
        try {
            // Check if username already exists (optional but good UX)
            if (userDAO.findUserByUsername(username.trim()).isPresent()) {
                errors.add("Username already taken. Please choose another.");
            }

            if (userDAO.findUserByEmail(email.trim()).isPresent()) {
                errors.add("Email already taken. Please choose another.");
            }

            if (!errors.isEmpty()) {
                repopulateFormOnError(request, username, email, cellphone, name, address);
                request.setAttribute("errors", errors);
                RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Create User object
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setPassword(password.trim());
            newUser.setEmail(email.trim());
            newUser.setCellphone(cellphone.trim());
            newUser.setName(name.trim());
            newUser.setAddress(address.trim());
            newUser.setRole(Role.user);

            // Attempt to create user
            boolean success = userDAO.createUser(newUser);

            if (success) {
                // Success: Redirect to login page with success message
                response.sendRedirect("/login?registration=success");
            } else {
                // Failure
                errors.add("Registration failed.");
                repopulateFormOnError(request, username, email, cellphone, name, address);
                request.setAttribute("errors", errors);
                RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Unexpected error during registration: " + e.getMessage());
            errors.add("An unexpected error occurred. Please try again later.");
            repopulateFormOnError(request, username, email, cellphone, name, address);
            request.setAttribute("errors", errors);
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Performs validation checks on user registration input.
     * @return List of error messages. Empty list if validation passes.
     */
    private List<String> validateUserInput(String username, String email, String password, String confirmPassword, String cellphone, String name, String address) {
        List<String> errors = new ArrayList<>();

        // Username checks
        if (username == null || username.trim().isEmpty()) {
            errors.add("Username is required.");
        } else if (username.trim().length() > 15) { // Max length from the schema
            errors.add("Username cannot exceed 15 characters.");
        } else if (username.trim().length() < 4) { // Example minimum length
            errors.add("Username must be at least 4 characters long.");
        }

        // Email checks
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email is required.");
        } else if (email.trim().length() > 100) {
            errors.add("Email is too long.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.add("Invalid email format.");
        }

        // Password checks
        if (password == null || password.isEmpty()) {
            errors.add("Password is required.");
        } else if (password.length() < 5) {
            errors.add("Password must be at least 5 characters long.");
        }
        if (!password.equals(confirmPassword)) {
            errors.add("Passwords do not match.");
        }

        // Cellphone checks
        if (cellphone == null || cellphone.trim().isEmpty()) {
            errors.add("Cellphone number is required.");
        } else if (cellphone.trim().length() > 12) { // Max length from the schema
            errors.add("Cellphone number is too long.");
        }

        // Name checks
        if (name == null || name.trim().isEmpty()) {
            errors.add("Name is required.");
        } else if (name.trim().length() > 50) { // Max length from the schema
            errors.add("Name cannot exceed 30 characters.");
        }

        // Address checks
        if (address == null || address.trim().isEmpty()) {
            errors.add("Address is required.");
        } else if (address.trim().length() > 100) { // Max length from the schema
            errors.add("Address cannot exceed 50 characters.");
        }

        return errors;
    }

    /**
     * Helper method to repopulate form fields in request scope on validation errors.
     */
    private void repopulateFormOnError(HttpServletRequest request, String username, String email, String cellphone, String name, String address) {
        request.setAttribute("usernameValue", username != null ? username : "");
        request.setAttribute("emailValue", email != null ? email : "");
        request.setAttribute("cellphoneValue", cellphone != null ? cellphone : "");
        request.setAttribute("nameValue", name != null ? name : "");
        request.setAttribute("addressValue", address != null ? address : "");
    }


}
