<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tap.model.User" %>
        <%@ page import="com.tap.model.Payment" %>
            <%@ page import="com.tap.daoimplementation.PaymentDAOImpl" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.util.ArrayList" %>
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

    String modeFilter = request.getParameter("mode");
    List<Payment> rawList = new PaymentDAOImpl().getAllPayments();
    if (rawList == null) rawList = new ArrayList<>();

    // Real-Time Ledger Sync: Merge live order transactions into payment ledger
    try (java.sql.Connection con = com.tap.utility.DBConnection.getConnection()) {
        if (con != null) {
            String sqlOrders = "SELECT order_id, total_amount, payment_mode, payment_status, order_date FROM orders ORDER BY order_id DESC";
            try (java.sql.Statement st = con.createStatement();
                 java.sql.ResultSet rs = st.executeQuery(sqlOrders)) {
                java.util.Set<Integer> existingOrderIds = new java.util.HashSet<>();
                for (Payment p : rawList) {
                    existingOrderIds.add(p.getOrderId());
                }
                while (rs.next()) {
                    int oid = rs.getInt("order_id");
                    if (!existingOrderIds.contains(oid)) {
                        Payment p = new Payment();
                        p.setPaymentId(1000 + oid);
                        p.setOrderId(oid);
                        p.setAmount(rs.getDouble("total_amount"));
                        p.setPaymentMethod(rs.getString("payment_mode") != null ? rs.getString("payment_mode") : "COD");
                        p.setPaymentStatus(rs.getString("payment_status") != null ? rs.getString("payment_status") : "SUCCESS");
                        p.setPaymentDate(rs.getTimestamp("order_date"));
                        rawList.add(p);
                    }
                }
            } catch (Exception ignored) {}
        }
    } catch (Exception ignored) {}

    List<Payment> paymentList = new ArrayList<>();
    if (rawList != null) {
        for (Payment p : rawList) {
            String m = p.getPaymentMethod() != null ? p.getPaymentMethod() : "COD";
            if (modeFilter == null || modeFilter.trim().isEmpty() || "ALL".equalsIgnoreCase(modeFilter)) {
                paymentList.add(p);
            } else if ("COD".equalsIgnoreCase(modeFilter) && "COD".equalsIgnoreCase(m)) {
                paymentList.add(p);
            } else if ("ONLINE".equalsIgnoreCase(modeFilter) && !"COD".equalsIgnoreCase(m)) {
                paymentList.add(p);
            }
        }
    }
