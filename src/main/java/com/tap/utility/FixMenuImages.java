package com.tap.utility;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class FixMenuImages {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             Statement updateStmt = con.createStatement()) {

            System.out.println("Checking menu images in DB...");
            ResultSet rs = stmt.executeQuery("SELECT menu_id, item_name, image_path FROM menu");
            while (rs.next()) {
                int id = rs.getInt("menu_id");
                String name = rs.getString("item_name");
                String img = rs.getString("image_path");
                System.out.println("ID: " + id + " | Name: " + name + " | Image: " + img);

                if (id == 1 && ("chicken.jpg".equals(img) || img == null || img.trim().isEmpty())) {
                    updateStmt.executeUpdate("UPDATE menu SET image_path = '1.jpg' WHERE menu_id = 1");
                    System.out.println("--> Updated Menu ID 1 image_path to 1.jpg");
                }
            }

            // Sync menu_items table with menu table images
            try {
                updateStmt.executeUpdate("ALTER TABLE menu_items ADD COLUMN image_path VARCHAR(255)");
                System.out.println("--> Added image_path column to menu_items");
            } catch (Exception ignored) {}

            try {
                updateStmt.executeUpdate("UPDATE menu_items mi JOIN menu m ON mi.menu_id = m.menu_id SET mi.image = m.image_path, mi.image_path = m.image_path");
                System.out.println("--> Synced menu_items images with menu table");
            } catch (Exception e) {
                try {
                    updateStmt.executeUpdate("UPDATE menu_items mi JOIN menu m ON mi.menu_id = m.menu_id SET mi.image = m.image_path");
                    System.out.println("--> Synced menu_items.image with menu.image_path");
                } catch (Exception ex) {
                    System.out.println("menu_items sync note: " + ex.getMessage());
                }
            }

            // Copy 1.jpg to chicken.jpg in webapp/images if chicken.jpg does not exist
            String[] dirs = {"src/main/webapp/images", "build/images", "bin/images", "WebContent/images"};
            for (String dirPath : dirs) {
                File imgDir = new File(dirPath);
                if (imgDir.exists()) {
                    File srcFile = new File(imgDir, "1.jpg");
                    File destFile = new File(imgDir, "chicken.jpg");
                    if (srcFile.exists() && (!destFile.exists() || destFile.length() == 0)) {
                        copyFile(srcFile, destFile);
                        System.out.println("--> Created chicken.jpg as copy of 1.jpg in " + dirPath);
                    }
                }
            }

            System.out.println("Fix complete!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void copyFile(File src, File dest) {
        try (FileInputStream fis = new FileInputStream(src);
             FileOutputStream fos = new FileOutputStream(dest)) {
            byte[] buf = new byte[8192];
            int len;
            while ((len = fis.read(buf)) > 0) {
                fos.write(buf, 0, len);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
