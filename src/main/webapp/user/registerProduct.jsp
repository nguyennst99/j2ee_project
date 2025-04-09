<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Basic Security Check (Filter is primary) --%>
<c:if test="${empty sessionScope.userId}">
    <c:redirect url="/login?error=nosession"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>ABC Insurance - Register Product</title>
    <link rel="stylesheet" type="text/css" href="/css/register.css">
</head>
<body>

<div style="margin: 20px;"><a href="/dashboard">Back to Dashboard</a></div>

<div class="form-container">
    <h2>Register Your Product</h2>

    <%-- Display validation errors if any --%>
    <c:if test="${not empty errors}">
        <div class="error-message">
            <strong>Please correct the following errors:</strong><br/>
            <ul>
                <c:forEach var="error" items="${errors}">
                    <li><c:out value="${error}"/></li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <%-- Display success message if set --%>
    <c:if test="${not empty successMessage}">
        <div class="success-message">
            <c:out value="${successMessage}"/>
        </div>
    </c:if>

    <%-- Registration Form - Posts to /registerProduct --%>
    <form action="/registerProduct" method="post">

        <div>
            <label for="productId">Product Name:</label>
            <select id="productId" name="productId" required>
                <option value="">-- Select Product --</option>
                <%-- Populate dropdown from productList attribute set by servlet --%>
                <c:forEach var="product" items="${productList}">
                    <option value="${product.id}" ${param.productId == product.id ? 'selected' : ''}>
                        <c:out value="${product.productName}"/> (<c:out value="${product.model}"/>)
                    </option>
                </c:forEach>
            </select>
        </div>

        <div>
            <label for="serialNumber">Serial Number:</label>
            <%-- Repopulate if validation failed --%>
            <input type="text" id="serialNumber" name="serialNumber" value="<c:out value='${param.serialNumber}'/>"
                   required maxlength="50">
        </div>

        <div>
            <label for="purchaseDate">Purchase Date:</label>
            <%-- Repopulate if validation failed --%>
            <input type="date" id="purchaseDate" name="purchaseDate" value="<c:out value='${param.purchaseDate}'/>"
                   required>
        </div>

        <div>
            <button type="submit">Register Product</button>
        </div>
    </form>
</div>

</body>
</html>