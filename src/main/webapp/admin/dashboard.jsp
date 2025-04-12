<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required"/>
</c:if>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ABC Insurance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>

<%-- 1. Include Fixed Top Navbar --%>
<jsp:include page="/common/adminNavbar.jsp"/>

<%-- 2. Sidebar (Fixed for large screens) --%>
<div class="sidebar d-none d-lg-block">
    <jsp:include page="/common/adminSidebar.jsp"/>
</div>
<%-- Offcanvas Sidebar for small screens --%>
<div class="offcanvas offcanvas-start d-lg-none" tabindex="-1" id="offcanvasAdminSidebar"
     aria-labelledby="offcanvasAdminSidebarLabel" style="width: var(--sidebar-width);">
    <div class="offcanvas-header"><h5 class="offcanvas-title" id="offcanvasAdminSidebarLabel">Admin Menu</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <jsp:include page="/common/adminSidebar.jsp"/>
    </div>
</div>

<%-- 3. Main Content Area --%>
<main class="main-content-area">

    <%-- START: Specific content for admin/dashboard.jsp --%>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-1 pb-2 mb-3 border-bottom">
        <h1 class="h2">Admin Dashboard</h1>
    </div>
    <p>Welcome, Admin <c:out value="${sessionScope.username}"/>! Use the sidebar navigation to manage the
        application.</p>
    <hr>

    <div class="row mt-4">
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body"><h5 class="card-title">Users</h5>
                    <p class="card-text">View and manage user accounts.</p>
                    <a href="/admin/users" class="btn btn-secondary">Go to Users</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body"><h5 class="card-title">Products</h5>
                    <p class="card-text">Manage the product catalog.</p>
                    <a href="/admin/products" class="btn btn-secondary">Go to Products</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body"><h5 class="card-title">Claims</h5>
                    <p class="card-text">Review and update claim statuses.</p>
                    <a href="/admin/claims" class="btn btn-secondary">Go to Claims</a></div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body"><h5 class="card-title">Registrations</h5>
                    <p class="card-text">View all registered products.</p>
                    <a href="/admin/registeredProducts" class="btn btn-secondary">View Registrations</a></div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body"><h5 class="card-title">User Report</h5>
                    <p class="card-text">View comprehensive user report.</p>
                    <a href="/admin/reports/all" class="btn btn-secondary">View Report</a></div>
            </div>
        </div>
    </div>
    <%-- END: Specific content for admin/dashboard.jsp --%>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>

</body>
</html>