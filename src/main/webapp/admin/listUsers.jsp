<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Admin | ABC</title>

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

    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-1 pb-2 mb-3 border-bottom">
        <h1 class="h2">Manage Users</h1>
    </div>

    <form action="/admin/users" method="get" class="row g-3 align-items-center mb-4">
        <div class="col-sm-8 col-md-6 col-lg-5"><label for="searchTerm" class="visually-hidden">Search</label>
            <input type="text" class="form-control form-control-sm" id="searchTerm" name="searchTerm"
                   placeholder="Search by username, email, name..." value="<c:out value='${searchTerm}'/>"></div>
        <div class="col-auto">
            <button type="submit" class="btn btn-secondary btn-sm">Search</button>
        </div>
        <div class="col-auto"><a href="/admin/users" class="btn btn-outline-secondary btn-sm">Clear Search</a></div>
    </form>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-sm align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Name</th>
                <th>Cellphone</th>
                <th>Address</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty userList}">
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td><c:out value="${user.id}"/></td>
                            <td><c:out value="${user.username}"/></td>
                            <td><c:out value="${user.email}"/></td>
                            <td><c:out value="${user.name}"/></td>
                            <td><c:out value="${user.cellphone}"/></td>
                            <td><c:out value="${user.address}"/></td>
                            <td><span class="badge bg-${user.role == Role.admin ? 'primary' : 'secondary'}">
                                <c:out value="${user.role}"/></span></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" class="text-center text-muted fst-italic py-3">No users found<c:if
                                test="${not empty searchTerm}"> matching search</c:if>.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>
</body>
</html>