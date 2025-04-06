<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Group 2</title>
    <link rel="stylesheet" type="text/css" href="/css/login.css">
</head>
<body>

<div class="form-container">
    <h2>Login to Your Account</h2>

    <%-- Display Login Error Message (if set by LoginServlet) --%>
    <c:if test="${not empty loginError}">
        <div class="error-message">
            <c:out value="${loginError}" />
        </div>
    </c:if>

    <%-- Display Registration Success Message (if redirected from RegisterServlet) --%>
    <c:if test="${param.registration == 'success'}">
        <div class="success-message">
            Registration successful! Please login.
        </div>
    </c:if>

    <%-- Login Form  --%>
    <form action="/login" method="post">
        <div>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required autofocus>
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>

    <p class="register-link">
        Don't have an account? <a href="/register">Register here</a>
    </p>

</div>

</body>
</html>