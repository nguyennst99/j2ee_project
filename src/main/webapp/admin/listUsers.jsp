<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=admin_required"/></c:if>

<c:set var="pageTitle" value="Admin - Manage Users" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>Manage Users</h2>
    <hr>

    <form action="/admin/users" method="get" class="row g-3 align-items-center mb-3">
        <div class="col-auto">
            <label for="searchTerm" class="visually-hidden">Search</label>
            <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                   placeholder="Search by username, email, name..." value="<c:out value='${searchTerm}'/>">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-secondary">Search</button>
        </div>
        <div class="col-auto">
            <a href="/admin/users" class="btn btn-outline-secondary">Clear Search</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-sm">
            <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Name</th>
                <th>Cellphone</th>
                <th>Address</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty userList}">
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td><c:out value="${user.id}"/></td>
                            <td><c:out value="${user.username}"/></td>
                            <td><c:out value="${user.email}"/></td>
                            <td><c:out value="${user.name}"/></td>
                            <td><c:out value="${user.cellphone}"/></td>
                            <td><c:out value="${user.address}"/></td>
                            <td><span class="badge bg-${user.role == Role.admin ? 'primary' : 'secondary'}"><c:out
                                    value="${user.role}"/></span></td>
                            <td>(Actions)</td>
                                <%-- Placeholder for future actions --%>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" class="text-center text-muted">No users found<c:if
                                test="${not empty searchTerm}"> matching search</c:if>.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>