<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.UserAddress" %>
<%@ page import="com.tap.daoimplementation.UserAddressDAOImpl" %>
<%@ page import="com.tap.daoimplementation.OrderDAOImpl" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login?error=please_login");
        return;
    }
    
    java.util.Map<Integer, com.tap.model.CartItem> profCart = (java.util.Map<Integer, com.tap.model.CartItem>) session.getAttribute("cart");
    int profCartCount = 0;
    if (profCart != null) {
        for (com.tap.model.CartItem item : profCart.values()) {
            profCartCount += item.getQuantity();
        }
    }
    
    // Fetch default shipping address
    String userAddr = "No default address saved";
    try {
        List<UserAddress> addList = new UserAddressDAOImpl().getAddressesByUser(loggedInUser.getUserId());
        if (addList != null && !addList.isEmpty()) {
            UserAddress ua = addList.get(0);
            userAddr = ua.getAddressLine() + (ua.getCity() != null ? ", " + ua.getCity() : "") + (ua.getState() != null ? ", " + ua.getState() : "");
        }
    } catch (Exception e) {}
    
    // Fetch total orders count
    int totalOrdersCount = 0;
    try {
        totalOrdersCount = new OrderDAOImpl().getOrdersByUser(loggedInUser.getUserId()).size();
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Settings — BiteSpeed</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/profile.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    
    <style>
        .profile-main {
            margin-top: 120px !important;
            padding-bottom: 60px;
        }
        .profile-card {
            max-width: 750px;
            margin: 0 auto;
        }
        .info-badge-row {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }
        .prof-badge-card {
            flex: 1;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }
        .prof-badge-card h4 {
            margin: 0 0 6px 0;
            font-size: 0.8rem;
            color: var(--muted);
            text-transform: uppercase;
        }
        .prof-badge-card p {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--gold);
        }
    </style>
    
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
                <span class="user-greeting" style="color:var(--text-glow); font-weight:500; margin-right:15px;">Hi, <%= loggedInUser.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                <% if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                <% } %>
                <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
            </div>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                Cart <span class="cbadge" id="cbadge"><%= profCartCount %></span>
            </a>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="profile-main">
        <div class="profile-card">
            <h2>User Details & Telemetry</h2>
            <p class="profile-sub">Current account coordinates recorded in BiteSpeed database</p>
            
            <% 
                String success = request.getParameter("success");
                if ("profile_updated".equals(success)) {
            %>
                <div class="alert alert-success" style="background:rgba(34,197,94,0.15); border:1px solid #22c55e; color:#22c55e; padding:12px 18px; border-radius:8px; margin-bottom:20px;">✅ User profile node updated successfully.</div>
            <% } %>

            <div class="info-badge-row">
                <div class="prof-badge-card">
                    <h4>Account Status</h4>
                    <p style="color:#00f0ff; font-size:1rem;"><%= loggedInUser.getStatus() != null ? loggedInUser.getStatus() : "ACTIVE" %> • VIP</p>
                </div>
                <div class="prof-badge-card">
                    <h4>Total Dispatches</h4>
                    <p><%= totalOrdersCount %> Orders</p>
                </div>
                <div class="prof-badge-card">
                    <h4>Account Role</h4>
                    <p style="color:#2ecc71; font-size:1rem; text-transform:uppercase;"><%= loggedInUser.getRole() != null ? loggedInUser.getRole() : "CUSTOMER" %></p>
                </div>
            </div>

            <div class="profile-info-grid">
                <div class="info-row">
                    <span class="label">Legal Name</span>
                    <span class="val"><%= loggedInUser.getFullName() %></span>
                </div>
                <div class="info-row">
                    <span class="label">Email Address</span>
                    <span class="val"><%= loggedInUser.getEmail() %></span>
                </div>
                <div class="info-row">
                    <span class="label">Phone Coordinates</span>
                    <span class="val"><%= loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "Not Configured" %></span>
                </div>
                <div class="info-row">
                    <span class="label">Gender</span>
                    <span class="val"><%= loggedInUser.getGender() != null ? loggedInUser.getGender() : "Not Specified" %></span>
                </div>
                <div class="info-row">
                    <span class="label">Date of Birth</span>
                    <span class="val"><%= loggedInUser.getDob() != null ? loggedInUser.getDob() : "Not Specified" %></span>
                </div>
                <div class="info-row">
                    <span class="label">Primary Delivery Address</span>
                    <span class="val" style="color:#00f0ff;"><%= userAddr %></span>
                </div>
                <div class="info-row">
                    <span class="label">Registration Timestamp</span>
                    <span class="val"><%= loggedInUser.getCreatedAt() != null ? loggedInUser.getCreatedAt() : "2026-07-17" %></span>
                </div>
            </div>

            <div class="profile-actions" style="margin-top:30px;">
                <a href="editProfile.jsp" class="btn-primary">Modify Account Details</a>
                <a href="orders.jsp" class="btn-ghost">View Dispatch History</a>
            </div>
        </div>
    </main>
</body>
</html>
