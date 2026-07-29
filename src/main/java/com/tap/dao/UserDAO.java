package com.tap.dao;

import java.util.List;
import com.tap.model.User;

public interface UserDAO {


    // =========================
    // CREATE USER
    // =========================

    boolean addUser(User user);



    // =========================
    // GET USER
    // =========================

    User getUser(int userId);

    User getUserByEmail(String email);

    User getUserByPhone(String phone);

    List<User> getAllUsers();



    // =========================
    // UPDATE USER
    // =========================

    boolean updateUser(User user);



    // =========================
    // DELETE USER
    // =========================

    void deleteUser(int userId);



    // =========================
    // VALIDATION
    // =========================

    boolean emailExists(String email);

    boolean phoneExists(String phone);



    // =========================
    // LOGIN UPDATE
    // =========================

    void updateLastLogin(int userId);

}