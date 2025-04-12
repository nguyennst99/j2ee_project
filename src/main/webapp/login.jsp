<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Login - ABC Insurance" scope="request"/> <%-- Set page title --%>
<jsp:include page="/common/header.jsp"/>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h2 class="card-title text-center mb-4">Login</h2>

                    <c:if test="${not empty loginError}">
                        <div class="alert alert-danger" role="alert"><c:out value="${loginError}" /></div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-warning" role="alert">Access denied: <c:out value="${param.error}"/></div>
                    </c:if>
                    <c:if test="${param.registration == 'success'}">
                        <div class="alert alert-success" role="alert">Registration successful! Please login.</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post" novalidate> <%-- Add novalidate if using JS validation --%>
                        <div class="mb-3">
                            <label for="username" class="form-label">Username:</label>
                            <input type="text" class="form-control" id="username" name="username" required autofocus>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password:</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success btn-lg">Login</button>
                        </div>
                    </form>

                    <p class="text-center mt-3">
                        Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<%-- End Page Specific Content --%>
</body>
</html>