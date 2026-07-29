package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.AdminDAO;
import com.tap.model.Admin;
import com.tap.utility.DBConnection;

public class AdminDAOImpl implements AdminDAO {

    // ================= ADD ADMIN =================

    @Override
    public void addAdmin(Admin admin) {
        String sql1 = "INSERT INTO admin(name,username,email,password,phone_number,role,active,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?)";
        String sql2 = "INSERT INTO admins(name,username,email,password,phone_number,role,active,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?)";
        
        Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps;
            try {
                ps = con.prepareStatement(sql1);
            } catch (Exception e) {
                ps = con.prepareStatement(sql2);
            }
            try (PreparedStatement statement = ps) {
                statement.setString(1, admin.getName());
                statement.setString(2, admin.getUsername());
                statement.setString(3, admin.getEmail());
                statement.setString(4, admin.getPassword());
                statement.setString(5, admin.getPhoneNumber());
                statement.setString(6, admin.getRole());
                statement.setBoolean(7, admin.isActive());
                statement.setTimestamp(8, now);
                statement.setTimestamp(9, now);
                statement.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= GET ADMIN =================

    @Override
    public Admin getAdmin(int adminId) {
        Admin admin = null;
        String sql1 = "SELECT * FROM admin WHERE admin_id=?";
        String sql2 = "SELECT * FROM admins WHERE admin_id=?";

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps;
            try {
                ps = con.prepareStatement(sql1);
                ps.setInt(1, adminId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) return extractAdmin(rs);
            } catch (Exception e) {
                // Try fallback table name
            }
            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setInt(1, adminId);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) return extractAdmin(rs2);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }

    // ================= GET ADMIN BY EMAIL =================

    @Override
    public Admin getAdminByEmail(String email) {
        Admin admin = null;
        String sql1 = "SELECT * FROM admin WHERE email=?";
        String sql2 = "SELECT * FROM admins WHERE email=?";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) return extractAdmin(rs);
            } catch (Exception e) {
                // Try fallback table
            }
            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setString(1, email);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) return extractAdmin(rs2);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }

    // ================= GET ADMIN BY ID OR EMAIL =================

    @Override
    public Admin getAdminByIdOrEmail(String identifier) {
        if (identifier == null || identifier.trim().isEmpty()) return null;
        String trimmed = identifier.trim();

        // Check if numeric admin ID
        try {
            int adminId = Integer.parseInt(trimmed);
            Admin byId = getAdmin(adminId);
            if (byId != null) return byId;
        } catch (NumberFormatException e) {
            // Not a pure integer, proceed to email/username lookup
        }

        // Try lookup by email
        Admin byEmail = getAdminByEmail(trimmed);
        if (byEmail != null) return byEmail;

        // Try lookup by username or admin_id/email fallback query
        String sql1 = "SELECT * FROM admin WHERE username=? OR email=? OR admin_id=?";
        String sql2 = "SELECT * FROM admins WHERE username=? OR email=? OR admin_id=?";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setString(1, trimmed);
                ps.setString(2, trimmed);
                ps.setString(3, trimmed);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) return extractAdmin(rs);
            } catch (Exception e) {}

            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setString(1, trimmed);
                ps2.setString(2, trimmed);
                ps2.setString(3, trimmed);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) return extractAdmin(rs2);
            } catch (Exception e) {}
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= GET ALL ADMINS =================

    @Override
    public List<Admin> getAllAdmins() {
        List<Admin> list = new ArrayList<>();
        String sql1 = "SELECT * FROM admin";
        String sql2 = "SELECT * FROM admins";

        try (Connection con = DBConnection.getConnection()) {
            try (Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery(sql1)) {
                while (rs.next()) {
                    list.add(extractAdmin(rs));
                }
                return list;
            } catch (Exception e) {
                // Try fallback table name
            }
            try (Statement stmt2 = con.createStatement();
                 ResultSet rs2 = stmt2.executeQuery(sql2)) {
                while (rs2.next()) {
                    list.add(extractAdmin(rs2));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= UPDATE ADMIN =================

    @Override
    public void updateAdmin(Admin admin) {
        String sql1 = "UPDATE admin SET name=?,username=?,email=?,password=?,phone_number=?,role=?,active=?,updated_at=? WHERE admin_id=?";
        String sql2 = "UPDATE admins SET name=?,username=?,email=?,password=?,phone_number=?,role=?,active=?,updated_at=? WHERE admin_id=?";
        Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps;
            try {
                ps = con.prepareStatement(sql1);
            } catch (Exception e) {
                ps = con.prepareStatement(sql2);
            }
            try (PreparedStatement statement = ps) {
                statement.setString(1, admin.getName());
                statement.setString(2, admin.getUsername());
                statement.setString(3, admin.getEmail());
                statement.setString(4, admin.getPassword());
                statement.setString(5, admin.getPhoneNumber());
                statement.setString(6, admin.getRole());
                statement.setBoolean(7, admin.isActive());
                statement.setTimestamp(8, now);
                statement.setInt(9, admin.getAdminId());
                statement.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= DELETE ADMIN =================

    @Override
    public void deleteAdmin(int adminId) {
        String sql1 = "DELETE FROM admin WHERE admin_id=?";
        String sql2 = "DELETE FROM admins WHERE admin_id=?";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sql1)) {
                ps.setInt(1, adminId);
                if (ps.executeUpdate() > 0) return;
            } catch (Exception e) {}
            
            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setInt(1, adminId);
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= EXTRACT ADMIN =================

    private Admin extractAdmin(ResultSet rs) throws Exception {
        Admin admin = new Admin();

        try { admin.setAdminId(rs.getInt("admin_id")); } catch (Exception e) {}
        
        try {
            admin.setName(rs.getString("name"));
        } catch (Exception e) {
            try { admin.setName(rs.getString("full_name")); } catch (Exception ex) {}
        }
        
        try { admin.setUsername(rs.getString("username")); } catch (Exception e) {}
        try { admin.setEmail(rs.getString("email")); } catch (Exception e) {}
        try { admin.setPassword(rs.getString("password")); } catch (Exception e) {}
        
        try {
            admin.setPhoneNumber(rs.getString("phone_number"));
        } catch (Exception e) {
            try { admin.setPhoneNumber(rs.getString("phone")); } catch (Exception ex) {}
        }
        
        try { admin.setRole(rs.getString("role")); } catch (Exception e) {}
        
        try {
            admin.setActive(rs.getBoolean("active"));
        } catch (Exception e) {
            try {
                admin.setActive(rs.getBoolean("is_active"));
            } catch (Exception ex) {
                try { admin.setActive("ACTIVE".equalsIgnoreCase(rs.getString("status"))); } catch (Exception ex2) {}
            }
        }
        
        try { admin.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception e) {}
        try { admin.setUpdatedAt(rs.getTimestamp("updated_at")); } catch (Exception e) {}

        return admin;
    }
}