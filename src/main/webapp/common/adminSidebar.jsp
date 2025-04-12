<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .admin-sidebar-nav .nav-link {
        border-radius: .25rem;
        padding: .65rem 1rem;
        margin: 0 .5rem .1rem .5rem;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
        color: #343a40;
        font-weight: 500;
    }

    .admin-sidebar-nav .nav-link:hover, .admin-sidebar-nav .nav-link:focus {
        background-color: #e9ecef;
        color: #000;
    }

    .admin-sidebar-nav .nav-link.active {
        background-color: #e8f0fe;
        color: #1967d2 !important;
        font-weight: 700;
    }

    .admin-sidebar-nav .nav-link .bi {
        width: 1.25em;
        font-size: 1.1rem;
        vertical-align: text-bottom;
        margin-right: 0.5rem;
        color: #6c757d;
    }

    .admin-sidebar-nav .nav-link.active .bi {
        color: #1967d2;
    }

    .sidebar-header {
        padding: 1rem 1rem 0.5rem 1rem;
    }

    .sidebar-footer {
        padding: 1rem;
        margin-top: auto;
    }

    /* Pushes footer down in flex column */
</style>

<%-- Sidebar Content Structure (Flex column to push footer down) --%>
<%-- The outer positioning div is now removed from here and placed in each admin page --%>
<div class="d-flex flex-column h-100">
    <div class="sidebar-header">
        <a href="/admin/dashboard"
           class="d-flex align-items-center link-dark text-decoration-none">
            <i class="bi bi-shield-lock fs-4 me-2"></i>
            <span class="fs-5 fw-semibold">Admin Panel</span>
        </a>
    </div>
    <hr class="mt-2 mb-2">

    <ul class="nav nav-pills flex-column mb-auto admin-sidebar-nav pt-1">
        <li class="nav-item"><a href="/admin/dashboard"
                                class="nav-link ${pageContext.request.servletPath == '/admin/dashboard.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-house-door"></i> Dashboard </a></li>
        <li><a href="/admin/users"
               class="nav-link ${pageContext.request.servletPath == '/admin/listUsers.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-people"></i> Manage Users </a></li>
        <li><a href="/admin/products"
               class="nav-link ${pageContext.request.servletPath == '/admin/listProducts.jsp' || pageContext.request.servletPath == '/admin/editProduct.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-box-seam"></i> Manage Products </a></li>
        <li><a href="/admin/registeredProducts"
               class="nav-link ${pageContext.request.servletPath == '/admin/listRegisteredProducts.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-card-list"></i> View Registered </a></li>
        <li><a href="/admin/claims"
               class="nav-link ${pageContext.request.servletPath == '/admin/listClaims.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-clipboard-check"></i> Manage Claims </a></li>
        <li><a href="/admin/reports/all"
               class="nav-link ${pageContext.request.servletPath == '/admin/reportAll.jsp' ? 'active' : 'link-dark'}">
            <i class="bi bi-file-earmark-text"></i> User Report </a></li>
    </ul>

    <div class="sidebar-footer">
        <hr>
        <div class="dropdown">
            <a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle"
               data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle me-2"></i>
                <strong><c:out value="${sessionScope.username}"/></strong>
            </a>
            <ul class="dropdown-menu text-small shadow">
                <li><a class="dropdown-item" href="/logout">Sign out</a></li>
            </ul>
        </div>
    </div>
</div>