<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }
    
    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    String adminRole = (String) session.getAttribute("adminRole");
    RestaurantDAOImpl rDAO = new RestaurantDAOImpl();

    // Handle Restaurant Deletion
    String action = request.getParameter("action");
    if ("delete".equalsIgnoreCase(action)) {
        String ridStr = request.getParameter("restaurantId");
        if (ridStr != null && !ridStr.trim().isEmpty()) {
            try {
                int delId = Integer.parseInt(ridStr.trim());
                rDAO.deleteRestaurant(delId);
                response.sendRedirect("restaurants.jsp?msg=restaurant_deleted");
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
    
    if (assignedRestaurantId == null || assignedRestaurantId == 0) {
        Restaurant myRest = rDAO.getRestaurantByOwnerId(loggedInUser.getUserId());
        if (myRest != null) {
            assignedRestaurantId = myRest.getRestaurantId();
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
        }
    }

    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));
        
    // If Vendor/Restaurant Owner, auto-redirect to edit their specific restaurant
    if (!isSuperAdmin && assignedRestaurantId != null && assignedRestaurantId > 0) {
        response.sendRedirect("editRestaurant.jsp?restaurantId=" + assignedRestaurantId);
        return;
    }

    List<Restaurant> restaurantList = rDAO.getAllRestaurants();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body { background-color: #0b0f17; color: #ecf0f1; font-family: 'Outfit', sans-serif; padding: 40px; }
        .admin-card { background: rgba(16, 24, 40, 0.75); border: 1px solid rgba(0, 240, 255, 0.2); padding: 30px; border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); }
        .header-bar { display: flex; justify-content: space-between; align-items: center; }
        h1 { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.3); margin: 0; }
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; text-align: left; }
        .admin-table th, .admin-table td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .admin-table th { color: #00f0ff; font-weight: 600; }
        .btn-add { background: #00f0ff; color: #0b0f17; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; }
        .btn-back { display: inline-block; margin-bottom: 20px; color: #94a3b8; text-decoration: none; font-size: 14px; }
        .thumb-img { width: 45px; height: 45px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(0,240,255,0.3); }
        .btn-delete-rest { background: #e74c3c; color: #fff; border: none; padding: 5px 10px; border-radius: 4px; font-weight: 600; font-size: 0.75rem; cursor: pointer; transition: 0.2s; }
        .btn-delete-rest:hover { background: #c0392b; transform: translateY(-1px); }
    </style>
</head>
<body>
    <div class="admin-card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; flex-wrap:wrap; gap:10px;">
            <a href="dashboard.jsp" class="btn-back" style="margin:0;">← Back to Dashboard</a>
            <a href="../index.jsp" class="btn-back" style="margin:0; color:var(--gold,#d4a853);">🏠 Return to Main Website</a>
        </div>
        <div class="header-bar">
            <h1>Manage Restaurant Hubs</h1>
            <a href="addRestaurant.jsp" class="btn-add">+ Add Restaurant</a>
        </div>
        <p>Live active restaurants stored across MySQL database</p>
        
        <% if ("restaurant_deleted".equals(request.getParameter("msg"))) { %>
            <div style="background: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #2ecc71; padding: 10px 15px; border-radius: 6px; margin-top: 15px; margin-bottom: 15px;">
                ✅ Restaurant node successfully deleted from database.
            </div>
        <% } %>
        
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Photo</th>
                    <th>ID</th>
                    <th>Restaurant Name</th>
                    <th>Cuisine Type</th>
                    <th>City</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (restaurantList != null && !restaurantList.isEmpty()) { 
                    for (Restaurant r : restaurantList) {
                        String img = (r.getImage() != null && !r.getImage().trim().isEmpty()) ? r.getImage() : "../images/res.jpeg";
                %>
                    <tr>
                        <td><img src="<%= img %>" class="thumb-img" alt="cover"></td>
                        <td>#REST-<%= r.getRestaurantId() %></td>
                        <td><strong style="color:#fff;"><%= r.getRestaurantName() %></strong></td>
                        <td><%= r.getCuisineType() != null ? r.getCuisineType() : "Gourmet" %></td>
                        <td><%= r.getCity() != null ? r.getCity() : "Central" %></td>
                        <td style="color:#d4a853; font-weight:600;">⭐ <%= r.getRating() %></td>
                        <td>
                            <div style="display:flex; gap:10px; align-items:center;">
                                <a href="editRestaurant.jsp?restaurantId=<%= r.getRestaurantId() %>" style="color:#00f0ff; text-decoration:none; font-weight:600;">Edit & Photos →</a>
                                <form action="restaurants.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete restaurant #<%= r.getRestaurantId() %> (<%= r.getRestaurantName() %>)?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                    <button type="submit" class="btn-delete-rest">🗑️ Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% 
                    }
                } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding:30px; color:#94a3b8;">No restaurants found in database.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>