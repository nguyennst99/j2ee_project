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
        <h1 class="h2">${not empty product ? 'Edit' : 'Add New'} Product</h1>
    </div>

    <c:if test="${not empty errors}">
        <div class="alert alert-danger">
            <strong>Please correct errors:</strong>
            <ul><c:forEach var="error" items="${errors}">
                <li><c:out value="${error}"/></li>
            </c:forEach></ul>
        </div>
    </c:if>

    <form action="/admin/products" method="post" class="col-md-8 col-lg-7">
        <c:if test="${not empty product}"><input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<c:out value='${product.id}'/>"></c:if>
        <c:if test="${empty product}"><input type="hidden" name="action" value="create"></c:if>

        <div class="mb-3">
            <label for="productName" class="form-label">Product Name:</label>
            <input type="text" class="form-control" id="productName" name="productName"
                   value="<c:out value='${not empty param.productName ? param.productName : product.productName}'/>"
                   required maxlength="100">
        </div>
        <div class="mb-3">
            <label for="model" class="form-label">Model:</label>
            <input type="text" class="form-control" id="model" name="model"
                   value="<c:out value='${not empty param.model ? param.model : product.model}'/>" maxlength="50">
        </div>
        <div class="mb-3">
            <label for="description" class="form-label">Description:</label>
            <textarea class="form-control" id="description" name="description" rows="4"><c:out
                    value='${not empty param.description ? param.description : product.description}'/></textarea>
        </div>
        <div class="mt-4">
            <button type="submit" class="btn btn-primary">${not empty product ? 'Update' : 'Add'} Product</button>
            <a href="/admin/products" class="btn btn-secondary ms-2">Cancel</a>
        </div>
    </form>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>
</body>
</html>