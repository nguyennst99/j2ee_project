<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Register - ABC Insurance" scope="request"/>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h2 class="card-title text-center mb-4">Create Your Account</h2>

                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger" role="alert">
                            <strong>Please correct the following errors:</strong>
                            <ul><c:forEach var="error" items="${errors}"><li><c:out value="${error}"/></li></c:forEach></ul>
                        </div>
                    </c:if>

                    <form action="/register" method="post" novalidate>
                        <div class="row g-3">
                            <div class="col-md-6 mb-3">
                                <label for="username" class="form-label">Username:</label>
                                <input type="text" class="form-control" id="username" name="username" value="<c:out value='${requestScope.usernameValue}' />" required maxlength="15" minlength="4">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" value="<c:out value='${requestScope.emailValue}' />" required maxlength="100">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" required minlength="8">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password:</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Full Name:</label>
                                <input type="text" class="form-control" id="name" name="name" value="<c:out value='${requestScope.nameValue}' />" required maxlength="30">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="cellphone" class="form-label">Cellphone Number:</label>
                                <input type="text" class="form-control" id="cellphone" name="cellphone" value="<c:out value='${requestScope.cellphoneValue}' />" required maxlength="12">
                            </div>
                            <div class="col-12 mb-3">
                                <label for="address" class="form-label">Address:</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required maxlength="50"><c:out value='${requestScope.addressValue}'/></textarea>
                            </div>
                        </div>
                        <div class="d-grid mt-3">
                            <button type="submit" class="btn btn-primary btn-lg">Register</button>
                        </div>
                    </form>
                    <p class="text-center mt-3">
                        Already have an account? <a href="/login">Login here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>