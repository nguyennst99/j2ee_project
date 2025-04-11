<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="humber.ca.project.model.Role" %>

<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}"><c:redirect
        url="/login?error=admin_required"/></c:if>

<c:set var="pageTitle" value="Admin - Registered Products" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-4">
    <c:import url="/common/adminHeader.jsp"/>

    <h2>View Registered Products</h2>
    <hr>

    <form action="/admin/registeredProducts" method="get"
          class="row g-3 align-items-center mb-3">
        <div class="col-auto">
            <label for="searchTerm" class="visually-hidden">Search</label>
            <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                   placeholder="Search User, Product, Serial..." value="<c:out value='${searchTerm}'/>">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-secondary">Search</button>
        </div>
        <div class="col-auto">
            <a href="/admin/registeredProducts" class="btn btn-outline-secondary">Show
                All</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-striped table-hover table-sm">
            <thead>
            <tr>
                <th>Reg ID</th>
                <th>User (ID/Name)</th>
                <th>Product (ID/Name/Model)</th>
                <th>Serial #</th>
                <th>Purchased</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty registeredProductList}">
                    <c:forEach var="rp" items="${registeredProductList}">
                        <tr>
                            <td><c:out value="${rp.id}"/></td>
                            <td><c:out value="${rp.user.id}"/> / <c:out value="${rp.user.username}"/> (<c:out
                                    value="${rp.user.name}"/>)
                            </td>
                            <td><c:out value="${rp.product.id}"/> / <c:out value="${rp.product.productName}"/> (<c:out
                                    value="${rp.product.model}"/>)
                            </td>
                            <td><c:out value="${rp.serialNumber}"/></td>
                            <td><fmt:formatDate value="${rp.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="text-center text-muted">No registered products found<c:if
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