package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderHistoryDAO;
import com.tap.model.OrderHistory;
import com.tap.utility.DBConnection;

public class OrderHistoryDAOImpl implements OrderHistoryDAO {

    private static final String INSERT =
            "INSERT INTO order_history "
            + "(order_id, user_id, total_amount, status, created_date) "
            + "VALUES(?,?,?,?,?)";

    private static final String GET_BY_ID =
            "SELECT * FROM order_history WHERE order_history_id=?";

    private static final String GET_BY_USER =
            "SELECT * FROM order_history WHERE user_id=? ORDER BY order_history_id DESC";

    private static final String GET_ALL =
            "SELECT * FROM order_history ORDER BY order_history_id DESC";

    @Override
    public int addOrderHistory(OrderHistory history) {
        int result = 0;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setInt(1, history.getOrderId());
            ps.setInt(2, history.getUserId());
            ps.setDouble(3, history.getTotalAmount());
            ps.setString(4, history.getStatus());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            result = ps.executeUpdate();

            if (result > 0) {
                System.out.println("Order History Added Successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public OrderHistory getOrderHistory(int historyId) {
        OrderHistory history = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_ID)) {
            ps.setInt(1, historyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                history = extractOrderHistory(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return history;
    }

    @Override
    public List<OrderHistory> getOrderHistoryByUserId(int userId) {
        List<OrderHistory> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_USER)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractOrderHistory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<OrderHistory> getAllOrderHistories() {
        List<OrderHistory> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL)) {
            while (rs.next()) {
                list.add(extractOrderHistory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private OrderHistory extractOrderHistory(ResultSet rs) throws Exception {
        OrderHistory history = new OrderHistory();
        try {
            history.setHistoryId(rs.getInt("order_history_id"));
        } catch (Exception e) {
            try { history.setHistoryId(rs.getInt("history_id")); } catch (Exception ex) {}
        }
        history.setOrderId(rs.getInt("order_id"));
        history.setUserId(rs.getInt("user_id"));
        history.setTotalAmount(rs.getDouble("total_amount"));
        history.setStatus(rs.getString("status"));
        try {
            history.setCreatedDate(rs.getTimestamp("created_date"));
        } catch (Exception e) {
            try { history.setCreatedDate(rs.getTimestamp("order_date")); } catch (Exception ex) {}
        }
        return history;
    }
}