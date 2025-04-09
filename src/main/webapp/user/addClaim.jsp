<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId}"><c:redirect
        url="/login?error=nosession"/></c:if>

<!DOCTYPE html>
<html>
<head>
    <title>ABC Insurance - Add Claim</title>
    <link rel="stylesheet" type="text/css" href="/css/addClaim.css">
</head>
<body>
<div style="margin: 20px;"><a href="/dashboard">Back to Dashboard</a></div>

<div class="form-container">
    <h2>Add New Claim</h2>

    <%-- Display product information if available --%>
    <c:if test="${not empty registeredProduct}">
        <div class="product-info">
            <h4>For Product:</h4>
            <p><strong>Name:</strong> <c:out value="${registeredProduct.product.productName}"/></p>
            <p><strong>Model:</strong> <c:out value="${registeredProduct.product.model}"/></p>
            <p><strong>Serial #:</strong> <c:out value="${registeredProduct.serialNumber}"/></p>
            <p><strong>Purchase Date:</strong> <fmt:formatDate value="${registeredProduct.purchaseDate}"
                                                               pattern="yyyy-MM-dd"/></p>
        </div>
    </c:if>

    <%-- Display validation errors --%>
    <c:if test="${not empty errors}">
        <div class="error-message">
            <strong>Please correct the following errors:</strong>
            <ul><c:forEach var="error" items="${errors}">
                <li><c:out value="${error}"/></li>
            </c:forEach></ul>
        </div>
    </c:if>

    <%-- Form posts to /addClaim --%>
    <form action="/addClaim" method="post">

        <%-- Hidden field to pass the registered product ID back --%>
        <input type="hidden" name="registeredProductId"
               value="<c:out value='${registeredProduct.id}'/>"> <%-- Get regId from request param --%>

        <div>
            <label for="dateOfClaim">Date of Incident/Claim:</label>
            <%-- Repopulate if validation failed --%>
            <input type="date" id="dateOfClaim" name="dateOfClaim" value="<c:out value='${param.dateOfClaim}'/>"
                   required>
        </div>

        <div>
            <label for="description">Description of Incident/Issue:</label>
            <textarea id="description" name="description" rows="5" required><c:out
                    value='${param.description}'/></textarea>
        </div>

        <div>
            <button type="submit" class="btn btn-primary">Submit Claim</button>
        </div>
    </form>
</div>
</body>
</html>