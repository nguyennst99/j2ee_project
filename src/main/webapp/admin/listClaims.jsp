<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>
<%@ page import="humber.ca.project.model.ClaimStatus" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Claims</title>
    <link rel="stylesheet" type="text/css" href="/css/adminListClaims.css">

</head>
<body>
<%--<c:import url="/WEB-INF/views/common/adminHeader.jsp"/>--%>

<div class="container" style="margin: 20px;">
    <h2>Manage Claims</h2>

    <%-- Display messages from redirect --%>
    <c:if test="${not empty param.message}">
        <div class="message ${param.messageType == 'error' ? 'error' : 'success'}">
            <c:out value="${param.message}"/>
        </div>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>Claim ID</th>
            <th>Reg. Prod. ID</th>
            <th>Claim Date</th>
            <th>Description</th>
            <th>Current Status</th>
            <th>Created At</th>
            <th>Update Status</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty claimList}">
                <c:forEach var="claim" items="${claimList}">
                    <tr>
                        <td><c:out value="${claim.id}"/></td>
                        <td><c:out value="${claim.registeredProductId}"/></td> <%-- Link to product/user later? --%>
                        <td><fmt:formatDate value="${claim.dateOfClaim}" pattern="yyyy-MM-dd"/></td>
                        <td><c:out value="${claim.description}"/></td>
                        <td class="claim-status-${claim.claimStatus}">
                            <c:out value="${claim.claimStatus}"/>
                        </td>
                        <td><fmt:formatDate value="${claim.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                                <%-- Form to update status for this specific claim --%>
                            <form action="/admin/claims" method="post" class="update-form">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="claimId" value="${claim.id}">
                                <select name="newStatus">
                                        <%-- Loop through possible statuses from the Enum --%>
                                    <c:forEach var="status" items="<%= ClaimStatus.values() %>">
                                        <option value="${status.name()}" ${claim.claimStatus == status ? 'selected' : ''}>
                                            <c:out value="${status.name()}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary">Update</button> <%-- Add btn-sm if defined --%>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7">No claims found.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>