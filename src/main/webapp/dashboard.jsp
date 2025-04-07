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

<c:if test="${empty sessionScope.userId}">
    <c:redirect url="/login?error=nosession"/>
</c:if>

<div class="header">
    <h1>Customer Dashboard</h1>
    <div>
        <span>Welcome, <c:out value="${sessionScope.username}"/>!</span> |
        <a href="/logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="content">

    <%-- Display message from redirect parameter (e.g., product registration success) --%>
    <c:if test="${not empty param.message}">
        <div class="message success">
            <c:out value="${param.message}"/>
        </div>
    </c:if>

    <div id="registered-products-section">
        <h3>Your Registered Products</h3>
        <a href="/registerProduct" class="add-product-btn">Register a New Product</a>

        <table>
            <thead>
            <tr>
                <th>Product Name</th>
                <th>Model</th>
                <th>Serial Number</th>
                <th>Purchase Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty registeredProducts}">
                    <c:forEach var="rp" items="${registeredProducts}">
                        <tr>
                                <%-- Access Product details via the joined object --%>
                            <td><c:out value="${rp.product.productName}"/></td>
                            <td><c:out value="${rp.product.model}"/></td>
                            <td><c:out value="${rp.serialNumber}"/></td>
                            <td>
                                    <%-- Format the java.sql.Date --%>
                                <fmt:formatDate value="${rp.purchaseDate}" pattern="yyyy-MM-dd"/>
                            </td>
                            <td>
                                    <%-- Placeholder for Add Claim Button (Phase 5) --%>
                                    <%-- <a href="${pageContext.request.contextPath}/addClaim?regId=${rp.id}">Add Claim</a> --%>
                                (Add Claim)
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">You have not registered any products yet.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div id="claims-section" style="margin-top: 30px;">
        <h3>Your Claims</h3>
        <p>Loading claims...</p> <%-- Claims list will go here later --%>
    </div>

</div>

</body>
</html>