<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.user}">
    <c:redirect url="/login?error=unauthorized"/>
</c:if>

<c:set var="pageTitle" value="My Dashboard" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <h1 class="mb-4">Welcome, <c:out value="${sessionScope.username}"/>!</h1>

    <%-- Display messages --%>
    <c:if test="${not empty param.message}">
        <div class="alert alert-success" role="alert"><c:out value="${param.message}"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger" role="alert"><c:out value="${param.error}"/></div>
    </c:if>

    <div class="row g-4">
        <%-- Card for My Products --%>
        <div class="col-md-6">
            <div class="card h-100 shadow-sm">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><i class="bi bi-box-seam me-2"></i>My Registered Products</h5>
                    <p class="card-text flex-grow-1">View your registered devices, check warranty status (implicitly via
                        claim eligibility), and initiate new claims.</p>
                    <a href="/my-products" class="btn btn-primary mt-auto">View My
                        Products</a>
                </div>
            </div>
        </div>

        <%-- Card for My Claims --%>
        <div class="col-md-6">
            <div class="card h-100 shadow-sm">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><i class="bi bi-clipboard-check me-2"></i>My Claims History</h5>
                    <p class="card-text flex-grow-1">Track the status of all your submitted claims for repairs or
                        replacements.</p>
                    <a href="/my-claims" class="btn btn-info mt-auto">View My
                        Claims</a>
                </div>
            </div>
        </div>

        <%-- Card for Registered Product --%>
        <div class="col-md-6">
            <div class="card h-100 shadow-sm">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><i class="bi bi-plus-circle me-2"></i>Register New Product</h5>
                    <p class="card-text flex-grow-1">Add a new device to your protection plan.</p>
                    <a href="/registerProduct" class="btn btn-success mt-auto">Register
                        Product</a>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/common/footer.jsp"/>