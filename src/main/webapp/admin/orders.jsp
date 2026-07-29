<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimplementation.OrderDAOImpl" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
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

    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    com.tap.dao.RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    if (assignedRestaurantId == null || assignedRestaurantId == 0) {
        Restaurant myRest = restaurantDAO.getRestaurantByOwnerId(loggedInUser.getUserId());
        if (myRest != null) {
            assignedRestaurantId = myRest.getRestaurantId();
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
        }
    }

    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    com.tap.dao.OrderDAO orderDAO = new OrderDAOImpl();
    com.tap.dao.UserDAO userDAO = new UserDAOImpl();

    // Handle order status update POST request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String orderIdParam = request.getParameter("orderId");
        String status = request.getParameter("status");
        if (orderIdParam != null && status != null) {
            try {
                int oId = Integer.parseInt(orderIdParam);
                Order o = orderDAO.getOrder(oId);
                if (o != null) {
                    // Security check for vendor admin
                    if (!isSuperAdmin && (assignedRestaurantId == null || !assignedRestaurantId.equals(o.getRestaurantId()))) {
                        // Reject update for another restaurant's order
                    } else {
                        o.setOrderStatus(status.trim().toUpperCase());
                        if ("DELIVERED".equalsIgnoreCase(status)) {
                            o.setPaymentStatus("SUCCESS");
                        }
                        orderDAO.updateOrder(o);
                        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp?updated=" + oId);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    int filterRestId = 0;
    try {
        filterRestId = Integer.parseInt(request.getParameter("restaurantId"));
    } catch (Exception e) {}

    List<Order> orders = null;
    if (isSuperAdmin) {
        if (filterRestId > 0) {
            orders = orderDAO.getOrdersByRestaurantId(filterRestId);
        } else {
            orders = orderDAO.getAllOrders();
        }
    } else if (assignedRestaurantId != null && assignedRestaurantId > 0) {
        orders = orderDAO.getOrdersByRestaurantId(assignedRestaurantId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Logistics Registry — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/variables.css">
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/components.css">
    <link rel="stylesheet" href="../css/layout.css">
    
    <style>
        body {
            background-color: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            margin: 0;
            min-height: 100vh;
        }

        .admin-container {
            max-width: 1200px;
            margin: 140px auto 50px auto;
            padding: 0 20px;
        }

        .header-panel {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 20px;
        }

        .header-panel h1 {
            font-size: 2.2rem;
            color: var(--gold);
            margin: 0;
            font-weight: 600;
        }

        .admin-nav-row {
            display: flex;
            gap: 12px;
        }

        .nav-btn {
            color: var(--text);
            text-decoration: none;
            border: 1px solid var(--border);
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.01);
            transition: all 0.3s;
        }

        .nav-btn:hover, .nav-btn.active {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(212, 168, 83, 0.05);
        }

        .table-card {
            background: rgba(25, 35, 55, 0.25);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            overflow-x: auto;
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .orders-table th {
            color: var(--gold);
            font-weight: 600;
            padding: 16px;
            border-bottom: 1px solid var(--border);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .orders-table td {
            padding: 16px;
            border-bottom: 1px dashed var(--border);
            font-size: 0.95rem;
            color: var(--text);
            vertical-align: middle;
        }

        .orders-table tr:hover td {
            background: rgba(255, 255, 255, 0.01);
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .status-badge.placed {
            background: rgba(0, 240, 255, 0.1);
            color: var(--cyan);
            border: 1px solid rgba(0, 240, 255, 0.2);
        }

        .status-badge.delivered {
            background: rgba(34, 197, 94, 0.1);
            color: var(--success);
            border: 1px solid rgba(34, 197, 94, 0.2);
        }

        .status-badge.cancelled {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .status-badge.preparing {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warn);
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .status-select {
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
            padding: 6px 12px;
            border-radius: 6px;
            font-family: inherit;
            font-size: 0.85rem;
            outline: none;
            cursor: pointer;
            transition: border-color 0.3s;
        }

        .status-select:focus {
            border-color: var(--gold);
        }

        .btn-update {
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            color: #000;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-update:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(212, 168, 83, 0.3);
        }

        .empty-view {
            text-align: center;
            padding: 50px 0;
            color: var(--muted);
        }

        .empty-view span {
            font-size: 3rem;
            display: block;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="noise"></div>

    <!-- HEADER -->
    <header id="hdr">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div> BiteSpeed Admin
        </a>
        <nav>
            <a href="dashboard.jsp" class="nav-link">Dashboard</a>
            <a href="users.jsp" class="nav-link">Users</a>
            <a href="restaurants.jsp" class="nav-link">Restaurants</a>
            <a href="menus.jsp" class="nav-link">Menus</a>
            <a href="orders.jsp" class="nav-link active">Orders Log</a>
            <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">Storefront</a>
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
            <div class="auth-header-container">
                <span class="user-greeting" style="color:var(--gold); font-weight:500; margin-right:15px;">Admin: <%= loggedInUser.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none;">Logout</a>
            </div>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <div class="admin-container">
        <div style="display:flex; justify-content:space-between; align-items:center; background: rgba(255,255,255,0.03); border: 1px solid <%= isSuperAdmin ? "rgba(0, 240, 255, 0.3)" : "rgba(212, 168, 83, 0.3)" %>; padding: 12px 18px; border-radius: 10px; margin-bottom: 25px; flex-wrap:wrap; gap:10px;">
            <span style="font-weight:700; font-size:0.88rem; color:<%= isSuperAdmin ? "#00f0ff" : "#d4a853" %>;">
                <%= isSuperAdmin ? "👑 PLATFORM SUPER ADMIN MODE (Global Logistics Access)" : "🏢 RESTAURANT ADMIN MODE (Scoped to Resto #" + assignedRestaurantId + ")" %>
            </span>
            <a href="dashboard.jsp" style="color:#94a3b8; font-size:0.82rem; text-decoration:none; background:rgba(255,255,255,0.06); padding:4px 12px; border-radius:15px; border:1px solid rgba(255,255,255,0.15);">⚙️ Switch Scope</a>
        </div>

        <div class="header-panel">
            <h1>Order Dispatch Logistics</h1>
            <div style="display:flex; gap:12px; align-items:center;">
                <% if (isSuperAdmin) { 
                    List<com.tap.model.Restaurant> allR = new RestaurantDAOImpl().getAllRestaurants();
                %>
                    <select onchange="location.href='orders.jsp?restaurantId='+this.value" style="background:#1e293b; color:#fff; border:1px solid rgba(0,240,255,0.3); padding:8px 12px; border-radius:6px; font-family:'Outfit',sans-serif; font-size:0.85rem;">
                        <option value="0" <%= filterRestId == 0 ? "selected" : "" %>>🌐 All Restaurants Filter</option>
                        <% if (allR != null) { for (com.tap.model.Restaurant rItem : allR) { %>
                            <option value="<%= rItem.getRestaurantId() %>" <%= filterRestId == rItem.getRestaurantId() ? "selected" : "" %>>
                                #<%= rItem.getRestaurantId() %> <%= rItem.getRestaurantName() %>
                            </option>
                        <% } } %>
                    </select>
                <% } %>
                <a href="dashboard.jsp" class="nav-btn">← Back to Portal</a>
            </div>
        </div>

        <div class="table-card">
            <% if (orders != null && !orders.isEmpty()) { %>
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Restaurant</th>
                            <th>Total</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Audit Update</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order o : orders) {
                            String restName = "Restaurant #" + o.getRestaurantId();
                            try {
                                Restaurant r = restaurantDAO.getRestaurant(o.getRestaurantId());
                                if (r != null) restName = r.getRestaurantName();
                            } catch (Exception e) {}

                            String custName = "User #" + o.getUserId();
                            try {
                                User u = userDAO.getUser(o.getUserId());
                                if (u != null) custName = u.getFullName();
                            } catch (Exception e) {}
                        %>
                            <tr>
                                <td><strong>#BS<%= o.getOrderId() %></strong></td>
                                <td><%= custName %></td>
                                <td><%= restName %></td>
                                <td>₹<%= o.getTotalAmount() %></td>
                                <td>
                                    <span style="font-size:0.8rem; font-weight:600;"><%= o.getPaymentMode() != null ? o.getPaymentMode() : "COD" %></span>
                                    <br>
                                    <span style="font-size:0.75rem; color:var(--muted);"><%= o.getPaymentStatus() != null ? o.getPaymentStatus() : "Pending" %></span>
                                </td>
                                <td>
                                    <% String st = o.getOrderStatus() != null ? o.getOrderStatus() : "Placed"; %>
                                    <span class="status-badge <%= st.toLowerCase() %>"><%= st %></span>
                                </td>
                                <td>
                                    <form action="orders.jsp" method="POST" style="display:flex; gap:8px; align-items:center;">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <select name="status" class="status-select">
                                            <option value="PLACED" <%= "PLACED".equalsIgnoreCase(o.getOrderStatus()) ? "selected" : "" %>>Placed</option>
                                            <option value="PREPARING" <%= "PREPARING".equalsIgnoreCase(o.getOrderStatus()) ? "selected" : "" %>>Preparing</option>
                                            <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(o.getOrderStatus()) ? "selected" : "" %>>Delivered</option>
                                            <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(o.getOrderStatus()) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn-update">Update</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-view">
                    <span>🛸</span>
                    <p>No dispatch manifests registered in coordinates.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>