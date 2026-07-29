package com.tap.daoimplementation;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDAO;
import com.tap.model.Order;
import com.tap.utility.DBConnection;



public class OrderDAOImpl implements OrderDAO {



    private static final String INSERT_ORDER =

            "INSERT INTO orders "
            +
            "(user_id, restaurant_id, address_id, "
            +
            "order_date, total_amount, payment_status, order_status) "
            +
            "VALUES(?,?,?,?,?,?,?)";




    private static final String GET_ORDER =

            "SELECT * FROM orders WHERE order_id=?";




    private static final String GET_ALL =

            "SELECT * FROM orders ORDER BY order_id DESC";




    private static final String GET_BY_USER =

            "SELECT * FROM orders "
            +
            "WHERE user_id=? "
            +
            "ORDER BY order_id DESC";




    private static final String UPDATE_ORDER =

            "UPDATE orders SET "
            +
            "restaurant_id=?, "
            +
            "total_amount=?, "
            +
            "order_status=?, "
            +
            "payment_status=? "
            +
            "WHERE order_id=?";




    private static final String CANCEL_ORDER =

            "UPDATE orders SET "
            +
            "order_status='CANCELLED' "
            +
            "WHERE order_id=?";








    @Override
    public int addOrder(Order order) {


        int orderId = 0;



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(
                                INSERT_ORDER,
                                Statement.RETURN_GENERATED_KEYS
                        )

        ){



            ps.setInt(
                    1,
                    order.getUserId()
            );



            ps.setInt(
                    2,
                    order.getRestaurantId()
            );



            ps.setInt(
                    3,
                    order.getAddressId()
            );



            ps.setTimestamp(
                    4,
                    new Timestamp(
                    System.currentTimeMillis())
            );



            ps.setDouble(
                    5,
                    order.getTotalAmount()
            );



            ps.setString(
                    6,
                    order.getPaymentStatus()
            );



            ps.setString(
                    7,
                    order.getOrderStatus()
            );




            int result =
                    ps.executeUpdate();




            if(result > 0){



                ResultSet rs =
                        ps.getGeneratedKeys();



                if(rs.next()){


                    orderId =
                            rs.getInt(1);

                }


            }




        }
        catch(Exception e){


            e.printStackTrace();


        }




