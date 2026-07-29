<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.daoimplementation.MenuDAOImpl" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }
    String uRole = loggedInUser.getRole();
    String adminRole = (String) session.getAttribute("adminRole");
    if (!"ADMIN".equalsIgnoreCase(uRole) && !"SUPER_ADMIN".equalsIgnoreCase(uRole) && !"RESTAURANT_ADMIN".equalsIgnoreCase(uRole) && !"VENDOR".equalsIgnoreCase(uRole) && !"OWNER".equalsIgnoreCase(uRole) && !"SUPER_ADMIN".equalsIgnoreCase(adminRole) && !"RESTAURANT_ADMIN".equalsIgnoreCase(adminRole)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
    
    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    
    if (assignedRestaurantId == null || assignedRestaurantId == 0) {
        com.tap.model.Restaurant r = new RestaurantDAOImpl().getRestaurantByOwnerId(loggedInUser.getUserId());
        if (r != null) {
            assignedRestaurantId = r.getRestaurantId();
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
        }
    }

    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    MenuDAOImpl menuDAO = new MenuDAOImpl();

    // Handle Menu Item Deletion
    String action = request.getParameter("action");
    if ("delete".equalsIgnoreCase(action)) {
        String mIdStr = request.getParameter("menuId");
        if (mIdStr != null && !mIdStr.trim().isEmpty()) {
            try {
                int delId = Integer.parseInt(mIdStr.trim());
                Menu mDel = menuDAO.getMenu(delId);
                if (mDel != null) {
                    if (isSuperAdmin || (assignedRestaurantId != null && assignedRestaurantId == mDel.getRestaurantId())) {
                        menuDAO.deleteMenu(delId);
                        response.sendRedirect("menus.jsp?msg=item_deleted");
                        return;
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    int filterRestId = 0;
    try {
        filterRestId = Integer.parseInt(request.getParameter("restaurantId"));
    } catch (Exception e) {}

    List<Menu> menuList = null;
    
    if (isSuperAdmin) {
        if (filterRestId > 0) {
            menuList = menuDAO.getMenuByRestaurantId(filterRestId);
        } else {
            menuList = menuDAO.getAllMenus();
        }
    } else if (assignedRestaurantId != null && assignedRestaurantId > 0) {
        menuList = menuDAO.getMenuByRestaurantId(assignedRestaurantId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Resto-Menu Items — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body { background-color: #0b0f17; color: #ecf0f1; font-family: 'Outfit', sans-serif; padding: 30px 20px; margin: 0; }
        .admin-card { background: rgba(16, 24, 40, 0.75); border: 1px solid rgba(0, 240, 255, 0.2); padding: 30px; border-radius: 14px; box-shadow: 0 10px 35px rgba(0,0,0,0.6); max-width: 1200px; margin: 0 auto; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; flex-wrap: wrap; gap: 15px; }
        h1 { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.3); margin: 0; font-size: 1.8rem; }
        .btn-add { background: linear-gradient(135deg, #00f0ff, #0088ff); color: #0b0f17; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 0.9rem; transition: all 0.3s ease; }
        .btn-add:hover { opacity: 0.9; transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0, 240, 255, 0.4); }
        .btn-back { display: inline-block; color: #94a3b8; text-decoration: none; font-size: 0.88rem; transition: color 0.3s ease; }
        .btn-back:hover { color: #00f0ff; }
        
        .table-responsive { width: 100%; overflow-x: auto; margin-top: 20px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.08); }
        .admin-table { width: 100%; border-collapse: collapse; text-align: left; min-width: 750px; }
        .admin-table th, .admin-table td { padding: 16px 14px; border-bottom: 1px solid rgba(255,255,255,0.08); vertical-align: middle; line-height: 1.4; word-break: break-word; }
        .admin-table th { color: #00f0ff; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; background: rgba(0, 240, 255, 0.05); }
        .thumb-img { width: 48px; height: 48px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(0,240,255,0.3); display: block; }
        .badge-avail { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; background: rgba(34, 197, 94, 0.15); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.3); display: inline-block; }
        .badge-unavail { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); display: inline-block; }
        .dish-title { color: #fff; font-weight: 600; font-size: 0.98rem; margin: 0; }
        .btn-edit { color: #00f0ff; text-decoration: none; font-weight: 600; font-size: 0.88rem; transition: all 0.3s ease; }
        .btn-edit:hover { color: #d4a853; text-decoration: underline; }
        .btn-delete-item { background: #e74c3c; color: #fff; border: none; padding: 5px 10px; border-radius: 4px; font-weight: 600; font-size: 0.75rem; cursor: pointer; transition: 0.2s; }
        .btn-delete-item:hover { background: #c0392b; transform: translateY(-1px); }
    </style>
</head>
<body>
    <div class="admin-card">
        <div style="display:flex; justify-content:space-between; align-items:center; background: rgba(255,255,255,0.03); border: 1px solid <%= isSuperAdmin ? "rgba(0, 240, 255, 0.3)" : "rgba(212, 168, 83, 0.3)" %>; padding: 10px 16px; border-radius: 8px; margin-bottom: 20px; flex-wrap:wrap; gap:10px;">
            <span style="font-weight:700; font-size:0.85rem; color:<%= isSuperAdmin ? "#00f0ff" : "#d4a853" %>;">
                <%= isSuperAdmin ? "👑 PLATFORM SUPER ADMIN MODE (All Restaurants Access)" : "🏢 RESTAURANT ADMIN MODE (Scoped to Resto #" + assignedRestaurantId + ")" %>
            </span>
            <a href="dashboard.jsp" style="color:#94a3b8; font-size:0.82rem; text-decoration:none; background:rgba(255,255,255,0.06); padding:4px 12px; border-radius:15px; border:1px solid rgba(255,255,255,0.15);">⚙️ Switch Role Scope</a>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:10px;">
            <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
            <a href="../index.jsp" class="btn-back" style="color:var(--gold,#d4a853);">🏠 Return to Main Website</a>
        </div>

        <div class="header-bar">
            <h1>Manage Resto-Menu Items</h1>
            <div style="display:flex; gap:12px; align-items:center;">
                <% if (isSuperAdmin) { 
                    List<com.tap.model.Restaurant> allR = new RestaurantDAOImpl().getAllRestaurants();
                %>
                    <select onchange="location.href='menus.jsp?restaurantId='+this.value" style="background:#1e293b; color:#fff; border:1px solid rgba(0,240,255,0.3); padding:8px 12px; border-radius:6px; font-family:'Outfit',sans-serif; font-size:0.85rem;">
                        <option value="0" <%= filterRestId == 0 ? "selected" : "" %>>🌐 All Restaurants Filter</option>
                        <% if (allR != null) { for (com.tap.model.Restaurant rItem : allR) { %>
                            <option value="<%= rItem.getRestaurantId() %>" <%= filterRestId == rItem.getRestaurantId() ? "selected" : "" %>>
                                #<%= rItem.getRestaurantId() %> <%= rItem.getRestaurantName() %>
                            </option>
                        <% } } %>
                    </select>
                <% } %>
                <a href="addMenu.jsp" class="btn-add">+ Add Dish Item</a>
            </div>
        </div>
        <p style="color:#94a3b8; font-size:0.9rem; margin-top:4px; margin-bottom:20px;">
            <%= isSuperAdmin ? (filterRestId > 0 ? "Filtered dish items for Restaurant #" + filterRestId : "Live food items recorded across all restaurant menus") : "Food dishes registered for your restaurant menu" %>
        </p>
        
        <% if ("item_deleted".equals(request.getParameter("msg"))) { %>
            <div style="background: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #2ecc71; padding: 10px 15px; border-radius: 6px; margin-bottom: 20px;">
                ✅ Menu dish item successfully removed from database.
            </div>
        <% } %>
        
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 70px;">Photo</th>
                        <th style="width: 120px;">Menu ID</th>
                        <th>Dish Name</th>
                        <% if (isSuperAdmin) { %><th style="width: 130px;">Restaurant</th><% } %>
                        <th style="width: 110px;">Price</th>
                        <th style="width: 130px;">Status</th>
                        <th style="width: 200px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (menuList != null && !menuList.isEmpty()) { 
                        for (Menu m : menuList) {
                            String rawImg = m.getImage();
                            String dishImg = "../images/food1.jpg";
                            if (rawImg != null && !rawImg.trim().isEmpty()) {
                                rawImg = rawImg.trim();
                                if (rawImg.startsWith("http://") || rawImg.startsWith("https://") || rawImg.startsWith("data:")) {
                                    dishImg = rawImg;
                                } else if (rawImg.startsWith("../") || rawImg.startsWith("/")) {
                                    dishImg = rawImg;
                                } else if (rawImg.startsWith("images/")) {
                                    dishImg = "../" + rawImg;
                                } else {
                                    dishImg = "../images/" + rawImg;
                                }
                            }
                    %>
                        <tr>
                            <td><img src="<%= dishImg %>" class="thumb-img" alt="dish" onerror="this.src='../images/food1.jpg'"></td>
                            <td style="font-weight:600; color:#94a3b8;">#MENU-<%= m.getMenuId() %></td>
                            <td><div class="dish-title"><%= m.getItemName() %></div></td>
                            <% if (isSuperAdmin) { %><td style="color:#cbd5e1;">Resto #<%= m.getRestaurantId() %></td><% } %>
                            <td style="color:#d4a853; font-weight:700; font-size:1rem;">₹<%= String.format("%.2f", m.getPrice()) %></td>
                            <td>
                                <% if (m.isAvailable()) { %>
                                    <span class="badge-avail">AVAILABLE</span>
                                <% } else { %>
                                    <span class="badge-unavail">UNAVAILABLE</span>
                                <% } %>
                            </td>
                            <td>
                                <div style="display:flex; gap:12px; align-items:center;">
                                    <a href="editMenu.jsp?menuId=<%= m.getMenuId() %>" class="btn-edit">Edit →</a>
                                    <form action="menus.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete dish #<%= m.getMenuId() %> (<%= m.getItemName() %>)?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                        <button type="submit" class="btn-delete-item">🗑️ Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% 
                        }
                    } else {
                    %>
                        <tr>
                            <td colspan="<%= isSuperAdmin ? "7" : "6" %>" style="text-align:center; padding:40px; color:#94a3b8;">
                                No menu items found for this restaurant. Click '+ Add Dish Item' to create dishes.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>