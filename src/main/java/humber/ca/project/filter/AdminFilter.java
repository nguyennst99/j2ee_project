package humber.ca.project.filter;

import humber.ca.project.model.Role;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isAdmin = false;
        if (session != null) {
            Object userRole = session.getAttribute("userRole");
            if (userRole == Role.admin) {
                isAdmin = true;
            }
        }

        if (isAdmin) {
            chain.doFilter(request, response);
        } else {
            // User is not an admin (or not logged in)
            System.out.println("AdminFilter: Access denied. Redirecting to login.");
            // Redirect to login page, with an "unauthorized" error
            httpResponse.sendRedirect("/login?error=admin_required");
        }
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
