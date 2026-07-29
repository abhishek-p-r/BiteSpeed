package com.tap.utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class SyncMenuItems {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {
            
            System.out.println("=== MENU_ITEMS COLUMNS ===");
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM menu_items LIMIT 1")) {
                ResultSetMetaData meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    System.out.println("  " + meta.getColumnName(i) + " (" + meta.getColumnTypeName(i) + ")");
                }
            }

            stmt.executeUpdate("INSERT IGNORE INTO menu_items (menu_id, restaurant_id, item_name, description, price) SELECT menu_id, restaurant_id, item_name, description, price FROM menu");
            System.out.println("✅ menu_items synced with menu table");

            try {
                stmt.executeUpdate("ALTER TABLE payments MODIFY COLUMN payment_method VARCHAR(50)");
                System.out.println("✅ payments.payment_method expanded to VARCHAR(50)");
            } catch (Exception ex) {
                System.out.println("payments alter note: " + ex.getMessage());
            }

            try {
                stmt.executeUpdate("ALTER TABLE user_address MODIFY COLUMN address_type VARCHAR(20)");
                System.out.println("✅ user_address.address_type expanded to VARCHAR(20)");
            } catch (Exception ex) {
                System.out.println("user_address alter note: " + ex.getMessage());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