        return orderId;

    }









    @Override
    public Order getOrder(int orderId) {



        Order order = null;



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(GET_ORDER)

        ){



            ps.setInt(
                    1,
                    orderId
            );



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){


                order =
                        extractOrder(rs);


            }



        }
        catch(Exception e){


            e.printStackTrace();

        }




        return order;

    }









    @Override
    public List<Order> getAllOrders() {



        List<Order> orders =
                new ArrayList<>();



        try(
                Connection con =
                        DBConnection.getConnection();


                Statement st =
                        con.createStatement();


                ResultSet rs =
                        st.executeQuery(GET_ALL)

        ){



            while(rs.next()){


                orders.add(
                        extractOrder(rs)
                );

            }


        }
        catch(Exception e){


            e.printStackTrace();

        }



        return orders;

    }

    @Override
    public List<Order> getOrdersByRestaurantId(int restaurantId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE restaurant_id=? ORDER BY order_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }









    @Override
    public List<Order> getOrdersByUser(int userId) {



        List<Order> orders =
                new ArrayList<>();



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(GET_BY_USER)

        ){



            ps.setInt(
                    1,
                    userId
            );



            ResultSet rs =
                    ps.executeQuery();




            while(rs.next()){


                orders.add(
                        extractOrder(rs)
                );

            }



        }
        catch(Exception e){


            e.printStackTrace();

        }



        return orders;

    }









    @Override
    public void updateOrder(Order order) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(UPDATE_ORDER)

        ){



            ps.setInt(
                    1,
                    order.getRestaurantId()
            );



            ps.setDouble(
                    2,
                    order.getTotalAmount()
            );



            ps.setString(
                    3,
                    order.getOrderStatus()
            );



            String pStat = order.getPaymentStatus();
            if (pStat == null || pStat.trim().isEmpty()) {
                pStat = "PENDING";
            }
            ps.setString(4, pStat.trim().toUpperCase());



            ps.setInt(
                    5,
                    order.getOrderId()
            );



            ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    @Override
    public void cancelOrder(int orderId) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(CANCEL_ORDER)

        ){



            ps.setInt(
                    1,
                    orderId
            );



            ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    private Order extractOrder(ResultSet rs)
            throws Exception {



        Order order =
                new Order();



        order.setOrderId(
                rs.getInt("order_id")
        );



        order.setUserId(
                rs.getInt("user_id")
        );



        order.setRestaurantId(
                rs.getInt("restaurant_id")
        );



        order.setAddressId(
                rs.getInt("address_id")
        );



        order.setTotalAmount(
                rs.getDouble("total_amount")
        );



        order.setPaymentStatus(
                rs.getString("payment_status")
        );



        order.setOrderStatus(
                rs.getString("order_status")
        );



        order.setOrderDate(
                rs.getTimestamp("order_date")
        );

        try {
            order.setPaymentMode(rs.getString("payment_mode"));
        } catch (Exception e) {
            order.setPaymentMode("COD");
        }

        return order;

    }

    @Override
    public List<com.tap.model.DailyReport> getDailyAnalysisReports() {
        List<com.tap.model.DailyReport> list = new ArrayList<>();
        String sql = "SELECT DATE(order_date) as day_date, COUNT(*) as order_count, SUM(total_amount) as revenue_sum, AVG(total_amount) as avg_val FROM orders GROUP BY DATE(order_date) ORDER BY day_date DESC";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                com.tap.model.DailyReport report = new com.tap.model.DailyReport();
                report.setDate(rs.getString("day_date"));
                report.setTotalOrders(rs.getInt("order_count"));
                report.setTotalRevenue(rs.getDouble("revenue_sum"));
                report.setAverageOrderValue(rs.getDouble("avg_val"));
                list.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<com.tap.model.RestaurantProfitReport> getRestaurantProfitReports() {
        List<com.tap.model.RestaurantProfitReport> list = new ArrayList<>();
        String sql = "SELECT o.restaurant_id, COALESCE(r.restaurant_name, CONCAT('Restaurant #', o.restaurant_id)) as r_name, COUNT(o.order_id) as total_orders, SUM(o.total_amount) as total_revenue "
                   + "FROM orders o LEFT JOIN restaurants r ON o.restaurant_id = r.restaurant_id "
                   + "GROUP BY o.restaurant_id, r_name ORDER BY total_revenue DESC";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                com.tap.model.RestaurantProfitReport r = new com.tap.model.RestaurantProfitReport();
                r.setRestaurantId(rs.getInt("restaurant_id"));
                r.setRestaurantName(rs.getString("r_name"));
                r.setTotalOrders(rs.getInt("total_orders"));
                double rev = rs.getDouble("total_revenue");
                r.setTotalRevenue(rev);
                r.setEstimatedProfit(rev * 0.25); // 25% profit share yield margin
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<com.tap.model.PaymentMethodReport> getPaymentMethodReports() {
        List<com.tap.model.PaymentMethodReport> list = new ArrayList<>();
        String sql = "SELECT COALESCE(payment_mode, 'COD') as p_mode, COUNT(*) as tx_count, SUM(total_amount) as total_amt FROM orders GROUP BY p_mode ORDER BY total_amt DESC";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            double grandTotal = 0.0;
            List<com.tap.model.PaymentMethodReport> temp = new ArrayList<>();
            while (rs.next()) {
                com.tap.model.PaymentMethodReport pm = new com.tap.model.PaymentMethodReport();
                pm.setPaymentMode(rs.getString("p_mode"));
                pm.setTransactionCount(rs.getInt("tx_count"));
                double amt = rs.getDouble("total_amt");
                pm.setTotalAmount(amt);
                grandTotal += amt;
                temp.add(pm);
            }
            for (com.tap.model.PaymentMethodReport pm : temp) {
                pm.setPercentage(grandTotal > 0 ? (pm.getTotalAmount() / grandTotal) * 100.0 : 0.0);
                list.add(pm);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}