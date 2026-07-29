<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Restaurant" %>
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

    RestaurantDAOImpl rDAO = new RestaurantDAOImpl();
    List<Restaurant> allRestaurants = rDAO.getAllRestaurants();
    Restaurant myRest = null;

    if (assignedRestaurantId == null || assignedRestaurantId == 0) {
        myRest = rDAO.getRestaurantByOwnerId(loggedInUser.getUserId());
        if (myRest != null) {
            assignedRestaurantId = myRest.getRestaurantId();
            adminRole = "RESTAURANT_ADMIN";
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
            session.setAttribute("assignedRestaurant", myRest);
            session.setAttribute("adminRole", adminRole);
        } else {
            assignedRestaurantId = 0;
            if (adminRole == null) {
                if ("ADMIN".equalsIgnoreCase(uRole) || "SUPER_ADMIN".equalsIgnoreCase(uRole)) {
                    adminRole = "SUPER_ADMIN";
                } else {
                    adminRole = "RESTAURANT_ADMIN";
                }
                session.setAttribute("adminRole", adminRole);
            }
        }
    } else {
        myRest = rDAO.getRestaurant(assignedRestaurantId);
    }
    
    boolean isSuperAdmin = false;
    if ("SUPER_ADMIN".equalsIgnoreCase(adminRole)) {
        isSuperAdmin = true;
    } else if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0)) {
        isSuperAdmin = true;
    }

    boolean needScopePrompt = false;
    if (session.getAttribute("scopeConfirmed") == null && (adminRole == null || (assignedRestaurantId == null || assignedRestaurantId == 0))) {
        needScopePrompt = true;
    }
    if (request.getParameter("scope_updated") != null) {
        session.setAttribute("scopeConfirmed", Boolean.TRUE);
        needScopePrompt = false;
    }

    String pageTitle = isSuperAdmin ? "Website Creator Master Deck" : "Restaurant Owner Portal";
    String cardThemeClass = isSuperAdmin ? "super-admin" : "owner-admin";
    String roleBadgeText = isSuperAdmin ? "👑 WEBSITE CREATOR / SUPER ADMIN" : "🏢 RESTAURANT OWNER PORTAL";

    String myRestUrl = "restaurants.jsp";
    String myRestName = "Restaurant #" + assignedRestaurantId;
    String myDeckTitle = "My Restaurant Deck";
    if (myRest != null) {
        myRestUrl = "editRestaurant.jsp?restaurantId=" + myRest.getRestaurantId();
        myRestName = myRest.getRestaurantName();
        myDeckTitle = myRest.getRestaurantName();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            background-color: var(--black);
            color: var(--text);
            font-family: var(--font-sans);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            background-image: radial-gradient(circle at center, #151e2e 0%, #0a0a0a 100%);
        }
        .admin-card {
            background: rgba(25, 35, 55, 0.65);
            backdrop-filter: blur(16px);
            padding: 45px 35px;
            border-radius: 20px;
            text-align: center;
            max-width: 620px;
            width: 100%;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.6);
            position: relative;
        }
        .admin-card.super-admin {
            border: 1px solid rgba(0, 240, 255, 0.3);
        }
        .admin-card.owner-admin {
            border: 1px solid rgba(212, 168, 83, 0.3);
        }
        .admin-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            border-radius: 20px 20px 0 0;
        }
        .admin-card.super-admin::before {
            background: linear-gradient(90deg, #00f0ff, #7000ff);
        }
        .admin-card.owner-admin::before {
            background: linear-gradient(90deg, #d4a853, #f39c12);
        }
        .role-header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .role-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .admin-card.super-admin .role-badge {
            background: rgba(0, 240, 255, 0.15);
            color: #00f0ff;
            border: 1px solid rgba(0, 240, 255, 0.3);
        }
        .admin-card.owner-admin .role-badge {
            background: rgba(212, 168, 83, 0.15);
            color: #d4a853;
            border: 1px solid rgba(212, 168, 83, 0.3);
        }
        .scope-switch-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #ecf0f1;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            cursor: pointer;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s var(--ease);
        }
        .scope-switch-btn:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(212, 168, 83, 0.1);
        }
        h2 {
            font-family: var(--font-serif);
            font-size: 2.2rem;
            font-weight: 400;
            margin-top: 0;
            margin-bottom: 10px;
        }
        .admin-card.super-admin h2 {
            color: #00f0ff;
        }
        .admin-card.owner-admin h2 {
            color: #d4a853;
        }
        .admin-subtitle {
            color: var(--muted);
            font-size: 0.92rem;
            line-height: 1.5;
            margin-bottom: 28px;
        }
        .admin-nav {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 30px;
        }
        .nav-lnk {
            color: var(--text);
            font-size: 0.88rem;
            font-weight: 500;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.025);
            border: 1px solid var(--border);
            padding: 18px 14px;
            border-radius: 14px;
            transition: all 0.3s var(--ease);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .nav-lnk:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }
        .admin-card.super-admin .nav-lnk:hover {
            border-color: #00f0ff;
            color: #00f0ff;
            background: rgba(0, 240, 255, 0.08);
        }
        .admin-card.owner-admin .nav-lnk:hover {
            border-color: #d4a853;
            color: #d4a853;
            background: rgba(212, 168, 83, 0.08);
        }
        .nav-lnk span.icon {
            font-size: 1.8rem;
        }
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border: 1px solid var(--border);
            color: var(--text);
            text-decoration: none;
            border-radius: 100px;
            transition: all 0.3s var(--ease);
            font-weight: 500;
            font-size: 0.88rem;
            background: rgba(255, 255, 255, 0.01);
        }
        .btn-home:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(212, 168, 83, 0.03);
        }
        .alert-toast {
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            text-align: left;
        }
        .alert-success { background: rgba(34, 197, 94, 0.15); border: 1px solid #22c55e; color: #4ade80; }
        .alert-danger { background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; }

        /* MODAL STYLING */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(5, 8, 15, 0.85);
            backdrop-filter: blur(8px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #0f172a;
            border: 1px solid var(--gold);
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            padding: 28px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.8);
            position: relative;
            text-align: left;
        }
        .modal-title {
            font-family: var(--font-serif);
            font-size: 1.6rem;
            color: var(--gold);
            margin-top: 0;
            margin-bottom: 6px;
        }
        .modal-close {
            position: absolute;
            top: 20px;
            right: 20px;
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 1.4rem;
            cursor: pointer;
        }
        .scope-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 10px;
        }
        .scope-tab-btn {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 6px;
            font-family: 'Outfit', sans-serif;
        }
        .scope-tab-btn.active {
            color: #00f0ff;
            background: rgba(0, 240, 255, 0.1);
        }
        .scope-form-group {
            margin-bottom: 18px;
        }
        .scope-form-group label {
            display: block;
            font-size: 0.85rem;
            color: #cbd5e1;
            margin-bottom: 6px;
        }
        .scope-form-group input, .scope-form-group select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.15);
            background: #1e293b;
            color: #fff;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            box-sizing: border-box;
        }
        .scope-form-group input:focus, .scope-form-group select:focus {
            border-color: #00f0ff;
            outline: none;
        }
        .btn-submit-scope {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: none;
            background: linear-gradient(135deg, #00f0ff, #0088ff);
            color: #0b0f17;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s ease;
        }
        .btn-submit-scope:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        .rest-pill-list {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 8px;
        }
        .rest-pill {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: #cbd5e1;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            cursor: pointer;
        }
        .rest-pill:hover {
            border-color: var(--gold);
            color: var(--gold);
        }
    </style>
</head>
<body>
    <div class="admin-card <%= cardThemeClass %>">
        
        <div class="role-header-bar">
            <div class="role-badge"><%= roleBadgeText %></div>
            <button onclick="openScopeModal()" class="scope-switch-btn">⚙️ Switch Role Scope</button>
        </div>

        <% 
            String scopeUpdated = request.getParameter("scope_updated");
            String scopeError = request.getParameter("scope_error");
            if ("super_admin".equals(scopeUpdated)) {
        %>
            <div class="alert-toast alert-success">✅ Authenticated as Platform Super Admin! Full access granted.</div>
        <% } else if ("restaurant_owner".equals(scopeUpdated)) { %>
            <div class="alert-toast alert-success">✅ Scoped to Restaurant #<%= assignedRestaurantId %> (<%= myRestName %>).</div>
        <% } else if (scopeError != null) { %>
            <div class="alert-toast alert-danger">❌ Authorization failed: <%= scopeError.replace("_", " ") %>.</div>
        <% } %>

        <% 
            // Query Top Selling / Most Ordered Dishes for Dashboard
            java.util.List<java.util.Map<String, Object>> dashTopItems = new java.util.ArrayList<>();
            try (java.sql.Connection con = com.tap.utility.DBConnection.getConnection()) {
                if (con != null) {
                    String dashSql = "SELECT m.menu_id, m.item_name, SUM(oi.quantity) as total_qty, SUM(oi.price * oi.quantity) as total_sales "
                                   + "FROM order_items oi JOIN menu m ON oi.menu_id = m.menu_id "
                                   + (isSuperAdmin ? "" : "WHERE m.restaurant_id = " + (assignedRestaurantId != null ? assignedRestaurantId : 0) + " ")
                                   + "GROUP BY m.menu_id, m.item_name ORDER BY total_qty DESC LIMIT 4";
                    try (java.sql.Statement st = con.createStatement();
                         java.sql.ResultSet rs = st.executeQuery(dashSql)) {
                        while (rs.next()) {
                            java.util.Map<String, Object> map = new java.util.HashMap<>();
                            map.put("id", rs.getInt("menu_id"));
                            map.put("name", rs.getString("item_name"));
                            map.put("qty", rs.getInt("total_qty"));
                            map.put("sales", rs.getDouble("total_sales"));
                            dashTopItems.add(map);
                        }
                    } catch (Exception ignored) {}
                }
            } catch (Exception ignored) {}
        %>

        <% if (isSuperAdmin) { %>
            <h2>Master Control Deck</h2>
            <p class="admin-subtitle">Welcome Creator <strong><%= loggedInUser.getName() %></strong>. Full platform control over all registered restaurants, financial analytics, audit logs, and user security.</p>
            
            <!-- TOP SELLING DISHES WIDGET -->
            <div style="background: rgba(0, 240, 255, 0.05); border: 1px solid rgba(0, 240, 255, 0.25); border-radius: 12px; padding: 18px; margin-bottom: 25px; text-align: left;">
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; margin-bottom:12px;">
                    <h3 style="color:#00f0ff; margin:0; font-size:1.1rem; font-weight:700;">🔥 Most Ordered & Top Selling Food Items</h3>
                    <a href="reports.jsp" style="color:#d4a853; text-decoration:none; font-weight:600; font-size:0.85rem;">Full Sales Reports →</a>
                </div>
                <% if (dashTopItems != null && !dashTopItems.isEmpty()) { %>
                    <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:12px;">
                        <% int rK = 1;
                           for (java.util.Map<String, Object> itm : dashTopItems) { %>
                            <div style="background:rgba(16,24,40,0.85); border:1px solid rgba(255,255,255,0.08); padding:12px; border-radius:8px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:700; color:#fff; font-size:0.92rem;">#<%= rK %> <%= itm.get("name") %></div>
                                    <div style="font-size:0.78rem; color:#94a3b8;"><%= itm.get("qty") %> orders • ₹<%= String.format("%.0f", (Double)itm.get("sales")) %></div>
                                </div>
                                <a href="editMenu.jsp?menuId=<%= itm.get("id") %>" style="color:#00f0ff; text-decoration:none; font-weight:600; font-size:0.75rem; background:rgba(0,240,255,0.12); padding:4px 8px; border-radius:4px;">Edit Item</a>
                            </div>
                        <% rK++; } %>
                    </div>
                <% } else { %>
                    <p style="color:#94a3b8; font-size:0.85rem; margin:0;">No order transactions recorded yet. Live order data will rank best-selling dishes automatically.</p>
                <% } %>
            </div>
            
            <div class="admin-nav">
                <a href="users.jsp" class="nav-lnk">
                    <span class="icon">👥</span>
                    <span>Manage Users</span>
                </a>
                <a href="restaurants.jsp" class="nav-lnk">
                    <span class="icon">🏢</span>
                    <span>All Restaurants</span>
                </a>
                <a href="menus.jsp" class="nav-lnk">
                    <span class="icon">🍔</span>
                    <span>All Menu Cards</span>
                </a>
                <a href="orders.jsp" class="nav-lnk">
                    <span class="icon">📦</span>
                    <span>All Orders Log</span>
                </a>
                <a href="loginHistory.jsp" class="nav-lnk">
                    <span class="icon">🛡️</span>
                    <span>Audit Logs</span>
                </a>
                <a href="reports.jsp" class="nav-lnk">
                    <span class="icon">📊</span>
                    <span>Global Analytics</span>
                </a>
            </div>
        <% } else { %>
            <h2><%= myDeckTitle %></h2>
            <p class="admin-subtitle">Welcome Manager <strong><%= loggedInUser.getName() %></strong>. Managing <strong><%= myRestName %></strong>. Access menu cards, live orders, audit logs, and analytics for your restaurant.</p>
            
            <div class="admin-nav">
                <a href="<%= myRestUrl %>" class="nav-lnk">
                    <span class="icon">🏢</span>
                    <span>My Restaurant</span>
                </a>
                <a href="menus.jsp" class="nav-lnk">
                    <span class="icon">🍔</span>
                    <span>Manage Menu Cards</span>
                </a>
                <a href="orders.jsp" class="nav-lnk">
                    <span class="icon">📦</span>
                    <span>My Live Orders</span>
                </a>
                <a href="loginHistory.jsp" class="nav-lnk">
                    <span class="icon">🛡️</span>
                    <span>Audit Logs</span>
                </a>
                <a href="reports.jsp" class="nav-lnk" style="grid-column: span 2;">
                    <span class="icon">📊</span>
                    <span>Restaurant Analytics</span>
                </a>
            </div>
        <% } %>

        <div style="display:flex; justify-content:center; gap:12px; flex-wrap:wrap; margin-top:25px;">
            <a href="dashboard.jsp" class="btn-home" style="border-color:#00f0ff; color:#00f0ff;">🔄 Refresh Dashboard</a>
            <a href="../index.jsp" class="btn-home">🏠 Return to Main Website</a>
        </div>
    </div>

    <!-- SCOPE SWITCHER MODAL -->
    <div id="scopeModal" class="modal-overlay">
        <div class="modal-box">
            <button class="modal-close" onclick="closeScopeModal()">×</button>
            <h3 class="modal-title">🔐 Role & Scope Selector</h3>
            <p style="font-size:0.85rem; color:#94a3b8; margin-bottom:15px;">Authenticate as Platform Super Admin (Admin ID/Email) or select your Restaurant ID for Restaurant Owner access.</p>
            
            <div class="scope-tabs">
                <button class="scope-tab-btn active" id="tab-owner-btn" onclick="switchModalTab('owner')">🏢 Restaurant Owner</button>
                <button class="scope-tab-btn" id="tab-admin-btn" onclick="switchModalTab('admin')">👑 System Super Admin</button>
            </div>

            <!-- RESTAURANT OWNER FORM -->
            <form id="form-owner" action="<%=request.getContextPath()%>/admin/switchScope" method="POST">
                <input type="hidden" name="authType" value="RESTAURANT_OWNER">
                <div class="scope-form-group">
                    <label for="restIdInput">Enter Restaurant ID</label>
                    <input type="number" id="restIdInput" name="restaurantId" placeholder="e.g. 1, 2, 3..." value="<%= assignedRestaurantId > 0 ? assignedRestaurantId : "" %>" required min="1">
                    
                    <% if (allRestaurants != null && !allRestaurants.isEmpty()) { %>
                        <div style="font-size:0.75rem; color:#94a3b8; margin-top:8px;">Quick select from database:</div>
                        <div class="rest-pill-list">
                            <% for (Restaurant r : allRestaurants) { %>
                                <span class="rest-pill" onclick="selectRestId('<%= r.getRestaurantId() %>')">#<%= r.getRestaurantId() %> <%= r.getRestaurantName() %></span>
                            <% } %>
                        </div>
                    <% } %>
                </div>
                <button type="submit" class="btn-submit-scope">Authorize Restaurant Owner Scope →</button>
            </form>

            <!-- SUPER ADMIN FORM -->
            <form id="form-admin" action="<%=request.getContextPath()%>/admin/switchScope" method="POST" style="display:none;">
                <input type="hidden" name="authType" value="ADMIN">
                <div class="scope-form-group">
                    <label for="adminIdInput">Super Admin Email / ID</label>
                    <input type="text" id="adminIdInput" name="adminIdentifier" placeholder="e.g. admin@gmail.com or 1" required>
                </div>
                <div class="scope-form-group" style="margin-top:12px;">
                    <label for="adminPasswordInput">Super Admin Security Password</label>
                    <input type="password" id="adminPasswordInput" name="adminPassword" placeholder="••••••••" required>
                    <small style="color:#64748b; font-size:0.78rem; display:block; margin-top:4px;">Enter your admin email (e.g. admin@gmail.com) and security password to authorize deck access.</small>
                </div>
                <button type="submit" class="btn-submit-scope" style="background: linear-gradient(135deg, #d4a853, #f39c12); margin-top:15px;">Authenticate Super Admin Deck →</button>
            </form>
        </div>
    </div>

    <script>
        function openScopeModal() {
            document.getElementById('scopeModal').classList.add('active');
        }
        function closeScopeModal() {
            document.getElementById('scopeModal').classList.remove('active');
        }
        function switchModalTab(tab) {
            const formOwner = document.getElementById('form-owner');
            const formAdmin = document.getElementById('form-admin');
            const btnOwner = document.getElementById('tab-owner-btn');
            const btnAdmin = document.getElementById('tab-admin-btn');
            
            if (tab === 'owner') {
                formOwner.style.display = 'block';
                formAdmin.style.display = 'none';
                btnOwner.classList.add('active');
                btnAdmin.classList.remove('active');
            } else {
                formOwner.style.display = 'none';
                formAdmin.style.display = 'block';
                btnAdmin.classList.add('active');
                btnOwner.classList.remove('active');
            }
        }
        function selectRestId(id) {
            document.getElementById('restIdInput').value = id;
        }

        // Only prompt modal if scope has not been confirmed yet in session
        window.addEventListener('DOMContentLoaded', () => {
            const needPrompt = "<%= needScopePrompt %>" === "true";
            if (needPrompt) {
                openScopeModal();
            }
        });
    </script>
</body>
</html>