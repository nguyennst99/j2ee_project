<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=unauthorized"/></c:if>

<c:set var="pageTitle" value="Admin - Manage Products" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>Manage Products</h2>
    <hr>

    <a href="/admin/products?action=add" class="btn btn-primary mb-3">Add New Product</a>

    <c:if test="${not empty param.message}">
        <div class="alert ${param.messageType == 'error' ? 'alert-danger' : 'alert-success'}" role="alert">
            <c:out value="${param.message}"/>
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-sm">
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
                            <td>
                                <a href="/admin/products?action=edit&id=${product.id}" class="btn btn-warning btn-sm">Edit</a>
                                <form action="/admin/products?action=delete" method="post" style="display: inline;"
                                      onsubmit="return confirm('Delete product? This cannot be undone.');">
                                    <input type="hidden" name="id"
                                           value="${product.id}"> <%-- Ensure name matches servlet param --%>
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="text-center text-muted">No products found.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>