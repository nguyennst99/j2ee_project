<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="humber.ca.project.model.Role" %>

<%-- Security Check --%>
<c:if test="${empty sessionScope.userId or sessionScope.userRole != Role.admin}">
    <c:redirect url="/login?error=admin_required"/>
</c:if>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Claims Report</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <style>
        .main-content-area {
            display: flex;
            flex-direction: column;
        }

        .chart-container-full {
            flex-grow: 1;
            position: relative;
            padding: 1rem;
            background-color: #fff;
            border-radius: .375rem;
            box-shadow: 0 .125rem .25rem rgba(0, 0, 0, .075);
            margin-top: 1rem;
        }

        #productClaimsChart {
            width: 100% !important;
            height: 100% !important;
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

<%-- 3. Main Content Area (Now a flex container) --%>
<main class="main-content-area">

    <%-- Header Section (Doesn't grow) --%>
    <div>
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-1 pb-2 mb-3 border-bottom">
            <h1 class="h2">Claims Per Product Type</h1>
        </div>
    </div>

    <%-- Chart Container (Grows to fill space) --%>
    <div class="chart-container-full">
        <c:choose>
            <c:when test="${not empty productClaimLabels and not empty productClaimCounts}">
                <canvas id="productClaimsChart"></canvas>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info h-100 d-flex align-items-center justify-content-center" role="alert">
                    No claim data available to generate the chart.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</main>

<%-- 4. Include Footer --%>
<jsp:include page="/common/adminFooter.jsp"/>

<%-- JavaScript for Chart Rendering (Place at the end) --%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const productClaimsCtx = document.getElementById('productClaimsChart');

        // Retrieve data passed from servlet
        const productLabels = [<c:forEach var="label" items="${productClaimLabels}" varStatus="loop">'<c:out value="${label}"/>'<c:if test="${!loop.last}">, </c:if></c:forEach>];
        const productData = [<c:forEach var="count" items="${productClaimCounts}" varStatus="loop"><c:out value="${count}"/><c:if test="${!loop.last}">, </c:if></c:forEach>];

        // Check if the canvas element and data exist before creating chart
        if (productClaimsCtx && productLabels.length > 0 && productData.length > 0) {
            new Chart(productClaimsCtx, {
                type: 'bar',
                data: {
                    labels: productLabels,
                    datasets: [{
                        label: 'Total Claims',
                        data: productData,
                        backgroundColor: 'rgba(75, 192, 192, 0.6)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Total Claims Submitted by Product Type',
                            padding: {
                                top: 10,
                                bottom: 15
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += context.parsed.y;
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Product Type'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Number of Claims'
                            },
                            ticks: {
                                precision: 0 
                            }
                        }
                    }
                }
            });
        } else {
            console.log("Canvas element or chart data not found/empty, chart not rendered.");
        }
    });
</script>

</body>
</html>