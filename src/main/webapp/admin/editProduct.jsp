<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <%-- Set title based on whether we are adding or editing --%>
    <title>Admin - ${not empty product ? 'Edit' : 'Add'} Product</title>
    <link rel="stylesheet" type="text/css" href="/css/adminEditProduct.css">
    <style>

    </style>
</head>
<body>
<%--<c:import url="/WEB-INF/views/common/adminHeader.jsp"/>--%>

<div class="form-container">
    <h2>${not empty product ? 'Edit' : 'Add New'} Product</h2>

    <%-- Display validation errors if any --%>
    <c:if test="${not empty errors}">
        <div class="error-message">
            <strong>Please correct the following errors:</strong><br/>
            <ul>
                <c:forEach var="error" items="${errors}">
                    <li><c:out value="${error}"/></li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <%-- Form posts to the AdminProductServlet --%>
    <form action="/admin/products" method="post">

        <%-- Include hidden fields for action and product ID (if editing) --%>
        <c:if test="${not empty product}">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<c:out value='${product.id}'/>">
        </c:if>

        <c:if test="${empty product}">
            <input type="hidden" name="action" value="create">
        </c:if>

        <div>
            <label for="productName">Product Name:</label>
            <%-- Pre-fill value if editing, use request scope value if validation failed --%>
            <input type="text" id="productName" name="productName"
                   value="<c:out value='${not empty param.productName ? param.productName : product.productName}'/>"
                   required maxlength="100">
        </div>

        <div>
            <label for="model">Model:</label>
            <input type="text" id="model" name="model"
                   value="<c:out value='${not empty param.model ? param.model : product.model}'/>" maxlength="50">
        </div>

        <div>
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4"><c:out
                    value='${not empty param.description ? param.description : product.description}'/></textarea>
        </div>

        <div>
            <button type="submit">${not empty product ? 'Update' : 'Add'} Product</button>
            <a href="/admin/products" style="margin-left: 10px;">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>