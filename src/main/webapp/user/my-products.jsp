<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized" />
</c:if>

<c:set var="pageTitle" value="My Registered Products" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Products</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h2">My Registered Products</h1>
        <a href="/registerProduct" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Register New Product
        </a>
    </div>
    <hr>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-bordered">
            <thead class="table-light">
            <tr>
                <th scope="col">Product Name</th>
                <th scope="col">Model</th>
                <th scope="col">Serial Number</th>
                <th scope="col">Purchase Date</th>
                <th scope="col">Claims Made</th>
                <th scope="col">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty registeredProducts}">
                    <c:forEach var="rp" items="${registeredProducts}">
                        <%-- Get the claim count for this specific product from the map --%>
                        <c:set var="claimCount" value="${claimCountsMap[rp.id] != null ? claimCountsMap[rp.id] : 0}" />
                        <%-- Set a flag for disabling the button --%>
                        <c:set var="maxClaimsReached" value="${claimCount >= 3}" />

                        <tr>
                            <td><c:out value="${rp.product.productName}"/></td>
                            <td><c:out value="${rp.product.model}"/></td>
                            <td><c:out value="${rp.serialNumber}"/></td>
                            <td><fmt:formatDate value="${rp.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                    <%-- Display the claim count --%>
                                <c:out value="${claimCount}"/> / 3
                                <c:if test="${maxClaimsReached}">
                                    <span class="badge bg-danger ms-1">Limit Reached</span>
                                </c:if>
                            </td>
                            <td>
                                    <%-- Conditionally disable the Add Claim button --%>
                                <a href="/addClaim?regId=${rp.id}"
                                   class="btn btn-warning btn-sm ${maxClaimsReached ? 'disabled' : ''}"
                                    ${maxClaimsReached ? 'aria-disabled="true" tabindex="-1"' : ''}
                                   title="${maxClaimsReached ? 'Maximum claims (3) reached for this product' : 'Submit a new claim for this product'}">
                                    <i class="bi bi-journal-plus"></i> Add Claim
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" class="text-center text-muted fst-italic py-3">
                            You have not registered any products yet.
                            <a href="/registerProduct">Register one now!</a>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <p class="text-muted small mt-2">
        Note: Claims can only be made within 5 years of the purchase date and are limited to 3 per product.
    </p>
</div>

<jsp:include page="/common/footer.jsp"/>