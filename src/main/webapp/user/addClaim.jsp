<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<c:set var="pageTitle" value="Add Claim" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Add Claim</li>
                </ol>
            </nav>

            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h2 class="card-title text-center mb-4">Add New Claim</h2>

                    <c:if test="${not empty registeredProduct}">
                        <div class="alert alert-secondary">
                            <h5 class="alert-heading">For Product:</h5>
                            <p class="mb-1"><strong>Name:</strong> <c:out
                                    value="${registeredProduct.product.productName}"/></p>
                            <p class="mb-1"><strong>Model:</strong> <c:out value="${registeredProduct.product.model}"/>
                            </p>
                            <p class="mb-1"><strong>Serial #:</strong> <c:out
                                    value="${registeredProduct.serialNumber}"/></p>
                            <p class="mb-0"><strong>Purchase Date:</strong> <fmt:formatDate
                                    value="${registeredProduct.purchaseDate}" pattern="yyyy-MM-dd"/></p>
                        </div>
                    </c:if>

                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger" role="alert">
                            <strong>Please correct errors:</strong>
                            <ul><c:forEach var="error" items="${errors}">
                                <li><c:out value="${error}"/></li>
                            </c:forEach></ul>
                        </div>
                    </c:if>

                    <form action="/addClaim" method="post">
                        <%-- Use ID from registeredProduct object set by servlet --%>
                        <input type="hidden" name="registeredProductId"
                               value="<c:out value='${registeredProduct.id}'/>">

                        <div class="mb-3">
                            <label for="dateOfClaim" class="form-label">Date of Incident/Claim:</label>
                            <input type="date" class="form-control" id="dateOfClaim" name="dateOfClaim"
                                   value="<c:out value='${param.dateOfClaim}'/>" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description of Incident/Issue:</label>
                            <textarea class="form-control" id="description" name="description" rows="5" required><c:out
                                    value='${param.description}'/></textarea>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">Submit Claim</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>