package humber.ca.project.filter;

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
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    // Define paths that do not require authentication
    private final Set<String> publicPaths = new HashSet<>(Arrays.asList(
            "/login",
            "/register",
            "/index.jsp",
            "/"
    ));

    private final String[] publicPrefixes = {"/css", "/js", "/images"};

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        HttpSession session = httpServletRequest.getSession(false);

        String requestURI = httpServletRequest.getRequestURI();
        String contextPath = httpServletRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        boolean isPublicPath = publicPaths.contains(path);

        boolean isPublicResource = false;
        for (String pre : publicPrefixes) {
            if (path.startsWith(pre)) {
                isPublicResource = true;
                break;
            }
        }


        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (loggedIn || isPublicPath || isPublicResource) {
            // User is logged in OR the path is public - allow request to proceed
            chain.doFilter(httpServletRequest, httpServletResponse);
        } else {
            // Protected request AND user is NOT logged in - redirect to login page
            httpServletResponse.sendRedirect("/login.jsp");
        }
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
