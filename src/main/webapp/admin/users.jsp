<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.daoimplementation.UserDAOImpl" %>
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

    // Handle User Deletion
    String action = request.getParameter("action");
    if ("delete".equalsIgnoreCase(action)) {
        String uidStr = request.getParameter("userId");
        if (uidStr != null && !uidStr.trim().isEmpty()) {
            try {
                int delId = Integer.parseInt(uidStr.trim());
                new UserDAOImpl().deleteUser(delId);
                response.sendRedirect("users.jsp?msg=user_deleted");
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    if (!isSuperAdmin) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    List<User> list = new UserDAOImpl().getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body { background-color: #0b0f17; color: #ecf0f1; font-family: 'Outfit', sans-serif; padding: 40px; }
        .admin-card { background: rgba(16, 24, 40, 0.75); border: 1px solid rgba(0, 240, 255, 0.2); padding: 30px; border-radius: 8px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); }
        h1 { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.3); }
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; text-align: left; }
        .admin-table th, .admin-table td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .admin-table th { color: #00f0ff; font-weight: 600; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .badge.admin { background: rgba(0, 240, 255, 0.15); color: #00f0ff; }
        .badge.user, .badge.customer { background: rgba(212, 168, 83, 0.15); color: #d4a853; }
        .btn-back { display: inline-block; margin-bottom: 20px; color: #94a3b8; text-decoration: none; font-size: 14px; }
        .btn-delete { background: #e74c3c; color: #fff; border: none; padding: 6px 12px; border-radius: 4px; font-weight: 600; font-size: 0.75rem; cursor: pointer; transition: 0.2s; }
        .btn-delete:hover { background: #c0392b; transform: translateY(-1px); }
    </style>
</head>
<body>
    <div class="admin-card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; flex-wrap:wrap; gap:10px;">
            <a href="dashboard.jsp" class="btn-back" style="margin:0;">← Back to Dashboard</a>
            <a href="../index.jsp" class="btn-back" style="margin:0; color:var(--gold,#d4a853);">🏠 Return to Main Website</a>
        </div>
        <h1>Manage Grid Users</h1>
        <p>Real-time view of registered account nodes across coordinates</p>
        
        <% if ("user_deleted".equals(request.getParameter("msg"))) { %>
            <div style="background: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #2ecc71; padding: 10px 15px; border-radius: 6px; margin-top: 15px;">
                ✅ User account successfully deleted from database.
            </div>
        <% } %>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Registered At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (list != null && !list.isEmpty()) { 
                    for (User u : list) {
                %>
                    <tr>
                        <td>#<%= u.getId() %></td>
                        <td><%= u.getName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() != null ? u.getPhone() : "N/A" %></td>
                        <% String userRole = u.getRole() != null ? u.getRole() : "CUSTOMER"; %>
                        <td><span class="badge <%= userRole.toLowerCase() %>"><%= userRole.toUpperCase() %></span></td>
                        <td><%= u.getCreatedAt() %></td>
                        <td>
                            <form action="users.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete user #<%= u.getId() %> (<%= u.getEmail() %>)?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                <button type="submit" class="btn-delete">🗑️ Delete User</button>
                            </form>
                        </td>
                    </tr>
                <% 
                    }
                } else {
                %>
                    <tr>
                        <td colspan="7">No users found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>