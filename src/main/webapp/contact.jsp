<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Support — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/info-card.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="noise"></div>

    <!-- HEADER -->
    <header id="hdr">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div>
            BiteSpeed
        </a>
        <nav>
            <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">Home</a>
            <a href="<%=request.getContextPath()%>/restaurants.jsp" class="nav-link">Restaurants</a>
            <a href="<%=request.getContextPath()%>/menu.jsp" class="nav-link">Menu</a>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link">Cart</a>
            <a href="<%=request.getContextPath()%>/orders.jsp" class="nav-link">Orders</a>
        </nav>
        <div class="hactions">
            <button class="theme-btn" id="theme-toggle" onclick="toggleTheme()" aria-label="Toggle Light/Dark Theme">
                <svg class="theme-icon sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="5"></circle>
                    <line x1="12" y1="1" x2="12" y2="3"></line>
                    <line x1="12" y1="21" x2="12" y2="23"></line>
                    <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                    <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                    <line x1="1" y1="12" x2="3" y2="12"></line>
                    <line x1="21" y1="12" x2="23" y2="12"></line>
                    <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                    <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                </svg>
                <svg class="theme-icon moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                </svg>
            </button>
            <div id="auth-header-container" class="auth-header-container">
                <a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn" style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign In</a>
                <a href="<%=request.getContextPath()%>/register.jsp" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign Up</a>
            </div>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                Cart <span class="cbadge" id="cbadge">0</span>
            </a>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <div class="info-card" style="margin-top: 120px;">
        <h2>Contact Support</h2>
        <p>BiteSpeed 24/7 Quantum Dispatch Concierge. Reach out to our logistics support team at support@bitespeed.in or call 1800-BITESPEED.</p>
        <a href="<%=request.getContextPath()%>/index.jsp" class="btn-home">Return to Home</a>
    </div>
</body>
</html>