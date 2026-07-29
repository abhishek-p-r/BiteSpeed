package com.tap.utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import com.tap.utility.DBConnection;

public class TestConnection {

    public static void main(String[] args) {
        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("✅ DATABASE CONNECTION PASSED");
            String[] tables = {
                "address", "admin", "admin_logs", "auth_tokens", "coupons",
                "delivery_agents", "delivery_tracking", "email_logs", "email_otp",
                "email_verification", "login_history", "menu", "menu_category",
                "menu_items", "notifications", "order_history", "order_items",
                "orders", "password_reset", "payments", "restaurant_images",
                "restaurants", "reviews", "support_tickets", "system_settings",
                "user", "user_address", "user_addresses"
            };

            for (String table : tables) {
                try (Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                    if (rs.next()) {
                        System.out.println("  ➜ Table '" + table + "': " + rs.getInt(1) + " records found.");
                    }
                } catch (Exception e) {
                    System.out.println("  ⚠️ Table '" + table + "': " + e.getMessage());
                }
            }
        } else {
            System.out.println("❌ DATABASE CONNECTION FAILED");
        }
    }
}