<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'ABC Insurance'} </title>

    <%-- Bootstrap CSS (CDN Link - requires internet access) --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <style>
        body {
            padding-top: 56px;
        }

        .content-wrapper {
            padding: 20px;
        }

        .footer {
            background-color: #f8f9fa;
            padding: 15px 0;
            margin-top: 30px;
            text-align: center;
            border-top: 1px solid #e7e7e7;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">ABC Insurance</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <%-- Common Links --%>
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/">Home</a>
                </li>

                <%-- User Specific Links --%>
                <c:if test="${not empty sessionScope.userId and sessionScope.userRole == Role.user}">
                    <li class="nav-item">
                        <a class="nav-link" href="/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/registerProduct">Register
                            Product</a>
                    </li>
                </c:if>

                <%-- Admin Specific Links --%>
                <c:if test="${not empty sessionScope.userId and sessionScope.userRole == Role.admin}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                           aria-expanded="false">
                            Admin Menu
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/admin/dashboard">Admin
                                Home</a></li>
                            <li><a class="dropdown-item" href="/admin/users">Manage
                                Users</a></li>
                            <li><a class="dropdown-item" href="/admin/products">Manage
                                Products</a></li>
                            <li><a class="dropdown-item" href="/admin/claims">Manage
                                Claims</a></li>
                            <li><a class="dropdown-item"
                                   href="/admin/registeredProducts">View
                                Registered</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="/admin/reports/all">All
                                User Report</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <%-- Login/Logout Button --%>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                               aria-expanded="false">
                                Welcome, <c:out value="${sessionScope.username}"/>!
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="/logout">Logout</a>
                                </li>
                                    <%-- Add profile link later? --%>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="/login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/register">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>

        </div>
    </div>
</nav>

<%-- Start of main page content area --%>
<div class="content-wrapper">