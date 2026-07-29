<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tap.model.User" %>
        <%@ page import="com.tap.model.Restaurant" %>
            <%@ page import="com.tap.model.Order" %>
                <%@ page import="com.tap.model.DailyReport" %>
                    <%@ page import="com.tap.model.RestaurantProfitReport" %>
                        <%@ page import="com.tap.model.PaymentMethodReport" %>
                            <%@ page import="com.tap.daoimplementation.OrderDAOImpl" %>
                                <%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
                                    <%@ page import="java.util.List" %>
                                        <%@ page import="java.util.ArrayList" %>
                                            <%@ page import="java.util.Map" %>
                                                <%@ page import="java.util.LinkedHashMap" %>
                                                    <%@ page import="java.text.SimpleDateFormat" %>
                                                        <% User loggedInUser=(User) session.getAttribute("user"); if
                                                            (loggedInUser==null) {
                                                            response.sendRedirect(request.getContextPath()
                                                            + "/login.jsp?error=please_login" ); return; }
                                                            String uRole = loggedInUser.getRole();
                                                            String adminRole = (String) session.getAttribute("adminRole");
                                                            if (!"ADMIN".equalsIgnoreCase(uRole) && !"SUPER_ADMIN".equalsIgnoreCase(uRole) && !"RESTAURANT_ADMIN".equalsIgnoreCase(uRole) && !"VENDOR".equalsIgnoreCase(uRole) && !"OWNER".equalsIgnoreCase(uRole) && !"SUPER_ADMIN".equalsIgnoreCase(adminRole) && !"RESTAURANT_ADMIN".equalsIgnoreCase(adminRole)) {
                                                                response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
                                                                return;
                                                            }
                                                            Integer assignedRestaurantId=(Integer)
                                                            session.getAttribute("assignedRestaurantId");
                                                            RestaurantDAOImpl rDAO=new RestaurantDAOImpl(); if
                                                            (assignedRestaurantId==null || assignedRestaurantId==0) {
                                                            Restaurant
                                                            r=rDAO.getRestaurantByOwnerId(loggedInUser.getUserId()); if
                                                            (r !=null) { assignedRestaurantId=r.getRestaurantId();
                                                            session.setAttribute("assignedRestaurantId",
                                                            assignedRestaurantId); } } boolean
                                                            isSuperAdmin="SUPER_ADMIN" .equalsIgnoreCase(adminRole) ||
                                                            ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) &&
                                                            (assignedRestaurantId==null || assignedRestaurantId==0));

                                                            String selectedRestParam = request.getParameter("restId");
                                                            Integer targetRestaurantId = (assignedRestaurantId != null && assignedRestaurantId > 0) ? assignedRestaurantId : 0;
                                                            if (isSuperAdmin && selectedRestParam != null && !selectedRestParam.trim().isEmpty()) {
                                                                try {
                                                                    targetRestaurantId = Integer.parseInt(selectedRestParam);
                                                                } catch (NumberFormatException e) {
                                                                    targetRestaurantId = 0;
                                                                }
                                                            }
                                                            List<Restaurant> allSystemRestaurants = rDAO.getAllRestaurants();

                                                            OrderDAOImpl orderDAO=new OrderDAOImpl(); Restaurant
                                                            assignedRestObj=(targetRestaurantId !=null &&
                                                            targetRestaurantId> 0) ?
                                                            rDAO.getRestaurant(targetRestaurantId) : null;
                                                            String assignedRestName = (assignedRestObj != null) ?
                                                            assignedRestObj.getRestaurantName() : (targetRestaurantId != null && targetRestaurantId > 0 ? ("Restaurant #" + targetRestaurantId) : "All System Restaurants");

                                                            double totalRevenue = 0.0;
                                                            int totalOrdersCount = 0;
                                                            double avgTicket = 0.0;
                                                            double codTotal = 0.0;
                                                            double upiTotal = 0.0;
                                                            int codCount = 0;
                                                            int upiCount = 0;

                                                            List<RestaurantProfitReport> profitReports = new ArrayList<>
                                                                    ();
                                                                    List<PaymentMethodReport> paymentReports = new
                                                                        ArrayList<>();

                                                                            StringBuilder datesJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder revenueJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder ordersJson = new
                                                                            StringBuilder("[");

                                                                            StringBuilder restNamesJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder restRevenuesJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder restProfitsJson = new
                                                                            StringBuilder("[");

                                                                            StringBuilder payModesJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder payAmountsJson = new
                                                                            StringBuilder("[");
                                                                            StringBuilder payCountsJson = new
                                                                            StringBuilder("[");

                                                                            boolean isGlobalMode = isSuperAdmin && (targetRestaurantId == null || targetRestaurantId == 0);
                                                                            if (isGlobalMode) {
                                                                            /* GLOBAL SUPER ADMIN ANALYTICS */
                                                                            List<DailyReport> reportList =
                                                                                orderDAO.getDailyAnalysisReports();
                                                                                List<RestaurantProfitReport>
                                                                                    rawProfitReports =
                                                                                    orderDAO.getRestaurantProfitReports();
                                                                                    List<PaymentMethodReport>
                                                                                        rawPayReports =
                                                                                        orderDAO.getPaymentMethodReports();

                                                                                        if (rawProfitReports != null) {
                                                                                        profitReports.addAll(rawProfitReports);
                                                                                        }

                                                                                        boolean firstDate = true;
                                                                                        if (reportList != null &&
                                                                                        !reportList.isEmpty()) {
                                                                                        for (int i = reportList.size() -
                                                                                        1; i >= 0; i--) {
                                                                                        DailyReport r =
                                                                                        reportList.get(i);
                                                                                        if (r != null) {
                                                                                        totalRevenue +=
                                                                                        r.getTotalRevenue();
                                                                                        totalOrdersCount +=
                                                                                        r.getTotalOrders();
                                                                                        String dt = (r.getDate() !=
                                                                                        null) ? r.getDate() : "Recent";
                                                                                        if (!firstDate) {
                                                                                        datesJson.append(",");
                                                                                        revenueJson.append(",");
                                                                                        ordersJson.append(",");
                                                                                        }
                                                                                        datesJson.append("\"").append(dt).append("\"");
                                                                                        revenueJson.append(r.getTotalRevenue());
                                                                                        ordersJson.append(r.getTotalOrders());
                                                                                        firstDate = false;
                                                                                        }
                                                                                        }
                                                                                        avgTicket = (totalOrdersCount >
                                                                                        0) ? (totalRevenue /
                                                                                        totalOrdersCount) : 0.0;
                                                                                        }

                                                                                        if (rawPayReports != null) {
                                                                                        for (PaymentMethodReport pm :
                                                                                        rawPayReports) {
                                                                                        if
                                                                                        ("COD".equalsIgnoreCase(pm.getPaymentMode()))
                                                                                        {
                                                                                        codTotal += pm.getTotalAmount();
                                                                                        } else {
                                                                                        upiTotal += pm.getTotalAmount();
                                                                                        }
                                                                                        paymentReports.add(pm);
                                                                                        }
                                                                                        }
                                                                                        } else {
                                                                                        /* RESTAURANT SPECIFIC ANALYTICS */
                                                                                        List<Order> ownerOrders =
                                                                                            (targetRestaurantId !=
                                                                                            null && targetRestaurantId
                                                                                            > 0) ?
                                                                                            orderDAO.getOrdersByRestaurantId(targetRestaurantId)
                                                                                            : new ArrayList<>();
                                                                                                Map<String, double[]>
                                                                                                    dailyMap = new
                                                                                                    LinkedHashMap<>();
                                                                                                        SimpleDateFormat
                                                                                                        sdf = new
                                                                                                        SimpleDateFormat("yyyy-MM-dd");

                                                                                                        if (ownerOrders
                                                                                                        != null &&
                                                                                                        !ownerOrders.isEmpty())
                                                                                                        {
                                                                                                        totalOrdersCount
                                                                                                        =
                                                                                                        ownerOrders.size();
                                                                                                        for (Order o :
                                                                                                        ownerOrders) {
                                                                                                        totalRevenue +=
                                                                                                        o.getTotalAmount();
                                                                                                        String pMode =
                                                                                                        (o.getPaymentMode()
                                                                                                        != null) ?
                                                                                                        o.getPaymentMode()
                                                                                                        : "COD";
                                                                                                        if
                                                                                                        ("COD".equalsIgnoreCase(pMode))
                                                                                                        {
                                                                                                        codTotal +=
                                                                                                        o.getTotalAmount();
                                                                                                        codCount++;
                                                                                                        } else {
                                                                                                        upiTotal +=
                                                                                                        o.getTotalAmount();
                                                                                                        upiCount++;
                                                                                                        }

                                                                                                        String dateStr =
                                                                                                        (o.getOrderDate()
                                                                                                        != null) ?
                                                                                                        sdf.format(o.getOrderDate())
                                                                                                        : "Recent";
                                                                                                        dailyMap.putIfAbsent(dateStr,
                                                                                                        new
                                                                                                        double[]{0.0,
                                                                                                        0.0});
                                                                                                        dailyMap.get(dateStr)[0]
                                                                                                        += 1;
                                                                                                        dailyMap.get(dateStr)[1]
                                                                                                        +=
                                                                                                        o.getTotalAmount();
                                                                                                        }
                                                                                                        avgTicket =
                                                                                                        (totalOrdersCount
                                                                                                        > 0) ?
                                                                                                        (totalRevenue /
                                                                                                        totalOrdersCount)
                                                                                                        : 0.0;

                                                                                                        boolean
                                                                                                        firstDate =
                                                                                                        true;
                                                                                                        for (Map.Entry
                                                                                                        <String,
                                                                                                            double[]>
                                                                                                            entry :
                                                                                                            dailyMap.entrySet())
                                                                                                            {
                                                                                                            if
                                                                                                            (!firstDate)
                                                                                                            {
                                                                                                            datesJson.append(",");
                                                                                                            revenueJson.append(",");
                                                                                                            ordersJson.append(",");
                                                                                                            }
                                                                                                            datesJson.append("\"").append(entry.getKey()).append("\"");
                                                                                                            ordersJson.append((int)
                                                                                                            entry.getValue()[0]);
                                                                                                            revenueJson.append(entry.getValue()[1]);
                                                                                                            firstDate =
                                                                                                            false;
                                                                                                            }
                                                                                                            }

                                                                                                            /* Build
                                                                                                            single venue
                                                                                                            profit
                                                                                                            report */
                                                                                                            RestaurantProfitReport
                                                                                                            singleReport
                                                                                                            = new
                                                                                                            RestaurantProfitReport();
                                                                                                            singleReport.setRestaurantId((assignedRestaurantId
                                                                                                            != null) ?
                                                                                                            assignedRestaurantId
                                                                                                            : 0);
                                                                                                            singleReport.setRestaurantName(assignedRestName);
                                                                                                            singleReport.setTotalOrders(totalOrdersCount);
                                                                                                            singleReport.setTotalRevenue(totalRevenue);
                                                                                                            singleReport.setEstimatedProfit(totalRevenue
                                                                                                            * 0.25);
                                                                                                            profitReports.add(singleReport);

                                                                                                            /* Build
                                                                                                            payment
                                                                                                            reports for
                                                                                                            venue */
                                                                                                            double
                                                                                                            grandTotal =
                                                                                                            codTotal +
                                                                                                            upiTotal;
                                                                                                            if (codCount
                                                                                                            > 0 ||
                                                                                                            totalOrdersCount
                                                                                                            == 0) {
                                                                                                            PaymentMethodReport
                                                                                                            codRep = new
                                                                                                            PaymentMethodReport();
                                                                                                            codRep.setPaymentMode("COD");
                                                                                                            codRep.setTransactionCount(codCount);
                                                                                                            codRep.setTotalAmount(codTotal);
                                                                                                            codRep.setPercentage((grandTotal
                                                                                                            > 0) ?
                                                                                                            ((codTotal /
                                                                                                            grandTotal)
                                                                                                            * 100.0) :
                                                                                                            0.0);
                                                                                                            paymentReports.add(codRep);
                                                                                                            }
                                                                                                            if (upiCount
                                                                                                            > 0) {
                                                                                                            PaymentMethodReport
                                                                                                            upiRep = new
                                                                                                            PaymentMethodReport();
                                                                                                            upiRep.setPaymentMode("ONLINE / UPI");
                                                                                                            upiRep.setTransactionCount(upiCount);
                                                                                                            upiRep.setTotalAmount(upiTotal);
                                                                                                            upiRep.setPercentage((grandTotal
                                                                                                            > 0) ?
                                                                                                            ((upiTotal /
                                                                                                            grandTotal)
                                                                                                            * 100.0) :
                                                                                                            0.0);
                                                                                                            paymentReports.add(upiRep);
                                                                                                            }
                                                                                                            }

                                                                                                            datesJson.append("]");
                                                                                                            revenueJson.append("]");
                                                                                                            ordersJson.append("]");

                                                                                                            /* Build
                                                                                                            Profitability
                                                                                                            Chart JSON
                                                                                                            */
                                                                                                            boolean
                                                                                                            firstRest =
                                                                                                            true;
                                                                                                            for
                                                                                                            (RestaurantProfitReport
                                                                                                            pr :
                                                                                                            profitReports)
                                                                                                            {
                                                                                                            if (pr !=
                                                                                                            null) {
                                                                                                            String rName
                                                                                                            =
                                                                                                            (pr.getRestaurantName()
                                                                                                            != null) ?
                                                                                                            pr.getRestaurantName().replace("\"",
                                                                                                            "\\\"").replace("\\",
                                                                                                            "") : ("Hub #" + pr.getRestaurantId());
                                                                                                            if
                                                                                                            (!firstRest)
                                                                                                            {
                                                                                                            restNamesJson.append(",");
                                                                                                            restRevenuesJson.append(",");
                                                                                                            restProfitsJson.append(",");
                                                                                                            }
                                                                                                            restNamesJson.append("\"").append(rName).append("\"");
                                                                                                            restRevenuesJson.append(pr.getTotalRevenue());
                                                                                                            restProfitsJson.append(pr.getEstimatedProfit());
                                                                                                            firstRest =
                                                                                                            false;
                                                                                                            }
                                                                                                            }
                                                                                                            restNamesJson.append("]");
                                                                                                            restRevenuesJson.append("]");
                                                                                                            restProfitsJson.append("]");

                                                                                                            /* Build
                                                                                                            Payment
                                                                                                            Chart JSON
                                                                                                            */
                                                                                                            boolean
                                                                                                            firstPay =
                                                                                                            true;
                                                                                                            for
                                                                                                            (PaymentMethodReport
                                                                                                            pm :
                                                                                                            paymentReports)
                                                                                                            {
                                                                                                            if (pm !=
                                                                                                            null) {
                                                                                                            String
                                                                                                            pmName =
                                                                                                            (pm.getPaymentMode()
                                                                                                            != null) ?
                                                                                                            pm.getPaymentMode()
                                                                                                            : "COD";
                                                                                                            if
                                                                                                            (!firstPay)
                                                                                                            {
                                                                                                            payModesJson.append(",");
                                                                                                            payAmountsJson.append(",");
                                                                                                            payCountsJson.append(",");
                                                                                                            }
                                                                                                            payModesJson.append("\"").append(pmName).append("\"");
                                                                                                            payAmountsJson.append(pm.getTotalAmount());
                                                                                                            payCountsJson.append(pm.getTransactionCount());
                                                                                                            firstPay =
                                                                                                            false;
                                                                                                            }
                                                                                                            }
                                                                                                            payModesJson.append("]");
                                                                                                            payAmountsJson.append("]");
                                                                                                            payCountsJson.append("]");

                                                                                                            RestaurantProfitReport
                                                                                                            topRest =
                                                                                                            !profitReports.isEmpty()
                                                                                                            ?
                                                                                                            profitReports.get(0)
                                                                                                            : null;
    String reportsPageTitle = isGlobalMode ? "Business Analytics & Profit Intelligence" : ("Financial Analytics — " + assignedRestName);
    String reportsHeading = isGlobalMode ? "Business Intelligence & Executive Analytics" : ("Financial & Dish Analytics — " + assignedRestName);
    String revenueMetricLabel = isGlobalMode ? "System Gross Revenue" : (assignedRestName + " Revenue");
    String spotlightMetricLabel = isGlobalMode ? "🏆 Top Profitable Restaurant" : ("⭐ " + assignedRestName + " Performance");
    String profitChartTitle = isGlobalMode ? "Restaurant Yield & Profitability Comparison" : (assignedRestName + " Revenue Yield");
    String profitChartSubtitle = isGlobalMode ? "Top Performing Hubs" : (assignedRestName + " Sales Curve");
    String leaderboardTitle = isGlobalMode ? "Restaurant Profit Leaderboard" : (assignedRestName + " Breakdown");

    // Enhanced Top Selling Food Items & Category Demand Analysis
    java.util.List<java.util.Map<String, Object>> topSellingItems = new java.util.ArrayList<>();
    java.util.List<java.util.Map<String, Object>> topCategories = new java.util.ArrayList<>();
    
    StringBuilder topDishNamesJson = new StringBuilder("[");
    StringBuilder topDishQtyJson = new StringBuilder("[");
    StringBuilder topDishSalesJson = new StringBuilder("[");
    StringBuilder topCatNamesJson = new StringBuilder("[");
    StringBuilder topCatQtyJson = new StringBuilder("[");

    int grandTotalItemsSold = 0;
    double grandTotalItemsSales = 0.0;

    try (java.sql.Connection con = com.tap.utility.DBConnection.getConnection()) {
        if (con != null) {
            String filterWhere = (targetRestaurantId != null && targetRestaurantId > 0) 
                                 ? " WHERE m.restaurant_id = " + targetRestaurantId + " " : " ";
            
            // 1. Top Selling Dishes Query for Specific Restaurant
            String sql1 = "SELECT m.menu_id, m.item_name, m.category, m.price, m.image_path, "
                       + "SUM(oi.quantity) as total_qty, SUM(oi.price * oi.quantity) as total_sales "
                       + "FROM order_items oi JOIN menu m ON oi.menu_id = m.menu_id "
                       + filterWhere
                       + "GROUP BY m.menu_id, m.item_name, m.category, m.price, m.image_path "
                       + "ORDER BY total_qty DESC LIMIT 10";
            
            try (java.sql.Statement st = con.createStatement();
                 java.sql.ResultSet rs = st.executeQuery(sql1)) {
                boolean firstD = true;
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    int q = rs.getInt("total_qty");
                    double s = rs.getDouble("total_sales");
                    String nm = rs.getString("item_name");
                    String cat = rs.getString("category") != null ? rs.getString("category") : "Main Course";
                    String img = rs.getString("image_path") != null ? rs.getString("image_path") : "../images/food1.jpg";
                    
                    map.put("id", rs.getInt("menu_id"));
                    map.put("name", nm);
                    map.put("category", cat);
                    map.put("price", rs.getDouble("price"));
                    map.put("img", img);
                    map.put("qty", q);
                    map.put("sales", s);
                    topSellingItems.add(map);

                    grandTotalItemsSold += q;
                    grandTotalItemsSales += s;

                    if (!firstD) {
                        topDishNamesJson.append(",");
                        topDishQtyJson.append(",");
                        topDishSalesJson.append(",");
                    }
                    topDishNamesJson.append("\"").append(nm.replace("\"", "\\\"")).append("\"");
                    topDishQtyJson.append(q);
                    topDishSalesJson.append(s);
                    firstD = false;
                }
            } catch (Exception ex) {
                // Fallback for menu_items / order_item schema
                String sqlFallback = "SELECT m.menu_id, m.item_name, m.category, m.price, m.image_path, "
                                   + "SUM(oi.quantity) as total_qty, SUM(oi.price * oi.quantity) as total_sales "
                                   + "FROM order_item oi JOIN menu_items m ON oi.menu_id = m.menu_id "
                                   + filterWhere
                                   + "GROUP BY m.menu_id, m.item_name, m.category, m.price, m.image_path "
                                   + "ORDER BY total_qty DESC LIMIT 10";
                try (java.sql.Statement stF = con.createStatement();
                     java.sql.ResultSet rsF = stF.executeQuery(sqlFallback)) {
                    boolean firstF = true;
                    while (rsF.next()) {
                        java.util.Map<String, Object> map = new java.util.HashMap<>();
                        int q = rsF.getInt("total_qty");
                        double s = rsF.getDouble("total_sales");
                        String nm = rsF.getString("item_name");
                        String cat = rsF.getString("category") != null ? rsF.getString("category") : "Main Course";
                        String img = rsF.getString("image_path") != null ? rsF.getString("image_path") : "../images/food1.jpg";
                        
                        map.put("id", rsF.getInt("menu_id"));
                        map.put("name", nm);
                        map.put("category", cat);
                        map.put("price", rsF.getDouble("price"));
                        map.put("img", img);
                        map.put("qty", q);
                        map.put("sales", s);
                        topSellingItems.add(map);

                        grandTotalItemsSold += q;
                        grandTotalItemsSales += s;

                        if (!firstF) {
                            topDishNamesJson.append(",");
                            topDishQtyJson.append(",");
                            topDishSalesJson.append(",");
                        }
                        topDishNamesJson.append("\"").append(nm.replace("\"", "\\\"")).append("\"");
                        topDishQtyJson.append(q);
                        topDishSalesJson.append(s);
                        firstF = false;
                    }
                } catch (Exception ignored) {}
            }

            // 2. Category Demand Query
            String catSql = "SELECT m.category, SUM(oi.quantity) as total_qty "
                         + "FROM order_items oi JOIN menu m ON oi.menu_id = m.menu_id "
                         + filterWhere
                         + "GROUP BY m.category ORDER BY total_qty DESC";
            try (java.sql.Statement stC = con.createStatement();
                 java.sql.ResultSet rsC = stC.executeQuery(catSql)) {
                boolean firstC = true;
                while (rsC.next()) {
                    java.util.Map<String, Object> cMap = new java.util.HashMap<>();
                    String cName = rsC.getString("category") != null ? rsC.getString("category") : "Main Course";
                    int cQty = rsC.getInt("total_qty");
                    cMap.put("category", cName);
                    cMap.put("qty", cQty);
                    topCategories.add(cMap);

                    if (!firstC) {
                        topCatNamesJson.append(",");
                        topCatQtyJson.append(",");
                    }
                    topCatNamesJson.append("\"").append(cName.replace("\"", "\\\"")).append("\"");
                    topCatQtyJson.append(cQty);
                    firstC = false;
                }
            } catch (Exception ignored) {}
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    topDishNamesJson.append("]");
    topDishQtyJson.append("]");
    topDishSalesJson.append("]");
    topCatNamesJson.append("]");
    topCatQtyJson.append("]");
%>
                                                                                                            <!DOCTYPE
                                                                                                                html>
                                                                                                            <html
                                                                                                                lang="en">

                                                                                                            <head>
                                                                                                                <script
                                                                                                                    src="<%=request.getContextPath()%>/js/theme.js"></script>
                                                                                                                <meta
                                                                                                                    charset="UTF-8">
                                                                                                                <meta
                                                                                                                    name="viewport"
                                                                                                                    content="width=device-width, initial-scale=1.0">
                                                                                                                <title>
                                                                                                                    <%= reportsPageTitle
                                                                                                                        %>
                                                                                                                        —
                                                                                                                        BiteSpeed
                                                                                                                        Admin
                                                                                                                </title>
                                                                                                                <link
                                                                                                                    href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                                                                                                                    rel="stylesheet">
                                                                                                                <link
                                                                                                                    rel="stylesheet"
                                                                                                                    href="../css/style.css">
                                                                                                                <script
                                                                                                                    src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                                                                                                                <style>
                                                                                                                    body {
                                                                                                                        background-color: #0b0f17;
                                                                                                                        color: #ecf0f1;
                                                                                                                        font-family: 'Outfit', sans-serif;
                                                                                                                        padding: 30px;
                                                                                                                        margin: 0;
                                                                                                                    }

                                                                                                                    .dashboard-container {
                                                                                                                        max-width: 1300px;
                                                                                                                        margin: 0 auto;
                                                                                                                    }

                                                                                                                    .header-actions {
                                                                                                                        display: flex;
                                                                                                                        justify-content: space-between;
                                                                                                                        align-items: center;
                                                                                                                        margin-bottom: 25px;
                                                                                                                    }

                                                                                                                    h1 {
                                                                                                                        font-family: var(--font-serif, 'Outfit');
                                                                                                                        font-size: 2rem;
                                                                                                                        color: var(--gold, #d4a853);
                                                                                                                        margin: 0;
                                                                                                                    }

                                                                                                                    .btn-action {
                                                                                                                        background: rgba(255, 255, 255, 0.05);
                                                                                                                        border: 1px solid rgba(255, 255, 255, 0.15);
                                                                                                                        color: #ecf0f1;
                                                                                                                        padding: 8px 18px;
                                                                                                                        border-radius: 20px;
                                                                                                                        text-decoration: none;
                                                                                                                        font-size: 0.85rem;
                                                                                                                        transition: all 0.3s ease;
                                                                                                                    }

                                                                                                                    .btn-action:hover {
                                                                                                                        border-color: #d4a853;
                                                                                                                        color: #d4a853;
                                                                                                                    }

                                                                                                                    .metrics-grid {
                                                                                                                        display: grid;
                                                                                                                        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                                                                                                                        gap: 18px;
                                                                                                                        margin-bottom: 30px;
                                                                                                                    }

                                                                                                                    .metric-card {
                                                                                                                        background: rgba(16, 24, 40, 0.75);
                                                                                                                        border: 1px solid rgba(255, 255, 255, 0.08);
                                                                                                                        border-radius: 14px;
                                                                                                                        padding: 22px;
                                                                                                                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
                                                                                                                        backdrop-filter: blur(12px);
                                                                                                                    }

                                                                                                                    .metric-card.revenue {
                                                                                                                        border-left: 4px solid #00f0ff;
                                                                                                                    }

                                                                                                                    .metric-card.spotlight {
                                                                                                                        border-left: 4px solid #2ecc71;
                                                                                                                    }

                                                                                                                    .metric-card.payment {
                                                                                                                        border-left: 4px solid #a855f7;
                                                                                                                    }

                                                                                                                    .metric-label {
                                                                                                                        font-size: 0.82rem;
                                                                                                                        color: #94a3b8;
                                                                                                                        text-transform: uppercase;
                                                                                                                        letter-spacing: 0.5px;
                                                                                                                        margin-bottom: 8px;
                                                                                                                    }

                                                                                                                    .metric-value {
                                                                                                                        font-size: 1.9rem;
                                                                                                                        font-weight: 700;
                                                                                                                        color: #fff;
                                                                                                                        margin-bottom: 6px;
                                                                                                                    }

                                                                                                                    .metric-sub {
                                                                                                                        font-size: 0.8rem;
                                                                                                                        color: #64748b;
                                                                                                                    }

                                                                                                                    .charts-grid-3 {
                                                                                                                        display: grid;
                                                                                                                        grid-template-columns: 2fr 1fr;
                                                                                                                        gap: 20px;
                                                                                                                        margin-bottom: 30px;
                                                                                                                    }

                                                                                                                    .chart-card {
                                                                                                                        background: rgba(16, 24, 40, 0.75);
                                                                                                                        border: 1px solid rgba(255, 255, 255, 0.08);
                                                                                                                        border-radius: 14px;
                                                                                                                        padding: 22px;
                                                                                                                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
                                                                                                                    }

                                                                                                                    .chart-title {
                                                                                                                        font-size: 1.05rem;
                                                                                                                        font-weight: 600;
                                                                                                                        margin-bottom: 16px;
                                                                                                                        display: flex;
                                                                                                                        justify-content: space-between;
                                                                                                                        align-items: center;
                                                                                                                    }

                                                                                                                    .table-grid-2 {
                                                                                                                        display: grid;
                                                                                                                        grid-template-columns: 1fr 1fr;
                                                                                                                        gap: 20px;
                                                                                                                    }

                                                                                                                    .data-card {
                                                                                                                        background: rgba(16, 24, 40, 0.75);
                                                                                                                        border: 1px solid rgba(255, 255, 255, 0.08);
                                                                                                                        border-radius: 14px;
                                                                                                                        padding: 22px;
                                                                                                                    }

                                                                                                                    .data-title {
                                                                                                                        font-size: 1.1rem;
                                                                                                                        color: #d4a853;
                                                                                                                        margin-top: 0;
                                                                                                                        margin-bottom: 16px;
                                                                                                                    }

                                                                                                                    .reports-table {
                                                                                                                        width: 100%;
                                                                                                                        border-collapse: collapse;
                                                                                                                    }

                                                                                                                    .reports-table th {
                                                                                                                        text-align: left;
                                                                                                                        padding: 10px 14px;
                                                                                                                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                                                                                                                        color: #94a3b8;
                                                                                                                        font-size: 0.8rem;
                                                                                                                        text-transform: uppercase;
                                                                                                                    }

                                                                                                                    .reports-table td {
                                                                                                                        padding: 14px;
                                                                                                                        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                                                                                                                        font-size: 0.92rem;
                                                                                                                    }

                                                                                                                    .highlight-top {
                                                                                                                        color: #2ecc71;
                                                                                                                        font-weight: 600;
                                                                                                                    }
                                                                                                                </style>
                                                                                                            </head>

                                                                                                            <body>
                                                                                                                <div
                                                                                                                    class="dashboard-container">
                                                                                                                    <div
                                                                                                                        class="header-actions">
                                                                                                                        <h1>
                                                                                                                            <%= reportsHeading
                                                                                                                                %>
                                                                                                                        </h1>
                                                                                                                        <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                                                                                                             <a href="dashboard.jsp" class="btn-action">← Dashboard</a>
                                                                                                                             <a href="menus.jsp" class="btn-action">🍔 Menus</a>
                                                                                                                             <a href="orders.jsp" class="btn-action">📦 Orders</a>
                                                                                                                             <a href="payments.jsp" class="btn-action">💳 Payments</a>
                                                                                                                             <a href="../index.jsp" class="btn-action" style="border-color:var(--gold,#d4a853); color:var(--gold,#d4a853);">🏠 Main Website</a>
                                                                                                                         </div>
                                                                                                                    </div>

                                                                                                                    <% if (isSuperAdmin) { %>
                                                                                                                        <div style="background: rgba(0, 240, 255, 0.06); border: 1px solid rgba(0, 240, 255, 0.2); border-radius: 12px; padding: 16px 22px; margin-top: 20px; margin-bottom: 25px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px;">
                                                                                                                            <div>
                                                                                                                                <span style="color: #00f0ff; font-weight: 600; font-size: 1rem;">👑 Super Admin Multi-Restaurant Analytics Control</span>
                                                                                                                                <p style="color: #94a3b8; font-size: 0.83rem; margin: 3px 0 0 0;">Switch analysis view between all system restaurants combined or select a specific venue to inspect dish order popularity.</p>
                                                                                                                            </div>
                                                                                                                            <form method="GET" action="reports.jsp" style="display: flex; align-items: center; gap: 10px; margin: 0;">
                                                                                                                                <label style="color: #ecf0f1; font-size: 0.88rem; font-weight: 500;">Filter Restaurant:</label>
                                                                                                                                <select name="restId" onchange="this.form.submit()" style="background: #0f172a; color: #00f0ff; border: 1px solid #00f0ff; border-radius: 8px; padding: 8px 14px; font-family: 'Outfit', sans-serif; font-size: 0.9rem; font-weight: 600; cursor: pointer; outline: none;">
                                                                                                                                    <option value="0" <%= (targetRestaurantId == null || targetRestaurantId == 0) ? "selected" : "" %>>🌐 All System Restaurants (Combined Overview)</option>
                                                                                                                                    <% if (allSystemRestaurants != null) {
                                                                                                                                        for (Restaurant rItem : allSystemRestaurants) { %>
                                                                                                                                            <option value="<%= rItem.getRestaurantId() %>" <%= (targetRestaurantId != null && targetRestaurantId == rItem.getRestaurantId()) ? "selected" : "" %>>
                                                                                                                                                🏠 <%= rItem.getRestaurantName() %> (ID #<%= rItem.getRestaurantId() %>)
                                                                                                                                            </option>
                                                                                                                                    <%  }
                                                                                                                                    } %>
                                                                                                                                </select>
                                                                                                                            </form>
                                                                                                                        </div>
                                                                                                                    <% } %>

                                                                                                                    <!-- SPOTLIGHT METRICS -->
                                                                                                                    <div
                                                                                                                        class="metrics-grid">
                                                                                                                        <div
                                                                                                                            class="metric-card revenue">
                                                                                                                            <div
                                                                                                                                class="metric-label">
                                                                                                                                <%= revenueMetricLabel
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div class="metric-value"
                                                                                                                                style="color:#00f0ff;">
                                                                                                                                ₹
                                                                                                                                <%= String.format("%,.2f",
                                                                                                                                    totalRevenue)
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="metric-sub">
                                                                                                                                Cumulative
                                                                                                                                checkout
                                                                                                                                yield
                                                                                                                                volume
                                                                                                                            </div>
                                                                                                                        </div>

                                                                                                                        <div
                                                                                                                            class="metric-card spotlight">
                                                                                                                            <div
                                                                                                                                class="metric-label">
                                                                                                                                <%= spotlightMetricLabel
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div class="metric-value"
                                                                                                                                style="color:#2ecc71; font-size:1.6rem;">
                                                                                                                                <%= topRest
                                                                                                                                    !=null
                                                                                                                                    ?
                                                                                                                                    topRest.getRestaurantName()
                                                                                                                                    :
                                                                                                                                    assignedRestName
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="metric-sub">
                                                                                                                                Yield:
                                                                                                                                <strong>₹
                                                                                                                                    <%= String.format("%,.2f",
                                                                                                                                        topRest
                                                                                                                                        !=null
                                                                                                                                        ?
                                                                                                                                        topRest.getTotalRevenue()
                                                                                                                                        :
                                                                                                                                        totalRevenue)
                                                                                                                                        %>
                                                                                                                                </strong>
                                                                                                                                •
                                                                                                                                Profit:
                                                                                                                                <strong
                                                                                                                                    style="color:#2ecc71;">₹
                                                                                                                                    <%= String.format("%,.2f",
                                                                                                                                        topRest
                                                                                                                                        !=null
                                                                                                                                        ?
                                                                                                                                        topRest.getEstimatedProfit()
                                                                                                                                        :
                                                                                                                                        (totalRevenue
                                                                                                                                        *
                                                                                                                                        0.25))
                                                                                                                                        %>
                                                                                                                                </strong>
                                                                                                                            </div>
                                                                                                                        </div>

                                                                                                                        <div
                                                                                                                            class="metric-card payment">
                                                                                                                            <div
                                                                                                                                class="metric-label">
                                                                                                                                Payment
                                                                                                                                Split
                                                                                                                                (COD
                                                                                                                                vs
                                                                                                                                Online)
                                                                                                                            </div>
                                                                                                                            <div class="metric-value"
                                                                                                                                style="color:#a855f7; font-size:1.5rem;">
                                                                                                                                COD:
                                                                                                                                ₹
                                                                                                                                <%= String.format("%,.0f",
                                                                                                                                    codTotal)
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="metric-sub">
                                                                                                                                Online/UPI:
                                                                                                                                <strong
                                                                                                                                    style="color:#ec4899;">₹
                                                                                                                                    <%= String.format("%,.0f",
                                                                                                                                        upiTotal)
                                                                                                                                        %>
                                                                                                                                </strong>
                                                                                                                            </div>
                                                                                                                        </div>

                                                                                                                        <div
                                                                                                                            class="metric-card">
                                                                                                                            <div
                                                                                                                                class="metric-label">
                                                                                                                                Average
                                                                                                                                Ticket
                                                                                                                                Value
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="metric-value">
                                                                                                                                ₹
                                                                                                                                <%= String.format("%,.2f",
                                                                                                                                    avgTicket)
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="metric-sub">
                                                                                                                                Total
                                                                                                                                Dispatches:
                                                                                                                                <strong>
                                                                                                                                    <%= totalOrdersCount
                                                                                                                                        %>
                                                                                                                                        Orders
                                                                                                                                </strong>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <% if (!isGlobalMode) { %>
                                                                                                                         <!-- DEDICATED MOST ORDERED FOOD DISHES GRAPH CARD (RESTAURANT ADMIN ONLY) -->
                                                                                                                         <div class="chart-card" style="margin-top: 25px; margin-bottom: 30px; border: 1px solid rgba(0, 240, 255, 0.3); background: rgba(15, 23, 42, 0.85);">
                                                                                                                             <div class="chart-title">
                                                                                                                                 <span style="font-size: 1.15rem; color: #00f0ff; font-weight: 700;">🔥 Restaurant Most Sold Food Items & Order Telemetry (<%= assignedRestName %>)</span>
                                                                                                                                 <span style="font-size: 0.85rem; color: #2ecc71;">Units Sold & Revenue Demand</span>
                                                                                                                             </div>

                                                                                                                             <% if (!topSellingItems.isEmpty()) { 
                                                                                                                                 java.util.Map<String, Object> top1 = topSellingItems.get(0);
                                                                                                                             %>
                                                                                                                                 <div style="background: linear-gradient(135deg, rgba(0, 240, 255, 0.1), rgba(46, 204, 113, 0.1)); border: 1px solid rgba(0, 240, 255, 0.3); border-radius: 12px; padding: 18px 24px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px;">
                                                                                                                                     <div style="display: flex; align-items: center; gap: 16px;">
                                                                                                                                         <img src="<%= top1.get("img") %>" style="width: 55px; height: 55px; border-radius: 10px; object-fit: cover; border: 2px solid #00f0ff;" alt="Top Dish">
                                                                                                                                         <div>
                                                                                                                                             <div style="color: #ff4e50; font-weight: 700; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 1px;">👑 #1 MOST SOLD FOOD ITEM</div>
                                                                                                                                             <div style="color: #fff; font-size: 1.35rem; font-weight: 700;"><%= top1.get("name") %></div>
                                                                                                                                             <div style="color: #94a3b8; font-size: 0.85rem;">Category: <strong style="color: #00f0ff;"><%= top1.get("category") %></strong> | Price: <strong>₹<%= top1.get("price") %></strong></div>
                                                                                                                                         </div>
                                                                                                                                     </div>
                                                                                                                                     <div style="text-align: right;">
                                                                                                                                         <div style="font-size: 1.6rem; color: #2ecc71; font-weight: 700;"><%= top1.get("qty") %> Units Sold</div>
                                                                                                                                         <div style="color: #00f0ff; font-weight: 600; font-size: 0.95rem;">₹<%= String.format("%,.2f", top1.get("sales")) %> Revenue</div>
                                                                                                                                     </div>
                                                                                                                                 </div>
                                                                                                                             <% } %>

                                                                                                                             <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; align-items: center;">
                                                                                                                                 <div>
                                                                                                                                     <canvas id="topDishesBarChart" height="140"></canvas>
                                                                                                                                 </div>
                                                                                                                                 <div>
                                                                                                                                     <div style="font-size: 0.9rem; color: #94a3b8; margin-bottom: 10px; font-weight: 600;">Category Demand Split:</div>
                                                                                                                                     <canvas id="categoryDemandPieChart" height="140"></canvas>
                                                                                                                                 </div>
                                                                                                                             </div>
                                                                                                                         </div>
                                                                                                                     <% } %>

                                                                                                                    <!-- VISUAL ANALYTICS CHARTS GRID -->
                                                                                                                    <div
                                                                                                                        class="charts-grid-3">
                                                                                                                        <div
                                                                                                                            class="chart-card">
                                                                                                                            <div
                                                                                                                                class="chart-title">
                                                                                                                                <span>🏆
                                                                                                                                    <%= profitChartTitle
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                                <span
                                                                                                                                    style="font-size:0.8rem; color:#2ecc71;">
                                                                                                                                    <%= profitChartSubtitle
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                            </div>
                                                                                                                            <canvas
                                                                                                                                id="profitBarChart"
                                                                                                                                height="150"></canvas>
                                                                                                                        </div>

                                                                                                                        <div
                                                                                                                            class="chart-card">
                                                                                                                            <div
                                                                                                                                class="chart-title">
                                                                                                                                <span>💳
                                                                                                                                    Payment
                                                                                                                                    Methods
                                                                                                                                    Breakdown
                                                                                                                                    (COD
                                                                                                                                    vs
                                                                                                                                    UPI)</span>
                                                                                                                                <a href="payments.jsp"
                                                                                                                                    style="font-size:0.8rem; color:#a855f7; text-decoration:none;">View
                                                                                                                                    Ledger
                                                                                                                                    →</a>
                                                                                                                            </div>
                                                                                                                            <canvas
                                                                                                                                id="paymentPieChart"
                                                                                                                                height="150"></canvas>
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <div class="chart-card"
                                                                                                                        style="margin-bottom:30px;">
                                                                                                                        <div
                                                                                                                            class="chart-title">
                                                                                                                            <span>📈
                                                                                                                                Daily
                                                                                                                                Gross
                                                                                                                                Revenue
                                                                                                                                &
                                                                                                                                Order
                                                                                                                                Telemetry</span>
                                                                                                                            <span
                                                                                                                                style="font-size:0.8rem; color:#00f0ff;">Real-time
                                                                                                                                Data
                                                                                                                                Stream</span>
                                                                                                                        </div>
                                                                                                                        <canvas
                                                                                                                            id="revenueTrendChart"
                                                                                                                            height="100"></canvas>
                                                                                                                    </div>

                                                                                                                    <!-- BREAKDOWN TABLES GRID -->
                                                                                                                    <div
                                                                                                                        class="table-grid-2">
                                                                                                                        <!-- RESTAURANT PROFIT LEADERBOARD -->
                                                                                                                        <div
                                                                                                                            class="data-card">
                                                                                                                            <h2
                                                                                                                                class="data-title">
                                                                                                                                🏆
                                                                                                                                <%= leaderboardTitle
                                                                                                                                    %>
                                                                                                                            </h2>
                                                                                                                            <table
                                                                                                                                class="reports-table">
                                                                                                                                <thead>
                                                                                                                                    <tr>
                                                                                                                                        <th>Restaurant
                                                                                                                                            Hub
                                                                                                                                        </th>
                                                                                                                                        <th>Dispatches
                                                                                                                                        </th>
                                                                                                                                        <th>Gross
                                                                                                                                            Yield
                                                                                                                                        </th>
                                                                                                                                        <th>Net
                                                                                                                                            Profit
                                                                                                                                            Share
                                                                                                                                        </th>
                                                                                                                                    </tr>
                                                                                                                                </thead>
                                                                                                                                <tbody>
                                                                                                                                    <% if
                                                                                                                                        (profitReports
                                                                                                                                        !=null
                                                                                                                                        &&
                                                                                                                                        !profitReports.isEmpty())
                                                                                                                                        {
                                                                                                                                        int
                                                                                                                                        rank=1;
                                                                                                                                        for
                                                                                                                                        (RestaurantProfitReport
                                                                                                                                        pr
                                                                                                                                        :
                                                                                                                                        profitReports)
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <% if
                                                                                                                                                    (rank==1)
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <span
                                                                                                                                                        class="highlight-top">🥇
                                                                                                                                                        <%= pr.getRestaurantName()
                                                                                                                                                            %>
                                                                                                                                                    </span>
                                                                                                                                                    <% } else
                                                                                                                                                        if
                                                                                                                                                        (rank==2)
                                                                                                                                                        {
                                                                                                                                                        %>
                                                                                                                                                        <span
                                                                                                                                                            style="color:#e2e8f0;">🥈
                                                                                                                                                            <%= pr.getRestaurantName()
                                                                                                                                                                %>
                                                                                                                                                        </span>
                                                                                                                                                        <% } else
                                                                                                                                                            {
                                                                                                                                                            %>
                                                                                                                                                            <span>
                                                                                                                                                                <%= pr.getRestaurantName()
                                                                                                                                                                    %>
                                                                                                                                                            </span>
                                                                                                                                                            <% }
                                                                                                                                                                %>
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                <%= pr.getTotalOrders()
                                                                                                                                                    %>
                                                                                                                                                    orders
                                                                                                                                            </td>
                                                                                                                                            <td
                                                                                                                                                style="color:#00f0ff; font-weight:600;">
                                                                                                                                                ₹
                                                                                                                                                <%= String.format("%,.2f",
                                                                                                                                                    pr.getTotalRevenue())
                                                                                                                                                    %>
                                                                                                                                            </td>
                                                                                                                                            <td
                                                                                                                                                style="color:#2ecc71; font-weight:600;">
                                                                                                                                                ₹
                                                                                                                                                <%= String.format("%,.2f",
                                                                                                                                                    pr.getEstimatedProfit())
                                                                                                                                                    %>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <% rank++;
                                                                                                                                            }
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                            %>
                                                                                                                                            <tr>
                                                                                                                                                <td colspan="4"
                                                                                                                                                    style="color:var(--muted); text-align:center;">
                                                                                                                                                    No
                                                                                                                                                    restaurant
                                                                                                                                                    yield
                                                                                                                                                    records
                                                                                                                                                    detected.
                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <% }
                                                                                                                                                %>
                                                                                                                                </tbody>
                                                                                                                            </table>
                                                                                                                        </div>

                                                                                                                        <!-- PAYMENT MODE BREAKDOWN TABLE -->
                                                                                                                        <div
                                                                                                                            class="data-card">
                                                                                                                            <h2
                                                                                                                                class="data-title">
                                                                                                                                💳
                                                                                                                                Payment
                                                                                                                                Method
                                                                                                                                Analysis
                                                                                                                            </h2>
                                                                                                                            <table
                                                                                                                                class="reports-table">
                                                                                                                                <thead>
                                                                                                                                    <tr>
                                                                                                                                        <th>Payment
                                                                                                                                            Mode
                                                                                                                                        </th>
                                                                                                                                        <th>Transactions
                                                                                                                                        </th>
                                                                                                                                        <th>Total
                                                                                                                                            Volume
                                                                                                                                        </th>
                                                                                                                                        <th>Share
                                                                                                                                            %
                                                                                                                                        </th>
                                                                                                                                    </tr>
                                                                                                                                </thead>
                                                                                                                                <tbody>
                                                                                                                                    <% if
                                                                                                                                        (paymentReports
                                                                                                                                        !=null
                                                                                                                                        &&
                                                                                                                                        !paymentReports.isEmpty())
                                                                                                                                        {
                                                                                                                                        for
                                                                                                                                        (PaymentMethodReport
                                                                                                                                        pm
                                                                                                                                        :
                                                                                                                                        paymentReports)
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td><strong
                                                                                                                                                    style="color:#fff;">
                                                                                                                                                    <%= pm.getPaymentMode()
                                                                                                                                                        %>
                                                                                                                                                </strong>
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                <%= pm.getTransactionCount()
                                                                                                                                                    %>
                                                                                                                                                    txs
                                                                                                                                            </td>
                                                                                                                                            <td
                                                                                                                                                style="color:#a855f7; font-weight:600;">
                                                                                                                                                ₹
                                                                                                                                                <%= String.format("%,.2f",
                                                                                                                                                    pm.getTotalAmount())
                                                                                                                                                    %>
                                                                                                                                            </td>
                                                                                                                                            <td><span
                                                                                                                                                    style="color:#ec4899; font-weight:600;">
                                                                                                                                                    <%= String.format("%.1f%%",
                                                                                                                                                        pm.getPercentage())
                                                                                                                                                        %>
                                                                                                                                                </span>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <% } }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                            %>
                                                                                                                                            <tr>
                                                                                                                                                <td colspan="4"
                                                                                                                                                    style="color:var(--muted); text-align:center;">
                                                                                                                                                    No
                                                                                                                                                    payment
                                                                                                                                                    method
                                                                                                                                                    records
                                                                                                                                                    detected.
                                                                                                                                                </td>
                                                                                                                                            </tr>
                                                                                                                                            <% }
                                                                                                                                                %>
                                                                                                                                </tbody>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                </div>

                                                                                                                <script>
                                                                                                                    // Restaurant Profitability Bar Chart
                                                                                                                    const restNames = JSON.parse(`<%= restNamesJson.toString() %>`);
                                                                                                                    const restRevenues = JSON.parse(`<%= restRevenuesJson.toString() %>`);
                                                                                                                    const restProfits = JSON.parse(`<%= restProfitsJson.toString() %>`);

                                                                                                                    const ctxProfit = document.getElementById('profitBarChart').getContext('2d');
                                                                                                                    new Chart(ctxProfit, {
                                                                                                                        type: 'bar',
                                                                                                                        data: {
                                                                                                                            labels: restNames.length > 0 ? restNames : ['No Data'],
                                                                                                                            datasets: [
                                                                                                                                {
                                                                                                                                    label: 'Gross Revenue (₹)',
                                                                                                                                    data: restRevenues.length > 0 ? restRevenues : [0],
                                                                                                                                    backgroundColor: '#00f0ff',
                                                                                                                                    borderRadius: 6
                                                                                                                                },
                                                                                                                                {
                                                                                                                                    label: 'Net Profit Yield (₹)',
                                                                                                                                    data: restProfits.length > 0 ? restProfits : [0],
                                                                                                                                    backgroundColor: '#2ecc71',
                                                                                                                                    borderRadius: 6
                                                                                                                                }
                                                                                                                            ]
                                                                                                                        },
                                                                                                                        options: {
                                                                                                                            responsive: true,
                                                                                                                            plugins: { legend: { labels: { color: '#ecf0f1', font: { family: 'Outfit' } } } },
                                                                                                                            scales: {
                                                                                                                                x: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                                                                                                                                y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    });

                                                                                                                    // Payment Method Split Doughnut Chart
                                                                                                                    const payModes = JSON.parse(`<%= payModesJson.toString() %>`);
                                                                                                                    const payAmounts = JSON.parse(`<%= payAmountsJson.toString() %>`);

                                                                                                                    const ctxPayment = document.getElementById('paymentPieChart').getContext('2d');
                                                                                                                    new Chart(ctxPayment, {
                                                                                                                        type: 'doughnut',
                                                                                                                        data: {
                                                                                                                            labels: payModes.length > 0 ? payModes : ['No Data'],
                                                                                                                            datasets: [{
                                                                                                                                data: payAmounts.length > 0 ? payAmounts : [1],
                                                                                                                                backgroundColor: ['#a855f7', '#ec4899', '#3b82f6', '#10b981']
                                                                                                                            }]
                                                                                                                        },
                                                                                                                        options: {
                                                                                                                            responsive: true,
                                                                                                                            plugins: { legend: { position: 'bottom', labels: { color: '#ecf0f1', font: { family: 'Outfit' } } } }
                                                                                                                        }
                                                                                                                    });

                                                                                                                    // Daily Revenue Line Chart
                                                                                                                    const dates = JSON.parse(`<%= datesJson.toString() %>`);
                                                                                                                    const revenues = JSON.parse(`<%= revenueJson.toString() %>`);

                                                                                                                    const ctxLine = document.getElementById('revenueTrendChart').getContext('2d');
                                                                                                                    new Chart(ctxLine, {
                                                                                                                        type: 'line',
                                                                                                                        data: {
                                                                                                                            labels: dates.length > 0 ? dates : ['Today'],
                                                                                                                            datasets: [{
                                                                                                                                label: 'Daily Revenue Yield (₹)',
                                                                                                                                data: revenues.length > 0 ? revenues : [0],
                                                                                                                                borderColor: '#d4a853',
                                                                                                                                backgroundColor: 'rgba(212, 168, 83, 0.15)',
                                                                                                                                borderWidth: 3,
                                                                                                                                fill: true,
                                                                                                                                tension: 0.3,
                                                                                                                                pointBackgroundColor: '#00f0ff',
                                                                                                                                pointRadius: 5
                                                                                                                            }]
                                                                                                                        },
                                                                                                                        options: {
                                                                                                                            responsive: true,
                                                                                                                            plugins: { legend: { labels: { color: '#ecf0f1', font: { family: 'Outfit' } } } },
                                                                                                                            scales: {
                                                                                                                                x: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                                                                                                                                y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    });

                                                                                                                    // Top Selling Dishes Bar Chart
                                                                                                                    const topDishNames = JSON.parse(`<%= topDishNamesJson.toString() %>`);
                                                                                                                    const topDishQty = JSON.parse(`<%= topDishQtyJson.toString() %>`);
                                                                                                                    const topDishSales = JSON.parse(`<%= topDishSalesJson.toString() %>`);

                                                                                                                    const ctxDishes = document.getElementById('topDishesBarChart');
                                                                                                                    if (ctxDishes) {
                                                                                                                        new Chart(ctxDishes.getContext('2d'), {
                                                                                                                            type: 'bar',
                                                                                                                            data: {
                                                                                                                                labels: topDishNames.length > 0 ? topDishNames : ['No Data'],
                                                                                                                                datasets: [
                                                                                                                                    {
                                                                                                                                        label: 'Units Sold',
                                                                                                                                        data: topDishQty.length > 0 ? topDishQty : [0],
                                                                                                                                        backgroundColor: '#00f0ff',
                                                                                                                                        borderRadius: 6
                                                                                                                                    },
                                                                                                                                    {
                                                                                                                                        label: 'Revenue (₹)',
                                                                                                                                        data: topDishSales.length > 0 ? topDishSales : [0],
                                                                                                                                        backgroundColor: '#2ecc71',
                                                                                                                                        borderRadius: 6
                                                                                                                                    }
                                                                                                                                ]
                                                                                                                            },
                                                                                                                            options: {
                                                                                                                                responsive: true,
                                                                                                                                plugins: { legend: { labels: { color: '#ecf0f1', font: { family: 'Outfit' } } } },
                                                                                                                                scales: {
                                                                                                                                    x: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                                                                                                                                    y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        });
                                                                                                                    }

                                                                                                                    // Food Category Order Breakdown Doughnut Chart
                                                                                                                    const topCatNames = JSON.parse(`<%= topCatNamesJson.toString() %>`);
                                                                                                                    const topCatQty = JSON.parse(`<%= topCatQtyJson.toString() %>`);

                                                                                                                    const ctxCat = document.getElementById('categoryDemandPieChart');
                                                                                                                    if (ctxCat) {
                                                                                                                        new Chart(ctxCat.getContext('2d'), {
                                                                                                                            type: 'doughnut',
                                                                                                                            data: {
                                                                                                                                labels: topCatNames.length > 0 ? topCatNames : ['No Data'],
                                                                                                                                datasets: [{
                                                                                                                                    data: topCatQty.length > 0 ? topCatQty : [1],
                                                                                                                                    backgroundColor: ['#ff4e50', '#f9d423', '#00f0ff', '#2ecc71', '#a855f7', '#ec4899']
                                                                                                                                }]
                                                                                                                            },
                                                                                                                            options: {
                                                                                                                                responsive: true,
                                                                                                                                plugins: { legend: { position: 'bottom', labels: { color: '#ecf0f1', font: { family: 'Outfit' } } } }
                                                                                                                            }
                                                                                                                        });
                                                                                                                    }
                                                                                                                </script>
                                                                                                            </body>

                                                                                                            </html>