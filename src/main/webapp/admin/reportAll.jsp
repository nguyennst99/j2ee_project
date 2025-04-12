<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required"/>
</c:if>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - All User Report - ABC Insurance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <style>
        .user-section {
            border: 1px solid #6c757d;
            margin-bottom: 25px;
            padding: 0;
            border-radius: .375rem;
            background-color: #fff;
            box-shadow: 0 .125rem .25rem rgba(0, 0, 0, .075);
        }

        .user-details {
            padding: 1rem 1.25rem;
            font-weight: bold;
            font-size: 1.1em;
            background-color: #e9ecef;
            border-bottom: 1px solid #dee2e6;
            border-top-left-radius: .375rem;
            border-top-right-radius: .375rem;
        }

        .user-details span {
            margin-right: 15px;
        }

        .card-body-report {
            padding: 1.25rem;
        }

        /* Use custom class for padding */
        .product-section-report {
            border: 1px solid #cfe2ff;
            margin-bottom: 15px;
            padding: 10px 15px;
            background-color: #f8fcff;
            border-radius: 4px;
        }

        .product-details-report {
            font-style: italic;
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px dotted #ccc;
            color: #555;
        }

        .product-details-report strong {
            color: #333;
            font-style: normal;
        }

        .claims-table-report {
            margin-left: 0;
            width: 100%;
            font-size: 0.9em;
            margin-top: 10px;
        }

        .claims-table-report th {
            background-color: #e9ecef;
        }

        .claims-table-report td {
            background-color: #fff;
        }

        .no-data {
            color: #6c757d;
            margin-left: 0;
            font-style: italic;
            padding: .5rem 0;
        }
    </style>
</head>
<body>

<%-- 1. Include Fixed Top Navbar --%>
<jsp:include page="/common/adminNavbar.jsp"/>

<%-- 2. Sidebar (Fixed for large screens) --%>
<div class="sidebar d-none d-lg-block">
    <jsp:include page="/common/adminSidebar.jsp"/>
</div>
<%-- Offcanvas Sidebar for small screens --%>
<div class="offcanvas offcanvas-start d-lg-none" tabindex="-1" id="offcanvasAdminSidebar"
     aria-labelledby="offcanvasAdminSidebarLabel" style="width: var(--sidebar-width);">
    <div class="offcanvas-header"><h5 class="offcanvas-title" id="offcanvasAdminSidebarLabel">Admin Menu</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <jsp:include page="/common/adminSidebar.jsp"/>
    </div>
</div>

<%-- 3. Main Content Area --%>
<main class="main-content-area">

    <%-- START: Specific content for reportAll.jsp --%>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-1 pb-2 mb-3 border-bottom">
        <h1 class="h2">Report: All Users, Products, and Claims</h1>
    </div>

    <c:choose>
        <c:when test="${not empty userReportList}">
            <c:forEach var="reportDetail" items="${userReportList}">
                <div class="user-section"> <%-- Replaced card with user-section --%>
                    <div class="user-details">
                        <c:set var="user" value="${reportDetail.user}"/>
                        <span>User ID: <c:out value="${user.id}"/></span>
                        <span>Username: <c:out value="${user.username}"/></span>
                        <span>Name: <c:out value="${user.name}"/></span>
                        <span>Email: <c:out value="${user.email}"/></span>
                        <span>Role: <span class="badge bg-${user.role == Role.admin ? 'primary' : 'secondary'}">
                            <c:out value="${user.role}"/></span></span>
                    </div>
                    <div class="card-body-report">
                        <c:set var="userProducts" value="${reportDetail.registeredProducts}"/>
                        <c:choose>
                            <c:when test="${not empty userProducts}">
                                <h6 class="mb-2 text-muted">Registered Products:</h6>
                                <c:forEach var="rp" items="${userProducts}">
                                    <div class="product-section-report">
                                        <p class="product-details-report">
                                            <strong>Reg ID: <c:out value="${rp.id}"/></strong> | <c:out
                                                value="${rp.product.productName}"/> (<c:out
                                                value="${rp.product.model}"/>) |
                                            Serial #: <c:out value="${rp.serialNumber}"/> | Purchased: <fmt:formatDate
                                                value="${rp.purchaseDate}" pattern="yyyy-MM-dd"/>
                                        </p>
                                        <c:set var="productClaims" value="${reportDetail.productClaimsMap[rp.id]}"/>
                                        <c:choose>
                                            <c:when test="${not empty productClaims}">
                                                <table class="table table-sm table-bordered table-hover claims-table-report">
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
                                                <p class="no-data">No claims for this product.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="no-data">This user has no registered products.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div> <%-- End user-section --%>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">No users found in the system.</div>
        </c:otherwise>
    </c:choose>
    <%-- END: Specific content for reportAll.jsp --%>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>
</body>
</html>