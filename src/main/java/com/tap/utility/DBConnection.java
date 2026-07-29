package com.tap.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {


    private static final String URL =
            "jdbc:mysql://localhost:3306/tap_foods?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USER = "root";

    private static final String[] PASSWORDS = {
        "Black@hider3306",
        "root",
        "root123",
        "123456",
        "admin",
        "mysql",
        "password",
        ""
    };

    private static String workingPassword = null;

    public static Connection getConnection() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            if (workingPassword != null) {
                try {
                    con = DriverManager.getConnection(URL, USER, workingPassword);
                    if (con != null) return con;
                } catch (SQLException e) {
                    workingPassword = null;
                }
            }

            for (String pass : PASSWORDS) {
                try {
                    con = DriverManager.getConnection(URL, USER, pass);
                    if (con != null) {
                        workingPassword = pass;
                        System.out.println("Database Connected Successfully to tap_foods");
                        ensureSchema(con);
                        return con;
                    }
                } catch (SQLException ignored) {
                    // Try next password
                }
            }

            // Fallback attempt
            con = DriverManager.getConnection(URL, USER, PASSWORDS[0]);

        } catch(ClassNotFoundException e) {
            System.out.println("MySQL Driver Missing");
            e.printStackTrace();
        } catch(SQLException e) {
            System.out.println("Database Connection Failed for tap_foods");
            e.printStackTrace();
        }

        return con;
    }

    private static boolean schemaChecked = false;

    private static synchronized void ensureSchema(Connection con) {
        if (schemaChecked) return;
        schemaChecked = true;
        try (java.sql.Statement st = con.createStatement()) {
            try { st.executeUpdate("ALTER TABLE menu MODIFY COLUMN image_path LONGTEXT"); } catch (Exception ignored) {}
            try { st.executeUpdate("ALTER TABLE menu_items MODIFY COLUMN image LONGTEXT"); } catch (Exception ignored) {}
            try { st.executeUpdate("ALTER TABLE menu_items MODIFY COLUMN image_path LONGTEXT"); } catch (Exception ignored) {}
        } catch (Exception ignored) {}
    }
}