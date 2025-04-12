<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<c:set var="pageTitle" value="My Claims" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Claims</li>
        </ol>
    </nav>

    <h1 class="h2 mb-3">My Claims History</h1>
    <hr>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-bordered table-sm">
            <thead class="table-light">
            <tr>
                <th scope="col">Claim ID</th>
                <th scope="col">Product</th>
                <th scope="col">Serial #</th>
                <th scope="col">Claim Date</th>
                <th scope="col">Status</th>
                <th scope="col">Description</th>
                <th scope="col">Submitted On</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty allUserClaims}">
                    <c:forEach var="claim" items="${allUserClaims}">
                        <c:set var="rp" value="${productMap[claim.registeredProductId]}"/>
                        <tr>
                            <td><c:out value="${claim.id}"/></td>
                            <td>
                                    <%-- Display Product Name and Model if available --%>
                                <c:if test="${not empty rp && not empty rp.product}">
                                    <c:out value="${rp.product.productName}"/> (<c:out value="${rp.product.model}"/>)
                                </c:if>
                                <c:if test="${empty rp or empty rp.product}">
                                    <span class="text-muted fst-italic">Product details unavailable</span>
                                </c:if>
                            </td>
                            <td>
                                    <%-- Display Serial Number if available --%>
                                <c:if test="${not empty rp}">
                                    <c:out value="${rp.serialNumber}"/>
                                </c:if>
                                <c:if test="${empty rp}">
                                    <span class="text-muted fst-italic">N/A</span>
                                </c:if>
                            </td>
                            <td><fmt:formatDate value="${claim.dateOfClaim}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                    <%-- Display Status using Bootstrap Badge --%>
                                <span class="badge bg-${claim.claimStatus == 'Approved' ? 'success' : claim.claimStatus == 'Rejected' ? 'danger' : claim.claimStatus == 'Processing' ? 'info' : 'secondary'}">
                                        <c:out value="${claim.claimStatus}"/>
                                    </span>
                            </td>
                            <td><c:out value="${claim.description}"/></td>
                            <td><fmt:formatDate value="${claim.createdAt}" pattern="yyyy-MM-dd HH:mm z" timeZone="${serverTimeZoneId}" /></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- Message if no claims are found --%>
                    <tr>
                        <td colspan="7" class="text-center text-muted fst-italic py-3">
                            You have not submitted any claims yet.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>