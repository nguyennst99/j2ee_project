<%-- /src/main/webapp/common/adminFooter.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- This fragment contains ONLY the footer content for admin pages --%>
<%-- Assumes Bootstrap CSS/JS are loaded by the main including page --%>
<%-- Assumes CSS for .footer-admin is defined in the main including page --%>

<footer class="footer-admin">
    © <%= java.time.Year.now().getValue() %> ABC Insurance Company | Group 2 Project.
</footer>

<%-- Bootstrap JS (Should be included only ONCE per final HTML page) --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>