package com.tap.utility;

import java.sql.Date;
import java.util.List;

import com.tap.daoimplementation.UserDAOImpl;
import com.tap.model.User;

public class UserTest {

    public static void main(String[] args) {

        UserDAOImpl dao = new UserDAOImpl();

        // ==========================================
        // ADD USER
        // ==========================================

        User user = new User();

        user.setFullName("Abhishek");
        user.setEmail("abhiuyg@gmail.com");
        user.setPhone("98767873210");
        user.setPassword("Abhi@123");
        user.setGender("Male");
        user.setDob(Date.valueOf("2003-05-15"));
        user.setProfileImage("profile.jpg");
        user.setStatus("ACTIVE");

         dao.addUser(user);

        // ==========================================
        // GET USER BY ID
        // ==========================================

//        System.out.println("===== GET USER =====");
//
//        User u = dao.getUser(1);
//
//        if (u != null) {
//            System.out.println(u);
//        } else {
//            System.out.println("User Not Found");
//        }

        // ==========================================
        // GET USER BY EMAIL
        // ==========================================

//        System.out.println("\n===== GET USER BY EMAIL =====");
//
//        User emailUser = dao.getUserByEmail("abhishek@gmail.com");
//
//        if (emailUser != null) {
//            System.out.println(emailUser);
//        } else {
//            System.out.println("Email Not Found");
//        }

        // ==========================================
        // GET USER BY PHONE
        // ==========================================

//        System.out.println("\n===== GET USER BY PHONE =====");
//
//        User phoneUser = dao.getUserByPhone("9876543210");
//
//        if (phoneUser != null) {
//            System.out.println(phoneUser);
//        } else {
//            System.out.println("Phone Number Not Found");
//        }

        // ==========================================
        // GET ALL USERS
        // ==========================================

//        System.out.println("\n===== ALL USERS =====");
//
//        List<User> users = dao.getAllUsers();
//
//        for (User usr : users) {
//            System.out.println(usr);
//        }

        // ==========================================
        // UPDATE USER
        // ==========================================

//        System.out.println("\n===== UPDATE USER =====");
//
//        User update = dao.getUser(1);
//
//        if (update != null) {
//
//            update.setFullName("Abhishek Rathod");
//            update.setEmail("abhi123@gmail.com");
//            update.setPhone("9999999999");
//            update.setPassword("NewPassword@123");
//            update.setGender("Male");
//            update.setDob(Date.valueOf("2003-05-15"));
//            update.setProfileImage("new_profile.jpg");
//            update.setStatus("ACTIVE");
//
//            // dao.updateUser(update);
//
//            System.out.println("Update Ready");
//        }

        // ==========================================
        // EMAIL EXISTS
        // ==========================================
//
//        System.out.println("\n===== EMAIL EXISTS =====");
//
//        boolean emailExists = dao.emailExists("abhishek@gmail.com");
//
//        System.out.println(emailExists);
//
//        // ==========================================
//        // PHONE EXISTS
//        // ==========================================
//
//        System.out.println("\n===== PHONE EXISTS =====");
//
//        boolean phoneExists = dao.phoneExists("9876543210");
//
//        System.out.println(phoneExists);

        // ==========================================
        // DELETE USER
        // ==========================================

        // dao.deleteUser(1);

//        System.out.println("\nUser Test Completed Successfully.");
    }
}