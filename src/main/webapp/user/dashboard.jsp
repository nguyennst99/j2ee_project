<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<c:set var="pageTitle" value="Dashboard" scope="request"/>
<jsp:include page="/common/header.jsp"/>
<div class="container mt-4">
    <h1>Customer Dashboard</h1>
    <hr>

    <c:if test="${not empty param.message}">
        <div class="alert alert-success" role="alert"><c:out value="${param.message}"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger" role="alert"><c:out value="${param.error}"/></div>
    </c:if>

    <div class="mb-4">
        <h3>Your Registered Products & Claims</h3>
        <a href="/registerProduct" class="btn btn-primary mb-3">Register a New Product</a>
    </div>

    <c:choose>
        <c:when test="${not empty registeredProducts}">
            <c:forEach var="rp" items="${registeredProducts}">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <c:out value="${rp.product.productName}"/> (<c:out value="${rp.product.model}"/>)
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">
                            <strong>Serial #:</strong> <c:out value="${rp.serialNumber}"/> |
                            <strong>Purchased:</strong> <fmt:formatDate value="${rp.purchaseDate}"
                                                                        pattern="yyyy-MM-dd"/>
                        </p>
                        <a href="/addClaim?regId=${rp.id}" class="btn btn-sm btn-warning">Add Claim</a>

                            <%-- Claims Section --%>
                        <h6 class="mt-3">Claims History:</h6>
                        <c:set var="productClaims" value="${claimsMap[rp.id]}"/>
                        <c:choose>
                            <c:when test="${not empty productClaims}">
                                <table class="table table-sm table-striped table-hover mt-2">
                                    <thead>
                                    <tr>
                                        <th>Claim Date</th>
                                        <th>Status</th>
                                        <th>Description</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="claim" items="${productClaims}">
                                        <tr>
                                            <td><fmt:formatDate value="${claim.dateOfClaim}" pattern="yyyy-MM-dd"/></td>
                                            <td><span
                                                    class="badge bg-${claim.claimStatus == 'Approved' ? 'success' : claim.claimStatus == 'Rejected' ? 'danger' : claim.claimStatus == 'Processing' ? 'info' : 'secondary'}"><c:out
                                                    value="${claim.claimStatus}"/></span></td>
                                            <td><c:out value="${claim.description}"/></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted small ms-2">No claims submitted for this product yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div> <%-- End card --%>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info" role="alert">
                You have not registered any products yet. Click the button above to register one!
            </div>
        </c:otherwise>
    </c:choose>
</div>
<%-- End Page Specific Content --%>

<jsp:include page="/common/footer.jsp"/>