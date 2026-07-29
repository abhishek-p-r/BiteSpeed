package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.AdminLogDAO;
import com.tap.model.AdminLog;
import com.tap.utility.DBConnection;

public class AdminLogDAOImpl implements AdminLogDAO {

    // ================= SQL QUERIES =================

    private static final String INSERT_LOG =
            "INSERT INTO admin_log(admin_id,action,description,log_time) VALUES(?,?,?,?)";

    private static final String GET_LOG =
            "SELECT * FROM admin_log WHERE log_id=?";

    private static final String GET_LOGS_BY_ADMIN =
            "SELECT * FROM admin_log WHERE admin_id=? ORDER BY log_time DESC";

    private static final String GET_ALL_LOGS =
            "SELECT * FROM admin_log ORDER BY log_time DESC";

    private static final String DELETE_LOG =
            "DELETE FROM admin_log WHERE log_id=?";

    // ================= ADD LOG =================

    @Override
    public void addLog(AdminLog log) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_LOG)) {

            ps.setInt(1, log.getAdminId());
            ps.setString(2, log.getAction());
            ps.setString(3, log.getDescription());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

            int rows = ps.executeUpdate();

            if(rows > 0)
                System.out.println("Log Added Successfully");
            else
                System.out.println("Failed To Add Log");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    // ================= GET LOG =================

    @Override
    public AdminLog getLog(int logId) {

        AdminLog log = null;

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_LOG)) {

            ps.setInt(1, logId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                log = extractLog(rs);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return log;
    }

    // ================= GET LOGS BY ADMIN =================

    @Override
    public List<AdminLog> getLogsByAdmin(int adminId) {

        List<AdminLog> list = new ArrayList<>();

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_LOGS_BY_ADMIN)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                list.add(extractLog(rs));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET ALL LOGS =================

    @Override
    public List<AdminLog> getAllLogs() {

        List<AdminLog> list = new ArrayList<>();

        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_LOGS)) {

            while(rs.next()) {
                list.add(extractLog(rs));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= DELETE LOG =================

    @Override
    public void deleteLog(int logId) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_LOG)) {

            ps.setInt(1, logId);

            int rows = ps.executeUpdate();

            if(rows > 0)
                System.out.println("Log Deleted Successfully");
            else
                System.out.println("Failed To Delete Log");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    // ================= EXTRACT LOG =================

    private AdminLog extractLog(ResultSet rs) throws Exception {

        AdminLog log = new AdminLog();

        log.setLogId(rs.getInt("log_id"));
        log.setAdminId(rs.getInt("admin_id"));
        log.setAction(rs.getString("action"));
        log.setDescription(rs.getString("description"));
        log.setLogTime(rs.getTimestamp("log_time"));

        return log;
    }
}