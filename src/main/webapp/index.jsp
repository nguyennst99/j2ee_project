<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to ABC Insurance Protection Plan</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80'); /* Example background image */
            background-size: cover;
            background-position: center;
            color: white;
            padding: 8rem 0;
            text-align: center;
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .hero-section p {
            font-size: 1.25rem;
            font-weight: 300;
            margin-bottom: 2rem;
        }

        .features-section {
            padding: 4rem 0;
        }

        .feature-card {
            border: none;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 3rem;
            color: #0d6efd;
            margin-bottom: 1rem;
        }

        .footer {
            background-color: #343a40;
            color: #f8f9fa;
            padding: 2rem 0;
            margin-top: 3rem;
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>
<body>

<%-- Navbar (Optional - Can add a simple one if needed, or rely on hero buttons) --%>
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="/">
            ABC Insurance
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavLanding"
                aria-controls="navbarNavLanding" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavLanding">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/login">Login</a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-primary ms-lg-2" href="/register">Register</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<%-- Hero Section --%>
<section class="hero-section">
    <div class="container">
        <h1>Protect Your Devices with Confidence</h1>
        <p>Simple, reliable protection plans for your valuable electronics. Register and manage your plans and claims
            online.</p>
        <a href="/register" class="btn btn-primary btn-lg me-2">Get Started</a>
        <a href="/login" class="btn btn-outline-light btn-lg">Login</a>
    </div>
</section>

<%-- Features Section --%>
<section class="features-section">
    <div class="container">
        <h2 class="text-center mb-5">Why Choose ABC Insurance?</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                    <%-- Bootstrap Icon --%>
                    <div class="card-body">
                        <h5 class="card-title">Reliable Coverage</h5>
                        <p class="card-text">Comprehensive protection against accidental damage, malfunctions, and
                            more.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon"><i class="bi bi-laptop"></i></div>
                    <%-- Bootstrap Icon --%>
                    <div class="card-body">
                        <h5 class="card-title">Easy Online Management</h5>
                        <p class="card-text">Register products and file claims quickly through our user-friendly
                            website.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon"><i class="bi bi-headset"></i></div>
                    <%-- Bootstrap Icon --%>
                    <div class="card-body">
                        <h5 class="card-title">Fast Support</h5>
                        <p class="card-text">Our dedicated support team is here to help you with any questions or
                            claims.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Footer --%>
<footer class="footer">
    <div class="container">
        <p class="mb-0">© <%= java.time.Year.now().getValue() %> ABC Insurance Company | Group 2 Project. All Rights
            Reserved.</p>
    </div>
</footer>

<%-- Bootstrap JS --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>