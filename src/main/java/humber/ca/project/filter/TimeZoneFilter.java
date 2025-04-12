package humber.ca.project.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.TimeZone;

@WebFilter(urlPatterns = {"/dashboard", "/my-claims", "/admin/*"})
public class TimeZoneFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String serverTimeZoneId = TimeZone.getDefault().getID();
        httpRequest.setAttribute("serverTimeZoneId", serverTimeZoneId);
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
