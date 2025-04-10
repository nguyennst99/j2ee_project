<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Optional: Add a visual separator or secondary header --%>
<div class="py-2 mb-3 border-bottom bg-light">
    <div class="container d-flex flex-wrap justify-content-center">
        <span class="fs-5">Admin Panel Navigation</span>
    </div>
</div>

<div class="container mb-4"> <%-- Wrap nav in container for alignment --%>
    <ul class="nav nav-pills justify-content-center">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath == '/admin/dashboard' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/dashboard">Admin Home</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath == '/admin/users' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath == '/admin/products' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/products">Manage Products</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.contextPath.endsWith('/admin/registeredProducts') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/registeredProducts">View Registered</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath == '/admin/claims' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/claims">Manage Claims</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.servletPath == '/admin/reports/all' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/reports/all">All User Report</a>
        </li>
        <%-- Add other admin links as needed --%>
    </ul>
</div>
<hr class="mb-4">

<%-- The main content of the specific admin page will follow this include --%>