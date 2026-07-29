package com.tap.utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DescribeTables {
    public static void main(String[] args) {
        Connection con = DBConnection.getConnection();
        if (con == null) {
            System.out.println("DB Connection failed");
            return;
        }

        String[] tables = { "orders", "order_items", "payments", "order_history", "user_address", "user_addresses", "restaurants", "menu" };
        for (String t : tables) {
            System.out.println("=== TABLE: " + t + " ===");
            try (Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM " + t + " LIMIT 1")) {
                ResultSetMetaData meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    System.out.println("  " + meta.getColumnName(i) + " (" + meta.getColumnTypeName(i) + ")");
                }
            } catch (Exception e) {
                System.out.println("  ERROR: " + e.getMessage());
            }
        }
    }
}
