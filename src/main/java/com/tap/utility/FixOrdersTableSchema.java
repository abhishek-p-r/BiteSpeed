package com.tap.utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class FixOrdersTableSchema {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {

            System.out.println("=== ORDERS TABLE COLUMNS ===");
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM orders LIMIT 1")) {
                ResultSetMetaData meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    System.out.println("  " + meta.getColumnName(i) + " (" + meta.getColumnTypeName(i) + " size:" + meta.getColumnDisplaySize(i) + ")");
                }
            }

            // Expand order_status and payment_status columns to VARCHAR(50) if restricted
            try {
                stmt.executeUpdate("ALTER TABLE orders MODIFY COLUMN order_status VARCHAR(50)");
                System.out.println("✅ orders.order_status expanded to VARCHAR(50)");
            } catch (Exception ex) {
                System.out.println("orders.order_status alter note: " + ex.getMessage());
            }

            try {
                stmt.executeUpdate("ALTER TABLE orders MODIFY COLUMN payment_status VARCHAR(50)");
                System.out.println("✅ orders.payment_status expanded to VARCHAR(50)");
            } catch (Exception ex) {
                System.out.println("orders.payment_status alter note: " + ex.getMessage());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
