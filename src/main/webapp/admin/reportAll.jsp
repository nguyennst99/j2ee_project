<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=admin_required"/></c:if>

<c:set var="pageTitle" value="Admin - All User Report" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>Report: All Users, Registered Products, and Claims</h2>
    <hr>

    <c:choose>
        <c:when test="${not empty userReportList}">
            <c:forEach var="reportDetail" items="${userReportList}">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-light">
                        <c:set var="user" value="${reportDetail.user}"/>
                        <h5 class="mb-0">
                            User: <c:out value="${user.username}"/> (ID: <c:out value="${user.id}"/>) - <c:out
                                value="${user.name}"/>
                            <span class="badge bg-${user.role == Role.admin ? 'primary' : 'secondary'} float-end"><c:out
                                    value="${user.role}"/></span>
                        </h5>
                        <small class="text-muted">Email: <c:out value="${user.email}"/></small>
                    </div>
                    <div class="card-body">
                        <c:set var="userProducts" value="${reportDetail.registeredProducts}"/>
                        <c:choose>
                            <c:when test="${not empty userProducts}">
                                <h6 class="card-subtitle mb-2 text-muted">Registered Products:</h6>
                                <c:forEach var="rp" items="${userProducts}">
                                    <div class="product-section-report border rounded p-3 mb-3 bg-white">
                                        <p><strong>Reg ID: <c:out value="${rp.id}"/></strong> | <c:out
                                                value="${rp.product.productName}"/> (<c:out
                                                value="${rp.product.model}"/>)</p>
                                        <p class="small text-muted mb-1">Serial #: <c:out value="${rp.serialNumber}"/> |
                                            Purchased: <fmt:formatDate value="${rp.purchaseDate}"
                                                                       pattern="yyyy-MM-dd"/></p>

                                        <c:set var="productClaims" value="${reportDetail.productClaimsMap[rp.id]}"/>
                                        <c:choose>
                                            <c:when test="${not empty productClaims}">
                                                <table class="table table-sm table-bordered table-hover claims-table-report mt-2">
                                                    <thead class="table-light">
                                                    <tr>
                                                        <th>Claim ID</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                        <th>Description</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach var="claim" items="${productClaims}">
                                                        <tr>
                                                            <td><c:out value="${claim.id}"/></td>
                                                            <td><fmt:formatDate value="${claim.dateOfClaim}"
                                                                                pattern="yyyy-MM-dd"/></td>
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
                                                <p class="small text-muted fst-italic ms-2">No claims for this
                                                    product.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">No registered products for this user.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div> <%-- End User Card --%>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">No users found in the system.</div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/common/footer.jsp"/>