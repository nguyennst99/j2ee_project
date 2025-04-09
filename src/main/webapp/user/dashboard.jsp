<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>ABC Insurance - Dashboard</title>
    <link rel="stylesheet" type="text/css" href="/css/dashboard.css">

</head>
<body>
<c:if test="${empty sessionScope.userId}"><c:redirect
        url="/login?error=nosession"/></c:if>

<div class="header"><h1>Customer Dashboard</h1>
    <div><span>Welcome, <c:out value="${sessionScope.username}"/>!</span> | <a
            href="/logout" class="logout-btn">Logout</a></div>
</div>
<div class="content">
    <c:if test="${not empty param.message}">
        <div class="message success"><c:out value="${param.message}"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="message error"><c:out value="${param.error}"/></div>
    </c:if>

    <h3>Your Registered Products & Claims</h3>
    <a href="/registerProduct" class="add-product-btn">Register a New Product</a>

    <c:choose>
        <c:when test="${not empty registeredProducts}">
            <c:forEach var="rp" items="${registeredProducts}">
                <div class="product-section">
                    <h4>
                        <c:out value="${rp.product.productName}"/> (<c:out value="${rp.product.model}"/>) -
                        Serial #: <c:out value="${rp.serialNumber}"/> |
                        Purchased: <fmt:formatDate value="${rp.purchaseDate}" pattern="yyyy-MM-dd"/>
                        | <a href="/addClaim?regId=${rp.id}"
                             style="font-weight:normal; font-size:0.9em;">Add Claim</a>
                    </h4>

                        <%-- Get claims for this specific registered product from the map --%>
                    <c:set var="productClaims" value="${claimsMap[rp.id]}"/>

                    <c:choose>
                        <c:when test="${not empty productClaims}">
                            <table class="claims-table">
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
                                        <td class="claim-status-${claim.claimStatus}">
                                            <c:out value="${claim.claimStatus}"/>
                                        </td>
                                        <td><c:out value="${claim.description}"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p style="font-size: 0.9em; margin-left: 10px;">No claims submitted for this product
                                yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div> <%-- End product-section --%>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p>You have not registered any products yet.</p>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>