%>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <script src="<%=request.getContextPath()%>/js/theme.js"></script>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Financial Payments Registry — BiteSpeed Admin</title>
                                        <link
                                            href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                                            rel="stylesheet">
                                        <link rel="stylesheet" href="../css/style.css">
                                        <style>
                                            body {
                                                background-color: #0b0f17;
                                                color: #ecf0f1;
                                                font-family: 'Outfit', sans-serif;
                                                padding: 40px;
                                            }

                                            .admin-card {
                                                background: rgba(16, 24, 40, 0.75);
                                                border: 1px solid rgba(0, 240, 255, 0.2);
                                                padding: 30px;
                                                border-radius: 12px;
                                                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
                                            }

                                            .header-bar {
                                                display: flex;
                                                justify-content: space-between;
                                                align-items: center;
                                            }

                                            h1 {
                                                color: #00f0ff;
                                                text-shadow: 0 0 10px rgba(0, 240, 255, 0.3);
                                                margin: 0;
                                            }

                                            .filter-tabs {
                                                display: flex;
                                                gap: 10px;
                                                margin-top: 20px;
                                                margin-bottom: 20px;
                                            }

                                            .tab-btn {
                                                background: rgba(255, 255, 255, 0.05);
                                                border: 1px solid rgba(255, 255, 255, 0.1);
                                                color: #94a3b8;
                                                padding: 8px 16px;
                                                border-radius: 20px;
                                                text-decoration: none;
                                                font-size: 13px;
                                                font-weight: 500;
                                                transition: all 0.3s;
                                            }

                                            .tab-btn:hover,
                                            .tab-btn.active {
                                                background: rgba(0, 240, 255, 0.15);
                                                border-color: #00f0ff;
                                                color: #00f0ff;
                                            }

                                            .admin-table {
                                                width: 100%;
                                                border-collapse: collapse;
                                                text-align: left;
                                            }

                                            .admin-table th,
                                            .admin-table td {
                                                padding: 12px;
                                                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                                            }

                                            .admin-table th {
                                                color: #00f0ff;
                                                font-weight: 600;
                                            }

                                            .badge {
                                                padding: 4px 10px;
                                                border-radius: 4px;
                                                font-size: 12px;
                                                font-weight: 600;
                                            }

                                            .badge.success,
                                            .badge.completed {
                                                background: rgba(34, 197, 94, 0.15);
                                                color: #22c55e;
                                            }

                                            .badge.pending {
                                                background: rgba(255, 159, 67, 0.15);
                                                color: #ff9f43;
                                            }

                                            .btn-back {
                                                display: inline-block;
                                                margin-bottom: 20px;
                                                color: #94a3b8;
                                                text-decoration: none;
                                                font-size: 14px;
                                            }

                                            .pay-method-cod {
                                                color: #d4a853;
                                            }

                                            .pay-method-online {
                                                color: #00f0ff;
                                            }
                                        </style>
                                    </head>

                                    <body>
                                         <div class="admin-card">
                                             <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; flex-wrap:wrap; gap:10px;">
                                                 <a href="dashboard.jsp" class="btn-back" style="margin:0;">← Back to Dashboard</a>
                                                 <a href="../index.jsp" class="btn-back" style="margin:0; color:var(--gold,#d4a853);">🏠 Return to Main Website</a>
                                             </div>
                                            <div class="header-bar">
                                                <h1>Financial Payments Registry</h1>
                                                <a href="reports.jsp" class="tab-btn active"
                                                    style="text-decoration:none;">📊 View Analytics Graphs →</a>
                                            </div>
                                            <p>Live transaction ledger recorded across MySQL payments table</p>

                                            <!-- TRANSACTION FILTER TABS -->
                                            <div class="filter-tabs">
                                                <a href="payments.jsp?mode=ALL" class="tab-btn <%= (modeFilter == null || "ALL".equalsIgnoreCase(modeFilter)) ? "active" : "" %>">All Transactions</a>
                                                <a href="payments.jsp?mode=COD" class="tab-btn <%= "COD".equalsIgnoreCase(modeFilter) ? "active" : "" %>">💵 Cash On Delivery (COD)</a>
                                                <a href="payments.jsp?mode=ONLINE" class="tab-btn <%= "ONLINE".equalsIgnoreCase(modeFilter) ? "active" : "" %>">💳 UPI / Card Online</a>
                                            </div>

                                            <table class="admin-table">
                                                <thead>
                                                    <tr>
                                                        <th>Payment ID</th>
                                                        <th>Order ID</th>
                                                        <th>Method</th>
                                                        <th>Amount</th>
                                                        <th>Status</th>
                                                        <th>Payment Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% if (paymentList !=null && !paymentList.isEmpty()) { for (Payment
                                                        p : paymentList) { String st=p.getPaymentStatus() !=null ?
                                                        p.getPaymentStatus().toLowerCase() : "pending" ; String
                                                        m=p.getPaymentMethod() !=null ? p.getPaymentMethod() : "COD" ;
                                                        %>
                                                        <tr>
                                                            <td>#PAY-<%= p.getPaymentId() %>
                                                            </td>
                                                            <td>#BS<%= p.getOrderId() %>
                                                            </td>
                                                            <td>
                                                                <strong class="<%= " COD".equalsIgnoreCase(m)
                                                                    ? "pay-method-cod" : "pay-method-online" %>"><%= m
                                                                        %></strong>
                                                            </td>
                                                            <td style="color:#00f0ff; font-weight:600;">₹<%=
                                                                    p.getAmount() %>
                                                            </td>
                                                            <td><span class="badge <%= st %>">
                                                                    <%= p.getPaymentStatus() !=null ?
                                                                        p.getPaymentStatus().toUpperCase() : "PENDING"
                                                                        %>
                                                                </span></td>
                                                            <td>
                                                                <%= p.getPaymentDate() !=null ? p.getPaymentDate()
                                                                    : "Recent" %>
                                                            </td>
                                                        </tr>
                                                        <% } } else { %>
                                                            <tr>
                                                                <td colspan="6"
                                                                    style="text-align:center; padding:30px; color:#94a3b8;">
                                                                    No matching transaction records found in database.
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </body>

                                    </html>