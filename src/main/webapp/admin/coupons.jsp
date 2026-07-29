<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !"admin".equalsIgnoreCase(loggedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grid Coupon Discount Manager — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            background-color: #0b0f17;
            color: #ecf0f1;
            font-family: 'Outfit', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
            background-image: radial-gradient(circle at center, #151e2e 0%, #0b0f17 100%);
        }
        .admin-card {
            background: rgba(16, 24, 40, 0.75);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(0, 240, 255, 0.2);
            padding: 40px;
            border-radius: 8px;
            text-align: center;
            max-width: 450px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        }
        h2 {
            color: #00f0ff;
            margin-top: 0;
            text-shadow: 0 0 10px rgba(0, 240, 255, 0.3);
        }
        p {
            color: #94a3b8;
            font-size: 14px;
            line-height: 1.6;
        }
        .btn-home {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            border: 1px solid #d4a853;
            color: #d4a853;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .btn-home:hover {
            background: #d4a853;
            color: #0b0f17;
            box-shadow: 0 0 15px rgba(212, 168, 83, 0.4);
        }
        .admin-nav {
            margin-top: 15px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        .nav-lnk {
            color: #00f0ff;
            font-size: 12px;
            text-decoration: none;
            background: rgba(0, 240, 255, 0.1);
            padding: 4px 8px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="admin-card">
        <h2>Grid Coupon Discount Manager</h2>
        <p>BiteSpeed Administrative panel hub coordinate. This view handles administrative config options and audits.</p>
        
        <div class="admin-nav">
            <a href="users.jsp" class="nav-lnk">Users List</a>
            <a href="restaurants.jsp" class="nav-lnk">Restaurants</a>
            <a href="menus.jsp" class="nav-lnk">Menus</a>
            <a href="orders.jsp" class="nav-lnk">Orders</a>
        </div>

        <a href="../index.jsp" class="btn-home">Return to main deck</a>
    </div>
</body>
</html>