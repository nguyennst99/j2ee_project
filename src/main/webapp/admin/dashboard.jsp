<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check (Filter is primary) --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required"/>
</c:if>

<c:set var="pageTitle" value="Admin Dashboard" scope="request"/>
<jsp:include page="/common/header.jsp"/> <%-- Use main header --%>

<div class="container mt-4">
    <%-- Include the specific admin navigation/header --%>
    <c:import url="/common/adminHeader.jsp"/>

    <h2>Admin Dashboard</h2>
    <p>Welcome, Admin <c:out value="${sessionScope.username}"/>! Use the navigation above to manage the application.</p>

    <%-- Optional: Add summary boxes or quick stats here later --%>
    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h5 class="card-title">Users</h5>
                    <p class="card-text">View and manage user accounts.</p>
                    <a href="/admin/users" class="btn btn-secondary">Go to Users</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h5 class="card-title">Products</h5>
                    <p class="card-text">Manage the product catalog.</p>
                    <a href="/admin/products" class="btn btn-secondary">Go to Products</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h5 class="card-title">Claims</h5>
                    <p class="card-text">Review and update claim statuses.</p>
                    <a href="/admin/claims" class="btn btn-secondary">Go to Claims</a>
                </div>
            </div>
        </div>
        <%-- Add more cards for reports etc. --%>
    </div>

</div>

<jsp:include page="/common/footer.jsp"/>