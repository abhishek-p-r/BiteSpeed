<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.daoimplementation.OrderDAOImpl" %>
<%@ page import="com.tap.daoimplementation.OrderItemDAOImpl" %>
<%@ page import="com.tap.daoimplementation.MenuDAOImpl" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login?error=please_login");
        return;
    }
    String orderIdStr = request.getParameter("orderId");
    Order order = null;
    List<OrderItem> items = null;
    RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
    MenuDAOImpl menuDAO = new MenuDAOImpl();
    
    if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            order = new OrderDAOImpl().getOrder(orderId);
            if (order != null && order.getUserId() == loggedInUser.getUserId()) {
                items = new OrderItemDAOImpl().getItemsByOrder(orderId);
            } else {
                order = null; // Prevent viewing other user's order
            }
        } catch (NumberFormatException e) {
            // Ignore
        }
    }

    if ("true".equals(request.getParameter("success"))) {
        java.util.Map<?, ?> orderCart = (java.util.Map<?, ?>) session.getAttribute("cart");
        if (orderCart != null) {
            orderCart.clear();
        }
        session.removeAttribute("cart");
        session.removeAttribute("cartCount");
        session.setAttribute("cartCount", 0);
    }
    java.util.Map<Integer, com.tap.model.CartItem> cart = (java.util.Map<Integer, com.tap.model.CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (cart != null) {
        for (com.tap.model.CartItem ci : cart.values()) {
            cartCount += ci.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Invoice #BS<%= order != null ? order.getOrderId() : "" %> — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/order.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .order-details-main { margin-top: 120px !important; max-width: 1100px; margin-left: auto; margin-right: auto; padding: 0 20px; }
        .details-grid {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: 25px;
            margin-top: 25px;
        }
        @media (max-width: 850px) {
            .details-grid { grid-template-columns: 1fr; }
        }
        .details-card-left, .details-card-right {
            background: rgba(25, 35, 55, 0.45);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(212, 168, 83, 0.18);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
        }
        .order-header-banner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            padding-bottom: 18px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .order-title-group h2 {
            font-family: var(--font-serif);
            font-size: 2rem;
            color: var(--gold);
            margin: 0;
        }
        .order-meta-sub {
            font-size: 0.84rem;
            color: var(--muted);
            margin-top: 4px;
        }
        /* Dish Receipt Items Table */
        .receipt-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .receipt-table th {
            text-align: left;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--gold);
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
        }
        .receipt-table td {
            padding: 14px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.08);
            font-size: 0.9rem;
            color: #fff;
        }
        .receipt-item-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .receipt-item-img {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            object-fit: cover;
        }
        .qty-badge {
            background: rgba(212, 168, 83, 0.15);
            color: var(--gold);
            border: 1px solid rgba(212, 168, 83, 0.3);
            border-radius: 12px;
            padding: 2px 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        /* Delivery Tracker Bar */
        .order-stepper-container {
            background: rgba(0, 240, 255, 0.03);
            border: 1px solid rgba(0, 240, 255, 0.15);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .stepper-header {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--muted);
            margin-bottom: 15px;
        }
        .stepper-progress {
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        .stepper-progress::before {
            content: '';
            position: absolute;
            top: 15px;
            left: 20px;
            right: 20px;
            height: 3px;
            background: rgba(255,255,255,0.1);
        }
        .stepper-node {
            position: relative;
            z-index: 2;
            text-align: center;
        }
        .stepper-dot {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #0e1626;
            border: 2px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            margin: 0 auto 6px auto;
        }
        .stepper-node.active .stepper-dot {
            border-color: #00f0ff;
            color: #00f0ff;
            box-shadow: 0 0 12px rgba(0, 240, 255, 0.5);
        }
        .stepper-node.done .stepper-dot {
            border-color: #2ecc71;
            color: #2ecc71;
            background: rgba(46, 204, 113, 0.15);
        }
        .stepper-txt { font-size: 0.75rem; color: var(--muted); }
        .stepper-node.active .stepper-txt { color: #fff; font-weight: 600; }
        .side-info-box {
            background: rgba(255,255,255,0.02);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 18px;
        }
        .side-info-box h4 {
            margin: 0 0 10px 0;
            color: var(--gold);
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .side-info-box p {
            margin: 5px 0;
            font-size: 0.88rem;
            color: var(--muted);
        }
    </style>
</head>
<body>
    <div class="noise"></div>

    <!-- HEADER -->
    <header id="hdr">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div> BiteSpeed
        </a>
        <nav>
            <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">Home</a>
            <a href="<%=request.getContextPath()%>/restaurants.jsp" class="nav-link">Restaurants</a>
            <a href="<%=request.getContextPath()%>/menu.jsp" class="nav-link">Menu</a>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link">Cart</a>
            <a href="<%=request.getContextPath()%>/orders.jsp" class="nav-link active">Orders</a>
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
                <a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                <% } %>
                <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
            </div>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                Cart <span class="cbadge" id="cbadge"><%= cartCount %></span>
            </a>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="order-details-main">
        <% if ("true".equalsIgnoreCase(request.getParameter("success"))) { %>
            <div style="background: linear-gradient(135deg, rgba(34, 197, 94, 0.2), rgba(0, 240, 255, 0.2)); border: 1px solid #22c55e; border-radius: 16px; padding: 18px 24px; margin-bottom: 25px; text-align: center;">
                <span style="font-size: 1.6rem; display: block; margin-bottom: 6px; color: #22c55e; font-weight: 700;">🎉 CONGRATULATIONS! ORDER PLACED & CONFIRMED 🎉</span>
                <span style="color: var(--muted); font-size: 0.92rem;">Your gourmet manifest <strong style="color:#00f0ff;">#BS<%= order != null ? order.getOrderId() : "" %></strong> has been registered & dispatched to the kitchen!</span>
            </div>
        <% } %>
        <% if (order != null) { 
            String restName = "Unknown Hub";
            try {
                restName = restaurantDAO.getRestaurant(order.getRestaurantId()).getRestaurantName();
            } catch (Exception e) {}
            String status = order.getOrderStatus() != null ? order.getOrderStatus().toUpperCase() : "PLACED";
        %>
            <div class="order-header-banner">
                <div class="order-title-group">
                    <a href="orders.jsp" style="color: var(--gold); text-decoration: none; font-size: 0.88rem; display: block; margin-bottom: 5px;">← Return to Dispatch History</a>
                    <h2>Order Manifest #BS<%= order.getOrderId() %></h2>
                    <div class="order-meta-sub">Placed on <%= order.getOrderDate() %> • Restaurant: <strong style="color:#fff;"><%= restName %></strong></div>
                </div>
                <div>
                    <span class="status-badge <%= status.toLowerCase() %>" style="font-size: 0.88rem; padding: 8px 16px;">
                        <%= status %>
                    </span>
                </div>
            </div>

            <!-- TRACKER STEPPER -->
            <div class="order-stepper-container">
                <div class="stepper-header">
                    <span><strong>Live Delivery Status</strong></span>
                    <span style="color: #00f0ff;">Estimated Arrival: ~30 Mins</span>
                </div>
                <div class="stepper-progress">
                    <div class="stepper-node done">
                        <div class="stepper-dot">✓</div>
                        <div class="stepper-txt">Order Placed</div>
                    </div>
                    <div class="stepper-node active">
                        <div class="stepper-dot">🍳</div>
                        <div class="stepper-txt">Preparing</div>
                    </div>
                    <div class="stepper-node">
                        <div class="stepper-dot">🛵</div>
                        <div class="stepper-txt">Out for Delivery</div>
                    </div>
                    <div class="stepper-node">
                        <div class="stepper-dot">📍</div>
                        <div class="stepper-txt">Delivered</div>
                    </div>
                </div>
            </div>

            <div class="details-grid">
                <!-- LEFT COLUMN: ITEMIZED RECEIPT -->
                <div class="details-card-left">
                    <h3 style="color: #fff; font-size: 1.2rem; margin-top: 0; margin-bottom: 15px; border-bottom: 1px solid var(--border); padding-bottom: 10px;">Itemized Dish Receipt</h3>
                    
                    <table class="receipt-table">
                        <thead>
                            <tr>
                                <th>Item Details</th>
                                <th>Qty</th>
                                <th>Unit Price</th>
                                <th style="text-align: right;">Line Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (items != null && !items.isEmpty()) {
                                    for (OrderItem item : items) {
                                        String itemName = "Gourmet Dish";
                                        String itemImg = "1.jpg";
                                        double unitPrice = item.getPrice() > 0 ? item.getPrice() : (item.getTotalPrice() / (item.getQuantity() > 0 ? item.getQuantity() : 1));
                                        try {
                                            Menu m = menuDAO.getMenu(item.getMenuId());
                                            if (m != null) {
                                                itemName = m.getItemName();
                                                if (m.getImage() != null && !m.getImage().trim().isEmpty()) {
                                                    itemImg = m.getImage().trim();
                                                }
                                            }
                                        } catch (Exception e) {}
                                        if (itemImg.startsWith("images/") || itemImg.startsWith("images\\")) {
                                            itemImg = itemImg.substring(7);
                                        }
                                        String itemImgUrl = (itemImg.startsWith("http://") || itemImg.startsWith("https://") || itemImg.startsWith("/"))
                                            ? itemImg
                                            : request.getContextPath() + "/images/" + itemImg;
                            %>
                                <tr>
                                    <td>
                                        <div class="receipt-item-cell">
                                            <img src="<%= itemImgUrl %>" alt="<%= itemName %>" class="receipt-item-img" onerror="this.src='<%=request.getContextPath()%>/images/1.jpg';">
                                            <span><%= itemName %></span>
                                        </div>
                                    </td>
                                    <td><span class="qty-badge">x<%= item.getQuantity() %></span></td>
                                    <td>₹<%= unitPrice %></td>
                                    <td style="text-align: right; font-weight: 600; color: var(--gold);">₹<%= item.getTotalPrice() %></td>
                                </tr>
                            <% 
                                    }
                                }
                            %>
                        </tbody>
                    </table>

                    <div style="margin-top: 25px; border-top: 1px solid var(--border); padding-top: 15px;">
                        <div class="detail-row">
                            <span class="label">Items Subtotal</span>
                            <span class="value">₹<%= order.getTotalAmount() %></span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Delivery Fee</span>
                            <span class="value" style="color: #2ecc71;">FREE</span>
                        </div>
                        <div class="detail-row total-row" style="margin-top: 10px; font-size: 1.2rem;">
                            <span class="label">Grand Total</span>
                            <span class="value" style="color: var(--gold);">₹<%= order.getTotalAmount() %></span>
                        </div>
                    </div>
                </div>

                <!-- RIGHT COLUMN: DELIVERY & PAYMENT DETAILS -->
                <div class="details-card-right">
                    <div class="side-info-box">
                        <h4>📍 Delivery Address</h4>
                        <p style="color: #fff; font-weight: 500;"><%= loggedInUser.getFullName() %></p>
                        <%
                            String realAddress = (String) session.getAttribute("orderAddress_" + (order != null ? order.getOrderId() : 0));
                            if (realAddress == null || realAddress.trim().isEmpty()) {
                                realAddress = (String) session.getAttribute("checkoutAddress");
                            }
                            if (realAddress == null || realAddress.trim().isEmpty()) {
                                try {
                                    List<com.tap.model.UserAddress> addList = new com.tap.daoimplementation.UserAddressDAOImpl().getAddressesByUser(loggedInUser.getUserId());
                                    if (addList != null && !addList.isEmpty()) {
                                        com.tap.model.UserAddress ua = addList.get(0);
                                        realAddress = ua.getAddressLine() + (ua.getCity() != null ? ", " + ua.getCity() : "") + (ua.getState() != null ? ", " + ua.getState() : "");
                                    }
                                } catch (Exception e) {}
                            }
                            if (realAddress == null || realAddress.trim().isEmpty()) {
                                realAddress = "Indiranagar 100ft Road, Bengaluru, 560038";
                            }

                            String realPhone = loggedInUser.getPhone();
                            if (session.getAttribute("checkoutPhone") != null && !((String)session.getAttribute("checkoutPhone")).trim().isEmpty()) {
                                realPhone = (String) session.getAttribute("checkoutPhone");
                            }
                            if (realPhone == null || realPhone.trim().isEmpty()) {
                                realPhone = "+91 98765 43210";
                            }
                        %>
                        <p style="color: #e2e8f0; line-height: 1.5; font-size: 0.92rem;"><%= realAddress %></p>
                        <p>Phone: <strong style="color:#fff;"><%= realPhone %></strong></p>
                    </div>

                    <div class="side-info-box">
                        <h4>💳 Payment Information</h4>
                        <p>Payment Mode: <strong style="color:#fff;"><%= order.getPaymentMode() != null ? order.getPaymentMode() : "COD" %></strong></p>
                        <p>Payment Status: <span class="status-badge completed" style="font-size:0.7rem; padding: 2px 8px;"><%= order.getPaymentStatus() != null ? order.getPaymentStatus() : "PAID" %></span></p>
                    </div>

                    <div class="side-info-box">
                        <h4>🚁 Courier Drone</h4>
                        <p>Dispatch Unit: <strong>BiteSpeed Drone Alpha-4</strong></p>
                        <p>Speed Vector: <strong>35 km/h</strong></p>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 20px;">
                        <a href="menu.jsp?restaurantId=<%= order.getRestaurantId() %>" class="btn-primary" style="text-align: center; text-decoration: none;">Reorder From Restaurant</a>
                        <button type="button" class="btn-ghost" onclick="window.print()" style="cursor: pointer; padding: 10px; border-radius: 8px;">🖨️ Print Order Receipt</button>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="empty-orders-view" style="text-align: center; padding: 60px 20px;">
                <p style="color:#ff6b6b; font-size: 1.1rem;">❌ Error: Order details not found or access denied.</p>
                <a href="orders.jsp" class="btn-primary">Return to History</a>
            </div>
        <% } %>
    </main>
</body>
</html>
