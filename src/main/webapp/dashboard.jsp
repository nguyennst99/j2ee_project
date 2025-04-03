<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <title>Group 2</title>
  <link rel="stylesheet" type="text/css" href="/css/dashboard.css">

</head>
<body>

<%-- Check if user is actually logged in (though Filter should handle this primarily) --%>
<c:if test="${empty sessionScope.userId}">
  <%-- User somehow reached here without being logged in - Redirect to login --%>
  <c:redirect url="/login.jsp?error=nosession" />
</c:if>

<div class="header">
  <h1>Customer Dashboard</h1>
  <div>
    <span>Welcome, <c:out value="${sessionScope.username}" />!</span> |
    <a href="logout" class="logout-btn">Logout</a>
  </div>
</div>

<div class="content">
  <p class="welcome-message">This is your main dashboard. Manage your registered products and claims here.</p>

  <%-- Placeholder for future content (Product List, Claim List, Buttons) --%>
  <div id="registered-products-section">
    <h3>Your Registered Products</h3>
    <%-- Product list will be loaded here dynamically later --%>
    <p>Loading products...</p>
    <a href="/login.jsp">Register a New Product</a> <%-- Link to the registration servlet --%>
  </div>

  <div id="claims-section" style="margin-top: 30px;">
    <h3>Your Claims</h3>
    <%-- Claims list will be loaded here dynamically later --%>
    <p>Loading claims...</p>
    <%-- Add Claim button will be next to products later --%>
  </div>

</div>

</body>
</html>