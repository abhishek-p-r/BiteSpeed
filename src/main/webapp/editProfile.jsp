<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.UserAddress" %>
<%@ page import="com.tap.daoimplementation.UserAddressDAOImpl" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login?error=please_login");
        return;
    }
    String existingAddress = "";
    try {
        List<UserAddress> addList = new UserAddressDAOImpl().getAddressesByUser(loggedInUser.getUserId());
        if (addList != null && !addList.isEmpty()) {
            UserAddress ua = addList.get(0);
            existingAddress = ua.getAddressLine() + (ua.getCity() != null ? ", " + ua.getCity() : "");
        }
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/profile.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .profile-main { margin-top: 120px !important; padding-bottom: 60px; }
        .profile-card { max-width: 650px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 0.85rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; }
        .form-group input, .form-group select { width: 100%; padding: 12px 16px; background: rgba(255,255,255,0.04); border: 1px solid var(--border); border-radius: 8px; color: #fff; font-family: 'Outfit', sans-serif; font-size: 0.95rem; }
        .form-group input:focus, .form-group select:focus { border-color: var(--gold); outline: none; }
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
                    <line x1="18.36" y1="18.36" x2="19.78" y2="18.36"></line>
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
                <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
            </div>
        </div>
    </header>

    <main class="profile-main">
        <div class="profile-card">
            <h2>Modify Account Details</h2>
            <p class="profile-sub">Update coordinates & delivery parameters for your account profile</p>
            
            <% 
                String error = request.getParameter("error");
                if ("update_failed".equals(error)) {
            %>
                <div class="alert alert-error" style="background:rgba(239,68,68,0.15); border:1px solid #ef4444; color:#ef4444; padding:12px 18px; border-radius:8px; margin-bottom:20px;">❌ Profile update operation failed.</div>
            <% } %>

            <form action="profile" method="POST" class="profile-form">
                <div class="form-group">
                    <label for="name">Legal Name</label>
                    <input type="text" id="name" name="name" value="<%= loggedInUser.getFullName() %>" required autocomplete="name">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Coordinates</label>
                    <input type="tel" id="phone" name="phone" value="<%= loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "" %>" required autocomplete="tel">
                </div>
                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="Not Specified" <%= "Not Specified".equalsIgnoreCase(loggedInUser.getGender()) ? "selected" : "" %>>Prefer Not to Say</option>
                        <option value="Male" <%= "Male".equalsIgnoreCase(loggedInUser.getGender()) ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equalsIgnoreCase(loggedInUser.getGender()) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equalsIgnoreCase(loggedInUser.getGender()) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" value="<%= loggedInUser.getDob() != null ? loggedInUser.getDob().toString() : "" %>">
                </div>
                <div class="form-group">
                    <label for="address">Primary Delivery Address</label>
                    <input type="text" id="address" name="address" value="<%= existingAddress %>" placeholder="e.g. MG Road, Indiranagar, Bengaluru - 560038">
                </div>
                
                <div class="profile-actions" style="margin-top:25px; display:flex; gap:15px;">
                    <button type="submit" class="btn-primary" style="padding:12px 28px;">Save Changes →</button>
                    <a href="profile.jsp" class="btn-ghost" style="padding:12px 24px; text-decoration:none;">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
