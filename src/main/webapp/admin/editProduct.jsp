<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=unauthorized"/></c:if>

<c:set var="pageTitle" value="${not empty product ? 'Edit' : 'Add'} Product" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>${not empty product ? 'Edit' : 'Add New'} Product</h2>
    <hr>

    <c:if test="${not empty errors}">
        <div class="alert alert-danger">
            <strong>Please correct errors:</strong>
            <ul><c:forEach var="error" items="${errors}">
                <li><c:out value="${error}"/></li>
            </c:forEach></ul>
        </div>
    </c:if>

    <form action="/admin/products" method="post" class="col-md-8">
        <c:if test="${not empty product}"><input type="hidden" name="action" value="update"><input type="hidden"
                                                                                                   name="id"
                                                                                                   value="<c:out value='${product.id}'/>"></c:if>
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
</div>

<jsp:include page="/common/footer.jsp"/>