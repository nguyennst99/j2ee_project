<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="humber.ca.project.model.Role" %>
<%@ page import="humber.ca.project.model.ClaimStatus" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required"/>
</c:if>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Manage Claims - ABC Insurance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">


    <style>
        .claim-status-Submitted {
            font-weight: bold;
        }

        .claim-status-Processing {
            color: #007bff;
        }

        .claim-status-Approved {
            color: #198754;
            font-weight: bold;
        }

        .claim-status-Rejected {
            color: #dc3545;
            font-style: italic;
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

    <%-- START: Specific content for listClaims.jsp --%>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-1 pb-2 mb-3 border-bottom">
        <h1 class="h2">Manage Claims</h1>
    </div>

    <c:if test="${not empty param.message}">
        <div class="alert ${param.messageType == 'error' ? 'alert-danger' : 'alert-success'} alert-dismissible fade show"
             role="alert">
            <c:out value="${param.message}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-sm align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Reg. Prod. ID</th>
                <th>Claim Date</th>
                <th>Description</th>
                <th>Status</th>
                <th>Created At</th>
                <th style="min-width: 220px;">Update Status</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty claimList}">
                    <c:forEach var="claim" items="${claimList}">
                        <tr>
                            <td><c:out value="${claim.id}"/></td>
                            <td><c:out value="${claim.registeredProductId}"/></td>
                            <td><fmt:formatDate value="${claim.dateOfClaim}" pattern="yyyy-MM-dd"/></td>
                            <td><c:out value="${claim.description}"/></td>
                            <td><span
                                    class="badge bg-${claim.claimStatus == 'Approved' ? 'success' : claim.claimStatus == 'Rejected' ? 'danger' : claim.claimStatus == 'Processing' ? 'info' : 'secondary'}"><c:out
                                    value="${claim.claimStatus}"/></span></td>
                            <td><fmt:formatDate value="${claim.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                <form action="/admin/claims" method="post" class="d-inline-flex align-items-center">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="claimId" value="${claim.id}">
                                    <select name="newStatus" class="form-select form-select-sm me-2"
                                            style="width: auto;">
                                        <c:forEach var="status" items="<%= ClaimStatus.values() %>">
                                            <option value="${status.name()}" ${claim.claimStatus == status ? 'selected' : ''}>
                                                <c:out value="${status.name()}"/></option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-sm">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" class="text-center text-muted fst-italic py-3">No claims found.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <%-- END: Specific content for listClaims.jsp --%>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>
</body>
</html>