<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>
<%@ page import="humber.ca.project.model.ClaimStatus" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=admin_required"/></c:if>

<c:set var="pageTitle" value="Admin - Manage Claims" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>Manage Claims</h2>
    <hr>

    <c:if test="${not empty param.message}">
        <div class="alert ${param.messageType == 'error' ? 'alert-danger' : 'alert-success'}" role="alert">
            <c:out value="${param.message}"/>
        </div>
    </c:if>

    <div class="table-responsive"> <%-- Make table scroll on small screens --%>
        <table class="table table-striped table-hover table-sm"> <%-- Added table-sm --%>
            <thead>
            <tr>
                <th>ID</th>
                <th>Reg. Prod. ID</th>
                <th>Claim Date</th>
                <th>Description</th>
                <th>Status</th>
                <th>Created At</th>
                <th style="min-width: 220px;">Update Status</th>
                <%-- Give update column more space --%>
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
                                <form action="/admin/claims" method="post"
                                      class="d-inline-flex align-items-center"> <%-- Use flex for alignment --%>
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="claimId" value="${claim.id}">
                                    <select name="newStatus" class="form-select form-select-sm me-2"
                                            style="width: auto;"> <%-- Bootstrap select --%>
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
                        <td colspan="7" class="text-center text-muted">No claims found.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>