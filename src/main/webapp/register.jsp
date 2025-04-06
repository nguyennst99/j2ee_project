<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Group 2</title>
    <link rel="stylesheet" type="text/css" href="css/register.css">
</head>
<body>

<div class="form-container">
    <h2>Create Your Account</h2>

    <%-- Display validation errors --%>
    <c:if test="${not empty errors}">
        <div class="error-message">
            <strong>Please correct the following errors:</strong><br/>
            <ul>
                <c:forEach var="error" items="${errors}">
                    <li><c:out value="${error}"/></li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <%-- Registration Form - Use POST to /register --%>
    <form action="/register" method="post">

        <div>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" value="<c:out value='${requestScope.usernameValue}' />"
                   required maxlength="15" minlength="4">
        </div>

        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<c:out value='${requestScope.emailValue}' />" required
                   maxlength="100">
        </div>

        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required
                   minlength="8">
        </div>

        <div>
            <label for="confirmPassword">Confirm Password:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>

        <div>
            <label for="cellphone">Cellphone Number:</label>
            <input type="text" id="cellphone" name="cellphone" value="<c:out value='${requestScope.cellphoneValue}' />"
                   required maxlength="12">
        </div>

        <div>
            <label for="name">Full Name:</label>
            <input type="text" id="name" name="name" value="<c:out value='${requestScope.nameValue}' />" required
                   maxlength="30">
        </div>

        <div>
            <label for="address">Address:</label>
            <textarea id="address" name="address" rows="3" required maxlength="50"><c:out
                    value='${requestScope.addressValue}'/></textarea>
        </div>

        <div>
            <button type="submit">Register</button>
        </div>

        <p class="login-link">
            Already have an account? <a href="/login">Login here</a>
        </p>

    </form>
</div>

</body>
</html>