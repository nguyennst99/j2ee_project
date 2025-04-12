<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top shadow-sm py-2" style="height: var(--navbar-height);">
    <div class="container-fluid">
        <%-- Button to toggle offcanvas sidebar on small screens --%>
        <button class="navbar-toggler navbar-toggler-admin me-2" type="button" data-bs-toggle="offcanvas"
                data-bs-target="#offcanvasAdminSidebar" aria-controls="offcanvasAdminSidebar"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <%-- Brand link (points to site home or admin home) --%>
        <a class="navbar-brand me-auto" href="/admin/dashboard">ABC Insurance [Admin]</a>

        <%-- User info and Logout link --%>
        <div class="text-light">
            <c:if test="${not empty sessionScope.username}">
                Logged in as: <c:out value="${sessionScope.username}"/> |
                <a href="/logout" class="text-warning text-decoration-none">Logout</a>
            </c:if>
            <c:if test="${empty sessionScope.username}">
                <a href="/login" class="text-warning text-decoration-none">Login Required</a>
            </c:if>
        </div>
    </div>
</nav>