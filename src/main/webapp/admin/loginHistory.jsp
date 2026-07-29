<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.daoimplementation.UserDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }

    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    String adminRole = (String) session.getAttribute("adminRole");
    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    List<User> rawUserList = new UserDAOImpl().getAllUsers();
    List<User> userList = new ArrayList<>();
    
    if (rawUserList != null) {
        for (User u : rawUserList) {
            if (isSuperAdmin || (u.getUserId() == loggedInUser.getUserId())) {
                userList.add(u);
            }
        }
    }
    
    Collections.sort(userList, new Comparator<User>() {
        @Override
        public int compare(User u1, User u2) {
            if (u1.getLastLogin() == null && u2.getLastLogin() == null) return 0;
            if (u1.getLastLogin() == null) return 1;
            if (u2.getLastLogin() == null) return -1;
            return u2.getLastLogin().compareTo(u1.getLastLogin());
        }
    });
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Audit Log — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            background-color: var(--black);
            color: var(--text);
            font-family: var(--font-sans);
            margin: 0;
            padding: 40px;
            background-image: radial-gradient(circle at center, #151e2e 0%, #0a0a0a 100%);
            min-height: 100vh;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeUp 0.6s var(--ease) both;
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 20px;
        }

        .header-actions h1 {
            font-family: var(--font-serif);
            font-size: 2.5rem;
            color: var(--gold);
            text-shadow: 0 0 15px rgba(212, 168, 83, 0.25);
            margin: 0;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border);
            color: var(--text);
            padding: 10px 20px;
            border-radius: 100px;
            text-decoration: none;
            transition: all 0.3s var(--ease);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .btn-action:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(212, 168, 83, 0.05);
            transform: translateY(-2px);
        }

        .audit-card {
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            margin-bottom: 30px;
        }

        .audit-info {
            color: var(--muted);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        .audit-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
        }

        .audit-table th {
            color: var(--gold);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.08em;
            padding: 16px 20px;
            border-bottom: 2px solid var(--border);
            text-align: left;
        }

        .audit-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            font-size: 0.9rem;
            color: var(--text);
            vertical-align: middle;
        }

        .audit-table tr:hover td {
            background: rgba(212, 168, 83, 0.02);
            color: #fff;
        }

        .user-id {
            color: var(--gold);
            font-weight: 600;
        }

        .user-role {
            padding: 4px 10px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            display: inline-block;
        }

        .user-role.admin {
            background: rgba(0, 240, 255, 0.1);
            color: #00f0ff;
            border: 1px solid rgba(0, 240, 255, 0.2);
        }

        .user-role.user {
            background: rgba(212, 168, 83, 0.1);
            color: var(--gold);
            border: 1px solid rgba(212, 168, 83, 0.2);
        }

        .login-time {
            font-family: monospace;
            color: #00f0ff;
            text-shadow: 0 0 5px rgba(0, 240, 255, 0.2);
        }

        .never-login {
            color: var(--muted);
            font-style: italic;
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="noise"></div>
    <div class="dashboard-container">
        <div class="header-actions">
            <h1>Security Audit Log</h1>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                <a href="dashboard.jsp" class="btn-action">← Back to Dashboard</a>
                <a href="../index.jsp" class="btn-action" style="border-color:var(--gold,#d4a853); color:var(--gold,#d4a853);">🏠 Return to Main Website</a>
            </div>
        </div>

        <div class="audit-card">
            <p class="audit-info">
                This access log records user authentication milestones. System coordinates list the active account nodes and their last verified login sessions.
            </p>

            <table class="audit-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>System Role</th>
                        <th>Last Verified Login</th>
                        <th>Registration Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (userList != null && !userList.isEmpty()) { 
                        for (User u : userList) {
                    %>
                        <tr>
                            <td class="user-id">#<%= u.getId() %></td>
                            <td style="font-weight: 500;"><%= u.getName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <% String rStr = (u.getRole() != null && !u.getRole().trim().isEmpty()) ? u.getRole() : "CUSTOMER"; %>
                                <span class="user-role <%= rStr.toLowerCase() %>">
                                    <%= rStr.toUpperCase() %>
                                </span>
                            </td>
                            <td>
                                <% if (u.getLastLogin() != null) { %>
                                    <span class="login-time"><%= u.getLastLogin() %></span>
                                <% } else { %>
                                    <span class="never-login">No session recorded</span>
                                <% } %>
                            </td>
                            <td style="color: var(--muted);"><%= u.getCreatedAt() %></td>
                        </tr>
                    <% 
                        }
                    } else {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--muted); padding: 30px;">
                                ⚠️ No registered account nodes detected.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>