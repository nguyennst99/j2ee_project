<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<!DOCTYPE html>
<html>
<head>
  <title>ABC Insurance - Admin Dashboard</title>
  <link rel="stylesheet" type="text/css" href="/css/adminDashboard.css">

</head>
<body>
<%-- Check if user is logged in AND is an Admin --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
  <%-- Redirect non-admins or non-logged-in users --%>
  <c:redirect url="/login.jsp?error=unauthorized" />
</c:if>

<div class="header">
  <h1>Admin Dashboard</h1>
  <div>
    <span>Welcome, Admin <c:out value="${sessionScope.username}" />!</span> |
    <a href="/logout" class="logout-btn">Logout</a>
  </div>
</div>

<div class="content">
  <p>Manage users, products, claims, and view reports.</p>

  <nav class="admin-nav">
    <ul>
      <li><a href="/admin/users">Manage Users</a></li>
      <li><a href="/admin/products">Manage Products</a></li>
      <li><a href="/admin/claims">Manage Claims</a></li>
      <li><a href="/admin/registeredProducts">View Registered Products</a></li>
      <li><a href="/admin/reports/all">View All User Report</a></li>
      <%-- Add links to other reports/features as needed --%>
    </ul>
  </nav>

</div>

</body>
</html>