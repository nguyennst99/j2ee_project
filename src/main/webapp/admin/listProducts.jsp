<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Products</title>
    <link rel="stylesheet" type="text/css" href="/css/adminListProducts.css">
</head>
<body>

<%--<c:import url=""/> --%>

<div class="container" style="margin: 20px;">
    <h2>Manage Products</h2>

    <a href="/admin/products?action=add" class="add-product-btn">Add New Product</a>

    <%-- Display messages from redirect (e.g., success/error) --%>
    <c:if test="${not empty requestScope.message}">
        <div class="message ${requestScope.messageType}"><c:out value="${requestScope.message}"/></div>
    </c:if>

    <c:if test="${not empty param.message}"> <%-- Check param too --%>
        <div class="message success"><c:out value="${param.message}"/></div>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Product Name</th>
            <th>Model</th>
            <th>Description</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty productList}">
                <c:forEach var="product" items="${productList}">
                    <tr>
                        <td><c:out value="${product.id}"/></td>
                        <td><c:out value="${product.productName}"/></td>
                        <td><c:out value="${product.model}"/></td>
                        <td><c:out value="${product.description}"/></td>
                        <td class="actions">
                                <%-- Link to edit action in servlet --%>
                            <a href="/admin/products?action=edit&id=${product.id}"
                               class="edit-btn">Edit</a>
                                <%-- Form for delete action (POST is safer than GET for deletes) --%>
                            <form action="/admin/products?action=delete" method="post"
                                  style="display: inline;"
                                  onsubmit="return confirm('Are you sure you want to delete this product?');">
                                <input type="hidden" name="id" value="${product.id}">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5">No products found.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>