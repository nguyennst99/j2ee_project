<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized" />
</c:if>

<c:set var="pageTitle" value="Register Product" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Register Product</li>
                </ol>
            </nav>
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h2 class="card-title text-center mb-4">Register Your Product</h2>

                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger" role="alert">
                            <strong>Please correct errors:</strong>
                            <ul><c:forEach var="error" items="${errors}">
                                <li><c:out value="${error}"/></li>
                            </c:forEach></ul>
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert"><c:out value="${successMessage}"/></div>
                    </c:if>

                    <form action="/registerProduct" method="post">
                        <div class="mb-3">
                            <label for="productId" class="form-label">Product Name:</label>
                            <select class="form-select" id="productId" name="productId" required>
                                <option value="">-- Select Product --</option>
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product.id}" ${param.productId == product.id ? 'selected' : ''}>
                                        <c:out value="${product.productName}"/> (<c:out value="${product.model}"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="serialNumber" class="form-label">Serial Number:</label>
                            <input type="text" class="form-control" id="serialNumber" name="serialNumber"
                                   value="<c:out value='${param.serialNumber}'/>" required maxlength="50">
                        </div>
                        <div class="mb-3">
                            <label for="purchaseDate" class="form-label">Purchase Date:</label>
                            <input type="date" class="form-control" id="purchaseDate" name="purchaseDate"
                                   value="<c:out value='${param.purchaseDate}'/>" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">Register Product</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>